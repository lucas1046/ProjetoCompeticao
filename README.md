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
| Autenticação | SHA-256 com sal (`crypto`) |
| Relatórios em PDF | `pdf` + `printing` |
| Versionamento | Git / GitHub |

## Estrutura do código

O projeto segue o padrão **MVC** (Model-View-Controller) trabalhado em sala de aula:

```
lib/
├── main.dart                        # Ponto de entrada (abre no login ou no menu)
├── model/                           # 20 entidades + usuario.dart (toMap / fromMap)
├── control/                         # Regras de acesso ao banco (SQLite)
│   ├── banco_dados.dart             # Helper do banco (21 tabelas, migrações)
│   ├── control_relatorio.dart       # Estatísticas e relatórios (RF-14 e RF-15)
│   └── control_sessao.dart          # Sessão do usuário logado
├── telas/                           # Telas de cadastro, consulta e relatórios
├── util/
│   ├── validacoes.dart              # CPF, data, idade, imagem
│   ├── seguranca.dart               # Hash de senha
│   ├── guarda_permissao.dart        # Bloqueio das telas restritas
│   ├── financeiro.dart              # Status pago / parcial / pendente
│   ├── gerador_pdf.dart             # Geração dos PDFs (Android/desktop)
│   └── exportacao.dart              # Salvar e compartilhar o PDF
└── widgets/                         # Componentes reutilizáveis
    ├── widget_input.dart            # InputTextos(rotulo, label, {controller, senha})
    ├── widget_button.dart           # Buttons(texto, {onPressed})
    └── widget_text_custom.dart      # TextosCustom(texto, fontSize, cor)

assets/fonts/                        # Roboto (Apache 2.0), usada nos PDFs
```

## Acesso ao sistema

O app abre na **tela de login**. O primeiro acesso usa o administrador criado
automaticamente na instalação:

| Login | Senha | Perfil |
|-------|-------|--------|
| `admin` | `admin123` | Administrador |

> Troque a senha depois do primeiro acesso. Novos usuários podem ser cadastrados
> por um administrador (`ControlUsuario.cadastrarComSenha`).

Perfis:

- **ADMIN** — acesso total, incluindo relatório financeiro e dados restritos
- **USUARIO** — cadastros e relatórios gerais

A sessão fica em memória: ao fechar o app é preciso autenticar de novo.

## Funcionalidades implementadas

- [x] Login e controle de acesso por perfil
- [x] Menu principal com navegação
- [x] CRUD completo das 20 entidades (competição, modalidade, categoria, tipo de evento, posição, responsável, jogador, documento, escola, técnico, time, foto, técnico/time, inscrição, pagamento, rodada, partida, escalação, evento e suspensão)
- [x] Estatísticas de jogadores (gols, cartões, craque da partida, jogos)
- [x] Relatórios gerenciais: classificação geral, financeiro, histórico de partidas e suspensos
- [x] Exportação dos 5 relatórios em PDF, com compartilhamento pelo sistema
- [x] Status financeiro por inscrição (pago, parcial, pendente)
- [x] Validação de CPF, datas, idade por categoria e demais regras de negócio
- [x] Persistência em banco de dados local SQLite

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

# Gerar o APK
flutter build apk --release
```

## Status do projeto

| Item | Status |
|------|--------|
| Documentação de requisitos | Entregue (Etapa 02) |
| Banco de dados (SQLite) | Implementado (21 tabelas) |
| CRUDs das 20 entidades | Implementado |
| Regras de negócio (RNFRs) | Implementado (35 de 35) |
| Login e controle de acesso | Implementado |
| Relatórios e estatísticas | Implementado |
| Exportação em PDF | Implementado |
| APK release | Gerado |
| Testes automatizados | 62 testes passando |

## Licença

Projeto acadêmico — Faculdade de Tecnologia de Itapetininga (Fatec), 2026.

A fonte **Roboto** (`assets/fonts/`) é usada apenas na geração dos PDFs e é
distribuída sob a licença Apache 2.0.
