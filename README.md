# currencyConverter

Um aplicativo simples para converter moedas. As cotações são obtidas por uma API e armazenadas em cache. O usuário pode escolher entre várias moedas e fazer conversões.

---

- Arquitetura **MVVM-C**
- **ViewCoding**
- **CoreData**
- **Testes unitários**

---

## Funcionalidades

- Conversão de moedas usando a **API CurrencyLayer**
- Filtro de moedas por código ou nome
- Pesquisa de moedas com **autocompletar**
- Funciona **online e offline**

---

## Notas Importantes

Este é um aplicativo existente que foi aprimorado. O foco deve ser fluxo da **Home Flow** e **Network layer**.

---

## Home Flow

- **Padrão MVVM**: Separação clara entre interface (`HomeView`), lógica de negócios (`HomeConvertViewModel`) e coordenação (`HomeViewController`)
- **Injeção de Dependência**: Componentes usam protocolos para facilitar testes
- **Gerenciamento de Estado**: `ConversionStateManager` controla os estados da view, sucesso ou erro com binds

---

## Network layer

- **Baseada em Protocolos**: `NetworkTarget`, `NetworkServiceProtocol`, `CurrencyServiceProtocol`
