# GifApp - Flutter GIF Search & Favorites App

Um aplicativo Flutter completo para buscar, visualizar e favoritar GIFs usando a API do Giphy. Implementado com arquitetura em camadas, persistência local e gerenciamento de estado robusto.

## Funcionalidades

### Busca de GIFs
- Grid responsivo de GIFs trending da API Giphy
- Busca com debounce de 500ms para otimização
- Histórico de buscas persistido localmente
- Sugestões de buscas recentes
- Paginação infinita (lazy loading)

### Estados da UI
- **Loading**: Indicador animado durante carregamento
- **Empty**: Mensagem amigável quando não há resultados
- **Error**: Tela de erro com botão "Tentar novamente"
- **Loaded**: Grid responsivo de GIFs

### Favoritos
- Adicionar/remover GIFs dos favoritos
- Tela dedicada de favoritos
- Persistência local com Hive
- Feedback visual ao favoritar

### Configurações
- Tema claro/escuro com persistência
- Seleção de idioma (en, pt, es)
- Quantidade de itens por página (10, 20, 30, 50)
- Toggle de autoplay de GIFs
- Filtro de classificação etária (G, PG, PG-13, R)
- Limpar histórico de buscas

### Design Responsivo
- 2 colunas no mobile
- 3 colunas em tablets
- 4 colunas em desktop
- Grid masonry para melhor aproveitamento do espaço

## Arquitetura

O projeto segue uma arquitetura em camadas clean, separando responsabilidades:

```
lib/
├── core/
│   ├── constants/       # Constantes da aplicação
│   ├── theme/          # Temas claro e escuro
│   └── utils/          # Utilitários (debouncer)
├── data/
│   ├── models/         # Modelos de dados (GIF, Settings)
│   ├── repositories/   # Camada de acesso a dados
│   └── services/       # Serviços de API (Giphy)
├── presentation/
│   ├── pages/          # Telas do app
│   ├── widgets/        # Widgets reutilizáveis
│   └── state/          # Providers (state management)
└── main.dart           # Ponto de entrada
```

### Camadas

**Core**: Configurações, constantes e utilitários compartilhados

**Data**: Lógica de dados, API e persistência
- `models/`: Classes de domínio com serialização
- `services/`: Comunicação com APIs externas
- `repositories/`: Abstração de fontes de dados

**Presentation**: UI e gerenciamento de estado
- `pages/`: Telas completas
- `widgets/`: Componentes reutilizáveis
- `state/`: Providers para gerenciamento de estado

## Tecnologias e Bibliotecas

### Principais Dependências

| Biblioteca | Versão | Propósito |
|-----------|--------|-----------|
| `dio` | ^5.4.0 | Cliente HTTP para requisições à API |
| `hive` | ^2.2.3 | Banco de dados NoSQL local |
| `hive_flutter` | ^1.1.0 | Integração Hive com Flutter |
| `provider` | ^6.1.1 | Gerenciamento de estado |
| `flutter_spinkit` | ^5.2.0 | Indicadores de loading animados |
| `flutter_staggered_grid_view` | ^0.7.0 | Grid responsivo masonry |
| `cached_network_image` | ^3.3.1 | Cache de imagens |
| `intl` | ^0.19.0 | Internacionalização |

### Dev Dependencies

- `hive_generator`: Geração de TypeAdapters
- `build_runner`: Build system
- `flutter_lints`: Linting

## Decisões Técnicas

### 1. Hive para Persistência Local
Escolhido por:
- Performance superior (NoSQL puro em Dart)
- Sem dependências nativas
- TypeSafe com code generation
- Perfeito para dados estruturados pequenos

### 2. Provider para State Management
Escolhido por:
- Simplicidade e curva de aprendizado suave
- Integração nativa com Flutter
- Suficiente para a complexidade do app
- Facilita testes

### 3. Dio ao invés de HTTP
Escolhido por:
- Interceptors nativos
- Timeout configurável
- Melhor tratamento de erros
- Mais features out-of-the-box

### 4. Debounce na Busca
Implementado para:
- Reduzir chamadas à API
- Melhorar performance
- Economizar quota da API
- Melhor UX (não busca a cada tecla)

### 5. Grid Masonry
Escolhido por:
- GIFs têm tamanhos variados
- Melhor aproveitamento de espaço
- Visual mais interessante
- Responsividade automática

### 6. Cached Network Image
Escolhido por:
- Cache automático de GIFs
- Reduz uso de banda
- Melhora performance
- Placeholders customizáveis

## Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK 3.9.0 ou superior
- Dart SDK 3.9.0 ou superior

### Instalação

1. Clone o repositório:
```bash
git clone <repo-url>
cd gif_app
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Gere os TypeAdapters do Hive:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Execute o app:
```bash
flutter run
```

### Plataformas Suportadas
- Android
- iOS
- Web
- Windows
- macOS
- Linux

## Estrutura de Dados

### GifModel
```dart
class GifModel {
  String id;
  String title;
  String url;
  String? previewUrl;
  int? width;
  int? height;
  String rating;
  DateTime addedAt;
}
```

### UserSettings
```dart
class UserSettings {
  bool isDarkMode;
  String language;
  int itemsPerPage;
  bool autoPlay;
  String rating;
}
```

## API Giphy

O app usa a API pública do Giphy:
- Endpoint Trending: `/v1/gifs/trending`
- Endpoint Search: `/v1/gifs/search`
- API Key incluída (demo purposes)
- Rate limit: 42 requests/hour (free tier)

## Próximos Passos e Melhorias

### Funcionalidades
- [ ] Compartilhar GIFs
- [ ] Copiar link do GIF
- [ ] Download de GIFs
- [ ] Categorias/Tags populares
- [ ] GIFs relacionados
- [ ] Preview em fullscreen
- [ ] Animações de transição

### Técnicas
- [ ] Testes unitários
- [ ] Testes de widget
- [ ] Testes de integração
- [ ] CI/CD pipeline
- [ ] Melhor tratamento de erros
- [ ] Retry automático com exponential backoff
- [ ] Analytics
- [ ] Crash reporting

### UX/UI
- [ ] Skeleton loading
- [ ] Pull-to-refresh
- [ ] Swipe gestures
- [ ] Haptic feedback
- [ ] Mais opções de tema
- [ ] Onboarding para novos usuários
- [ ] Tutoriais in-app

### Performance
- [ ] Pré-carregamento de imagens
- [ ] Virtual scrolling otimizado
- [ ] Compressão de cache
- [ ] Lazy loading de thumbnails

## Licença

Este projeto é um exemplo educacional baseado no projeto jeffersonspeck/gif_flutter.

## Autor

Desenvolvido como exemplo de arquitetura Flutter com clean code e boas práticas.
