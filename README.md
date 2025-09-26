
# Code4All

Aplicativo de apoio social para inclusão digital: permite que pessoas escrevam código no papel, tirem uma foto com o celular e recebam feedback automático via LLM para verificar se o código está correto.

---

## Índice

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Arquitetura / Estrutura de Pastas](#arquitetura--estrutura-de-pastas)
- [Tecnologias / Dependências](#tecnologias--dependências)
- [Injeção de Dependências por Feature](#injeção-de-dependências-por-feature)
- [Contribuição](#contribuição)
- [Execução / Setup](#execução--setup)
- [Testes](#testes)
- [Roadmap / Próximos Passos](#roadmap--próximos-passos)
- [Licença](#licença)

---

## Visão Geral

O **Code4All** é uma iniciativa social que visa reduzir barreiras de acesso ao aprendizado de programação em comunidades com poucos recursos.

Fluxo de funcionamento:

1. O usuário escreve código (Python, JavaScript, C etc.) em papel.
2. Tira uma foto pelo aplicativo.
3. O backend processa a imagem com OCR, converte em texto/código e envia para uma LLM.
4. A LLM avalia o código e retorna feedback com erros, acertos e sugestões.

O objetivo não é apenas corrigir, mas **ensinar**, **explicar os erros** e **estimular o aprendizado contínuo**.

---

## Funcionalidades

- Captura de imagem / foto do código
- Reconhecimento de caracteres (OCR)
- Integração com LLM para análise do código
- Feedback com explicações detalhadas e sugestões
- Histórico de códigos enviados
- Interface leve, acessível e multiplataforma
- Suporte a várias linguagens de programação
- Possibilidade futura de modo offline

---

## Arquitetura / Estrutura de Pastas

Organização modular, com cada *feature* tendo suas próprias camadas, estado e injeção de dependências:

```
/code4all
│
├── android/  
├── ios/  
├── lib/  
│   ├── core/  
│   │   ├── errors/  
│   │   ├── utils/  
│   │   └── models/  
│   ├── features/  
│   │   └── analyze_code/  
│   │       ├── data/  
│   │       │   ├── datasources/  
│   │       │   ├── repositories/  
│   │       │   └── mappers/  
│   │       ├── domain/  
│   │       │   ├── entities/  
│   │       │   ├── usecases/  
│   │       │   └── services/  
│   │       ├── presentation/  
│   │       │   ├── stores/        # MobX stores (estado e ações)  
│   │       │   ├── pages/         # Telas da feature  
│   │       │   └── widgets/       # Widgets específicos  
│   │       └── injection/         # Injeção de dependências da feature  
│   │           └── analyze_code_injection.dart  
│   ├── app.dart                   # Configuração global do app  
│   └── routes.dart                # Rotas principais  
│
├── test/  
│   └── features/  
│       └── analyze_code/  
│           ├── domain/  
│           └── data/  
│
├── .gitignore  
├── pubspec.yaml  
└── README.md  
```

---

## Tecnologias / Dependências

- **Flutter**: framework multiplataforma para Android e iOS
- **MobX**: gerenciamento de estado reativo
- **GetIt**: injeção de dependências
- **OCR**: Tesseract, ML Kit ou APIs equivalentes
- **LLM / IA**: OpenAI, Llama ou outro modelo de linguagem
- **HTTP**: para comunicação com backend
- **Testes**: `flutter_test`, mocks e testes de integração

---

## Injeção de Dependências por Feature

Cada *feature* gerencia suas próprias dependências, incluindo *repositories*, *usecases* e *stores*.

Exemplo em `analyze_code_injection.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../data/repositories/analyze_code_repository_impl.dart';
import '../domain/usecases/analyze_code_usecase.dart';
import '../presentation/stores/analyze_code_store.dart';

final sl = GetIt.instance;

void initAnalyzeCodeModule() {
  // Repositório
  sl.registerLazySingleton<AnalyzeCodeRepository>(
    () => AnalyzeCodeRepositoryImpl(),
  );

  // UseCase
  sl.registerLazySingleton(
    () => AnalyzeCodeUseCase(sl()),
  );

  // Store (MobX)
  sl.registerFactory(
    () => AnalyzeCodeStore(sl()),
  );
}
```

No `main.dart`, basta chamar `initAnalyzeCodeModule()` para inicializar a feature.

---

## Contribuição

Para contribuir:

1. Faça um *fork* do projeto
2. Crie uma *branch* com sua feature:
   ```bash
   git checkout -b feature/minha-feature
   ```  
3. Commit suas alterações:
   ```bash
   git commit -m "Minha nova feature"
   ```  
4. Push para a branch:
   ```bash
   git push origin feature/minha-feature
   ```  
5. Abra um *Pull Request*

---

## Execução / Setup

1. Clone o repositório:
   ```bash
   git clone <url-do-repo>
   ```  
2. Instale dependências:
   ```bash
   flutter pub get
   ```  
3. Configure as chaves da API no `.env`
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

---

## Testes

- **Unit tests**: regras de negócio e usecases
- **Widget tests**: componentes e telas
- **Integration tests**: fluxo completo da feature

Executando todos os testes:
```bash
flutter test
```

---

## Roadmap / Próximos Passos

- [ ] Suporte a múltiplas linguagens
- [ ] Feedback com exemplos de código corretos
- [ ] Gamificação (pontuação, conquistas)
- [ ] Modo offline
- [ ] Internacionalização

---

## Licença

Este projeto está licenciado sob a **MIT License**.
