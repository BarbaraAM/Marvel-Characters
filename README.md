

# Marvel API App com SwiftData

Este aplicativo consome a API da Marvel para exibir personagens e permite a persistência de dados usando SwiftData. Utilizamos o padrão MVVM-C (Model-View-ViewModel-Coordinator) para organizar a arquitetura. Além disso, o projeto inclui testes unitários para garantir a qualidade e estabilidade das principais funcionalidades.

## Decisões de Arquitetura

### Coordinator Pattern
O `AppCoordinator` gerencia os fluxos de navegação da aplicação, separando a lógica de navegação das `ViewModels` e `ViewControllers`. Embora eu compreenda o conceito do `Coordinator`, ainda estou trabalhando para entender completamente como ele se integra com as `ViewModels` e gerencia o ciclo de vida da aplicação.

## Estrutura do Projeto

### Views
- **ListViewController**:
  - Listagem de personagens favoritados sem internet.
  - Interface limpa e minimalista.
  - Swipe actions para favoritar/desfavoritar personagens.
  - Exibe a imagem do personagem e inclui uma barra de pesquisa.
  - Um alerta e um botão "Tentar novamente" aparecem em caso de falta de conexão com a internet.
  - Um ícone de favorito indica os personagens selecionados.

- **CharacterDetailViewController**:
  - Permite favoritar/desfavoritar o personagem, atualizando automaticamente a lista.
  - Mostra a imagem do personagem e permite compartilhá-la via botão.
  - Textos longos (como Comics e Series) são tratáveis clicando para visualização completa.

### ViewModels
- **ListViewModel**:
  - Gerencia a lógica de busca de personagens através de `CharacterService`.
  - Trata erros e apresenta mensagem amigável ao usuário.
  - Filtra personagens para a lista de acordo com a busca.

- **DetailViewModel**:
  - Lida com o compartilhamento da imagem do personagem usando `UIActivityViewController` através do `Coordinator`.

## Models

### CharacterService
A API da Marvel requer um tratamento específico para autenticação. É necessário enviar a `public key`, `private key`, `timestamp` (milissegundos do horário atual), e um hash MD5 para cada requisição. Esses elementos são combinados em uma URL para garantir uma autenticação segura.

### Tratamento de Erros e Dados
Como algumas respostas da API contêm campos de data que podem ser `nil`, precisei implementar um `do-catch` para lidar com possíveis erros de parsing. Isso assegura que a aplicação não falhe ao processar respostas incompletas.

### Decoding e Armazenamento
- A resposta da API é decodificada na struct `MarvelResponse`, que contém a estrutura `data` e, por fim, é mapeada para a struct `MarvelCharacterDecoder`.
- A struct `MarvelCharacterDecoder` é utilizada para decodificar os dados da API e posteriormente converter as relações para `MarvelCharacterStorage` (usando SwiftData).

### Boas Práticas na Decodificação
Ao lidar com SwiftData, não é recomendável decodificar os dados diretamente na `@Model` de armazenamento. Por isso, a solução adota duas estruturas: uma struct (`MarvelCharacterDecoder`) para decodificar os dados da API e outra (`MarvelCharacterStorage`) para armazenar os dados localmente. Esta abordagem facilita a conversão e manipulação dos dados entre a API e o armazenamento local, mantendo o código mais limpo, desacoplado e sem crashs do SwiftData.

## Unit Tests

As principais funcionalidades que demandam testes são o request para a API, o salvamento, a exclusão e a busca no SwiftData, além de favoritar e desfavoritar personagens. Como a conversão de `MarvelCharacterDecoder` para `MarvelCharacterStorage` é crítica para o funcionamento do app, erros nesse processo podem causar falhas.

- Para a API, criei um mock que herda de `URLSessionProtocol`, permitindo simular as requisições e testar a formação correta da URL, incluindo a comparação de `public key`, `private key`, domínio e endpoint. Os testes estão implementados no arquivo `CharactersServiceTests`.
- Para o SwiftData, desenvolvi um mock que herda do protocolo `CharacterSwiftDataManaging`. As funções desse protocolo são reutilizadas na classe de gerenciamento real do SwiftData. O mock simula o contexto do SwiftData, permitindo testar todas as funcionalidades, como salvar, deletar, buscar e verificar se um personagem foi favoritado, além da conversão de `MarvelCharacterDecoder` para `MarvelCharacterStorage`.
- Criei duas classes de teste:
  - `CharactersSwiftDataTests`: foca nas funcionalidades de persistência, como salvar, deletar e buscar no SwiftData.
  - `CharactersFavoritesTests`: gerencia os testes de favoritar/desfavoritar e a conversão da struct `Decoder` para `Storage`.

## UI Details

Para facilitar a personalização da interface do app, utilizei extensões que cuidam da adição de fontes, backgrounds, `tableViews`, e da `navigationBar`.

- A responsividade foi ajustada para iPad e iPhone, com uma lógica que adapta o tamanho da fonte por meio de um protocolo chamado `UIColorGlobalAppearance`.
- A fonte escolhida foi "Avenir" devido à variedade de estilos, como bold, italic, medium, e regular, proporcionando flexibilidade na identidade visual do app.

### iPad
![image alt](https://github.com/BarbaraAM/Marvel-Characters/blob/22e8f17069761d75867d263937a6da67621d2930/iPad.PNG)

### Iphone
![image alt](https://github.com/BarbaraAM/Marvel-Characters/blob/22e8f17069761d75867d263937a6da67621d2930/iPhone.PNG)

