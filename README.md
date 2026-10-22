# Sistema de Gerenciamento de Competições Escolares

Aplicativo mobile desenvolvido em **Flutter** para a disciplina de **Laboratório de Engenharia de Software** da **Faculdade de Tecnologia de Itapetininga (Fatec)** — Centro Paula Souza.

## Sobre o projeto

Sistema para gerenciamento de competições esportivas escolares, visando otimizar o controle de equipes, jogadores, partidas e informações administrativas, promovendo maior organização, eficiência e confiabilidade dos dados.

**Cliente:** Allan Ronzio — organização de competições esportivas escolares (Itapetininga/SP)

### Equipe técnica

- Felipe Queiroz Vieira
- Lucas Lopes de Medeiros
- Ludimila Liberali Masuda

## Tecnologias

| Camada | Tecnologia |
|--------|------------|
| Linguagem | Dart |
| Framework | Flutter 3.47 |
| Banco de dados local | SQLite (`sqflite`) |
| Gerenciamento de caminhos | `path`, `path_provider` |
| Versionamento | Git / GitHub |

## Estrutura do código

O projeto segue o padrão **MVC** (Model-View-Controller) trabalhado em sala de aula:

```
lib/
├── main.dart                              # Ponto de entrada (MyApp -> Menu)
├── model/
│   └── competicao.dart                    # Entidade Competição (toMap / fromMap)
├── control/
│   └── control_competicao.dart            # Regras de acesso ao banco (SQLite)
├── telas/
│   ├── menu.dart                          # Menu principal
│   ├── tela_adicionar_competicao.dart     # Cadastro de competições
│   └── tela_consulta_competicao.dart      # Consulta de competições
└── widgets/
    ├── widget_input.dart                  # Campo de texto reutilizável
    ├── widget_button.dart                 # Botão reutilizável
    └── widget_text_custom.dart            # Texto reutilizável
```

## Funcionalidades implementadas

- [x] Menu principal com navegação
- [x] Cadastro de competições (nome, cidade, data de início, data de término)
- [x] Consulta de competições com filtro por nome
- [x] Persistência em banco de dados local SQLite

## Funcionalidades planejadas

- [ ] Cadastro de modalidades e categorias
- [ ] Cadastro de escolas participantes
- [ ] Cadastro de times
- [ ] Cadastro de jogadores e responsáveis
- [ ] Inscrição de jogadores em times
- [ ] Cadastro de técnicos e vínculo com times
- [ ] Gerenciamento de rodadas
- [ ] Registro de partidas, escalações e eventos
- [ ] Controle de suspensões
- [ ] Controle de pagamentos de inscrição
- [ ] Relatórios gerenciais

## Como executar

### Pré-requisitos

- Flutter SDK 3.47 ou superior
- Android Studio ou VS Code com as extensões Flutter/Dart
- Emulador Android/iOS ou dispositivo físico

### Passo a passo

```bash
# Clonar o repositório
git clone https://github.com/lucas1046/ProjetoCompeticao.git
cd ProjetoCompeticao

# Baixar as dependências
flutter pub get

# Verificar erros de análise
flutter analyze

# Rodar os testes
flutter test

# Executar no emulador/dispositivo
flutter run
```

## Status do projeto

| Item | Status |
|------|--------|
| Documentação de requisitos | Em andamento |
| Banco de dados (SQLite) | Implementado |
| CRUD de competições | Implementado |
| Demais CRUDs | Planejado |
| Testes automatizados | Implementado (3 testes) |

## Licença

Projeto acadêmico — Faculdade de Tecnologia de Itapetininga (Fatec), 2026.
