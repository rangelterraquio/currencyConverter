//
//  NetworkClient.swift
//  CurrencyConverter
//
//  Created by Rangel Cardoso Dias on 12/07/25
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ target: NetworkTarget,
                              responseType: T.Type,
                              configuration: RequestConfiguration?,
                              completion: @escaping (Result<T, Error>) -> Void)
    
    func request(_ target: NetworkTarget,
                configuration: RequestConfiguration?,
                completion: @escaping (Result<Data?, Error>) -> Void)
}

final class NetworkClient: NetworkClientProtocol {
    
    private let session: URLSessionProtocol
    private let configuration: NetworkConfiguration
    private let interceptors: [NetworkInterceptor]
    private let errorMapper: ErrorMapperProtocol
    private let requestBuilder: NetworkRequestBuilderProtocol
    
    // MARK: - Initialization
    init(session: URLSessionProtocol = URLSessionWrapper(),
         configuration: NetworkConfiguration = .default,
         interceptors: [NetworkInterceptor]? = nil,
         errorMapper: ErrorMapperProtocol = ErrorMapper(),
         requestBuilder: NetworkRequestBuilderProtocol = NetworkRequestBuilder()) {
        
        self.session = session
        self.configuration = configuration
        self.errorMapper = errorMapper
        self.requestBuilder = requestBuilder
        
        if let interceptors = interceptors {
            self.interceptors = interceptors
        } else {
            self.interceptors = [
                LoggingInterceptor(isEnabled: configuration.enableLogging),
            ]
        }
    }
    
    func request<T: Decodable>(_ target: NetworkTarget,
                              responseType: T.Type,
                              configuration: RequestConfiguration? = nil,
                              completion: @escaping (Result<T, Error>) -> Void) {
        
        request(target, configuration: configuration) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                do {
                    let decodedObject = try T.decode(from: data)
                    completion(.success(decodedObject))
                } catch {
                    let mappedError = self.errorMapper.map(error)
                    completion(.failure(mappedError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func request(_ target: NetworkTarget,
                configuration: RequestConfiguration? = nil,
                completion: @escaping (Result<Data?, Error>) -> Void) {
        
        do {
            let request = try requestBuilder.buildRequest(target: target,
                                                        networkConfig: self.configuration,
                                                        requestConfig: configuration)
            
            executeRequest(request, retryCount: 0, completion: completion)
            
        } catch {
            let mappedError = errorMapper.map(error)
            completion(.failure(mappedError))
        }
    }
    
    // MARK: - Private Methods
    private func executeRequest(_ request: URLRequest,
                               retryCount: Int = 0,
                               completion: @escaping (Result<Data?, Error>) -> Void) {
        
        // Apply request interceptors
        let interceptedRequest = interceptors.reduce(request) { currentRequest, interceptor in
            return interceptor.intercept(request: currentRequest, configuration: configuration)
        }
        
        // Execute the request
        session.dataTask(with: interceptedRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            let httpResponse = response as? HTTPURLResponse
            
            // Apply response interceptors
            let interceptionResult = self.processResponseInterceptors(
                response: httpResponse,
                data: data,
                error: error,
                for: interceptedRequest
            )
            
            switch interceptionResult {
            case .proceed(let data, let error):
                if let error = error {
                    let mappedError = self.errorMapper.map(error)
                    completion(.failure(mappedError))
                } else {
                    completion(.success(data))
                }
                
            case .retry(let delay):
               // TODO: Implement retry
                completion(.failure(errorMapper.map(NetworkError.timeout)))
                
            case .fail(let error):
                let mappedError = self.errorMapper.map(error)
                completion(.failure(mappedError))
            }
            
        }.resume()
    }
    
    private func processResponseInterceptors(response: HTTPURLResponse?,
                                           data: Data?,
                                           error: Error?,
                                           for request: URLRequest) -> InterceptionResult {
        
        for interceptor in interceptors {
            let result = interceptor.intercept(response: response, data: data, error: error, for: request)
            
            switch result {
            case .retry, .fail:
                return result
            case .proceed:
                continue
            }
        }
        
        return .proceed(data: data, error: error)
    }
}

// MARK: - URLSession Protocol (necessary for make easy to test)
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

// MARK: - URLSession Wrapper (necessary for make easy to test)
final class URLSessionWrapper: URLSessionProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return URLSessionDataTaskWrapper(
            task: session.dataTask(with: request, completionHandler: completionHandler)
        )
    }
}

final class URLSessionDataTaskWrapper: URLSessionDataTaskProtocol {
    private let task: URLSessionDataTask
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    func resume() {
        task.resume()
    }
}

// MARK: - Network Request Builder Protocol
protocol NetworkRequestBuilderProtocol {
    func buildRequest(target: NetworkTarget,
                     networkConfig: NetworkConfiguration,
                     requestConfig: RequestConfiguration?) throws -> URLRequest
}

final class NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    
    func buildRequest(target: NetworkTarget,
                     networkConfig: NetworkConfiguration,
                     requestConfig: RequestConfiguration?) throws -> URLRequest {
        
        let url = networkConfig.environment.baseURL.appendingPathComponent(target.path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        // Add query parameters if any
        if let queryParameters = target.queryParameters {
            var queryItems = urlComponents?.queryItems ?? []
            for (key, value) in queryParameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents?.queryItems = queryItems
        }
        
        guard let finalURL = urlComponents?.url else {
            throw NetworkError.invalidResponse
        }
        
        // Create the request
        var request = URLRequest(url: finalURL)
        request.httpMethod = target.method.rawValue
        
        // Add headers
        if let headers = target.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add additional headers from configuration
        if let additionalHeaders = requestConfig?.additionalHeaders {
            for (key, value) in additionalHeaders {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body if needed
        if let body = target.body {
            request.httpBody = body
        }
        
        return request
    }
}
