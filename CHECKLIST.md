# CHECKLIST — Sistema de Gerenciamento de Competições Escolares

> Cruzamento da **documentação** (16 RFs + 20 tabelas) com o **código atual** do projeto.
> Última atualização: 23/10/2026

---

## 📊 Visão geral

| Item | Total | Feito | Falta |
|------|-------|-------|-------|
| Tabelas do banco | 21 | 21 | **0** ✅ |
| Requisitos funcionais (RF) | 16 | 16 | **0** ✅ |
| Regras de negócio (RNFR) | 35 | 35 | **0** ✅ |
| Telas | 44 | 44 | **0** ✅ |
| Layouts exigidos pelo professor | 4 | 4 | **0** ✅ |
| Testes automatizados | — | 62 | **0** ✅ |

---

## ✅ FASE 1 — FUNDAMENTOS (concluída)

- [x] Criar projeto Flutter
- [x] Estrutura MVC (`model`, `control`, `telas`, `widgets`)
- [x] Dependências: `sqflite`, `path_provider`, `path`
- [x] Widgets reutilizáveis (`InputTextos`, `Buttons`, `TextosCustom`)
- [x] CRUD de Competição (model + control + telas)
- [x] Testes automatizados
- [x] README.md
- [x] Repositório Git + GitHub

---

## ✅ FASE 2 — CRUDs (concluída)

Cada entidade precisa de: **model** → **control** → **tela de cadastro** → **tela de consulta**

### Cadastros básicos
- [x] **modalidade** — nome (RF-02)
- [x] **categoria** — nome, idade mínima, idade máxima (RF-02)
- [x] **tipo_evento** — descrição (RF-11)
- [x] **posicao** — nome, id_modalidade (RF-05/10)

### Pessoas
- [x] **responsavel** — nome, cpf, telefone, email, parentesco (RF-16)
- [x] **jogador** — cpf, nome, data_nascimento, id_responsavel (RF-05)
- [x] **documento** — id_jogador, tipo_documento, caminho_arquivo (RF-05)

### Estrutura
- [x] **escola** — nome, cidade, estado, telefone, id_foto (RF-03)
- [x] **tecnico** — nome, telefone, email (RF-07)
- [x] **time** — nome, id_modalidade, id_escola, id_categoria (RF-04)

---

## ✅ FASE 3 — CRUDs (concluída)

- [x] **foto_figurinha** — caminho_arquivo, data_upload
- [x] **tecnico_time** — id_tecnico, id_time, id_foto (RF-07)
- [x] **participacao_jogador_time** — id_jogador, id_time, numero_camisa, valor_inscricao (RF-06)
- [x] **pagamento_inscricao** — id_participacao, valor_pago, data, forma_pagamento (RF-13)
- [x] **rodada** — numero, data, id_competicao (RF-08)
- [x] **partida** — id_rodada, times, placar, WO, craque (RF-09)
- [x] **escalacao** — id_partida, titular, numero_camisa, id_posicao, id_participacao (RF-10)
- [x] **evento_partida** — id_tipo_evento, minuto, descrição, id_escalacao (RF-11)
- [x] **suspensao** — id_evento, motivo, qtd_jogos, cumprida (RF-12)

---

## ✅ FASE 4 — LAYOUTS EXIGIDOS PELO PROFESSOR (concluída)

> "utilizando obrigatoriamente layouts com linhas, colunas, flex e listview"

- [x] **ListView** — telas de cadastro e consulta
- [x] **Row** — tela categoria, responsavel, jogador, escola + menu
- [x] **Expanded + flex** — tela categoria, responsavel, jogador, escola + menu
- [x] **GridView** — menu principal

---

## ✅ FASE 5 — REGRAS DE NEGÓCIO (RNFRs) (concluída)

Todas validadas em `lib/control/` e `lib/util/validacoes.dart`, com o erro
traduzido para `RegraNegocioException` e tratado na interface.

- [x] **RNFR-01.1** — Impedir término < início na competição
- [x] **RNFR-01.2** — Nome da competição único no banco
- [x] **RNFR-02.1** — Idade mínima < idade máxima
- [x] **RNFR-02.2** — Não excluir modalidade/categoria com vínculos
      *(bloqueio explícito na exclusão de categoria; a modalidade é protegida pela FK, que usa RESTRICT por padrão)*
- [x] **RNFR-03.1** — Campos obrigatórios da escola
- [x] **RNFR-03.2** — Imagem máx. 5MB, JPG/PNG/WEBP
- [x] **RNFR-04.1** — Time exige escola + modalidade + categoria
- [x] **RNFR-04.2** — Nome do time único por escola/modalidade/categoria
- [x] **RNFR-05.1** — Validar CPF do jogador
- [x] **RNFR-05.2** — Documentos com acesso restrito (ADMIN)
- [x] **RNFR-05.3** — Jogador exige responsável
- [x] **RNFR-06.1** — Idade dentro da faixa da categoria
- [x] **RNFR-06.2** — Jogador não se inscreve 2x no mesmo time
- [x] **RNFR-07.1** — Técnico vinculado a mais de um time (cada vínculo único)
- [x] **RNFR-08.1** — Rodada dentro do período da competição
- [x] **RNFR-08.2** — Número da rodada único por competição
- [x] **RNFR-09.1** — Partida exige os dois times
- [x] **RNFR-09.2** — Mesmo time não pode ser casa e visitante
- [x] **RNFR-09.3** — WO exige indicar time que recebeu
- [x] **RNFR-10.1** — Escalar só jogador inscrito no time
- [x] **RNFR-10.2** — Não escalar jogador suspenso
- [x] **RNFR-11.1** — Evento só de jogador escalado
- [x] **RNFR-11.2** — Tipo de evento deve ser pré-cadastrado
- [x] **RNFR-12.1** — Toda suspensão vinculada a um evento
- [x] **RNFR-12.2** — Atualizar status da suspensão automaticamente
- [x] **RNFR-13.1** — Pagamento vinculado a uma participação
- [x] **RNFR-13.2** — Valor pago > 0
- [x] **RNFR-13.3** — Exibir status financeiro (pago/parcial/pendente)
- [x] **RNFR-14.1** — Estatísticas em até 3s *(tempo medido e exibido na tela)*
- [x] **RNFR-14.2** — Estatísticas por consulta direta, sem tabelas auxiliares
- [x] **RNFR-15.1** — Relatórios exportáveis em PDF
- [x] **RNFR-15.2** — Relatório financeiro restrito a administradores
- [x] **RNFR-15.3** — Relatórios em até 5s *(tempo medido e exibido na tela)*
- [x] **RNFR-16.1** — Validar CPF do responsável
- [x] **RNFR-16.2** — Dados dos responsáveis restritos a perfis autorizados

---

## ✅ FASE 6 — RELATÓRIOS E ESTATÍSTICAS (concluída)

- [x] **RF-14** — Estatísticas de jogadores (gols, cartões, craque, jogos)
- [x] **RF-15** — Relatórios gerenciais (classificação, financeiro, partidas, suspensos)
- [x] Tela de classificação geral do campeonato
- [x] `ControlRelatorio` — consultas dinâmicas via SQL (sem tabelas auxiliares, RNFR-14.2)
- [x] `MenuRelatorios` — menu dedicado com 5 relatórios

---

## ✅ FASE 8 — ACESSO AO SISTEMA E EXPORTAÇÃO (concluída)

- [x] Login com autenticação (senha em SHA-256 com sal)
- [x] Perfis `ADMIN` e `USUARIO` (tabela `usuario`)
- [x] Sessão em memória + botão "Sair" no menu
- [x] Bloqueio das telas restritas (`GuardaPermissao`)
- [x] Exportação dos 5 relatórios em PDF (compartilhamento pelo sistema)
- [x] Fonte Roboto empacotada — a Helvetica do pacote `pdf` não tem acentos

---

## 📱 FASE 7 — ENTREGAS DO PROFESSOR

### Documentação
- [ ] Ajustar diagramas (modelo conceitual/lógico) — verificar se refletem as 21 tabelas
- [ ] Gerar PDF com **capa no padrão ABNT**
- [ ] Entregar no Teams

### Código
- [ ] Commit **semanal** no GitHub (obrigatório)
- [ ] Todas as telas no GitHub até **04/11**
- [ ] Projeto postado entre **11/11 e 24/11**

### Apresentação
- [x] Gerar **APK** funcional (`app-release.apk`)
- [ ] Preparar apresentação (25/11)
- [ ] Mostrar o app funcionando para a sala

---

## 🗓️ CRONOGRAMA

| Data | Entrega |
|------|---------|
| 05/10 (diurno) ou 07/10 (noturno) | Etapa 01 — Tema ✅ |
| 21/10 (noturno) ou 22/10 (diurno) | Etapa 02 — Documentação ✅ |
| até 04/11 | Todas as telas no GitHub |
| 11/11 a 24/11 | Etapa 03 — Projeto (commits semanais) |
| 25/11 | Etapa 04 — Apresentação |

---

## 🎯 ORDEM DE IMPLEMENTAÇÃO

1. ~~Cadastros básicos~~ ✅
2. ~~Pessoas~~ ✅
3. ~~Estrutura~~ ✅
4. ~~Vínculos~~ ✅
5. ~~Competição~~ ✅
6. ~~Financeiro~~ ✅
7. ~~Relatórios e estatísticas~~ ✅
8. ~~Regras de negócio~~ ✅
9. ~~Acesso ao sistema (login e perfis)~~ ✅
10. ~~Exportação em PDF~~ ✅
11. **APK + apresentação** (APK pronto; apresentação em 25/11)
