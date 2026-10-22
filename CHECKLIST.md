# CHECKLIST — Sistema de Gerenciamento de Competições Escolares

> Cruzamento da **documentação** (16 RFs + 20 tabelas) com o **código atual** do projeto.
> Última atualização: 22/10/2026

---

## 📊 Visão geral

| Item | Total | Feito | Falta |
|------|-------|-------|-------|
| Tabelas do banco | 20 | 1 | **19** |
| Requisitos funcionais (RF) | 16 | 1 | **15** |
| Telas | ~15 | 3 | **12** |
| Layouts exigidos pelo professor | 4 | 1 | **3** |

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

## 🗄️ FASE 2 — CRUDs DAS ENTIDADES (19 restantes)

Cada entidade precisa de: **model** → **control** → **tela de cadastro** → **tela de consulta**

### Cadastros básicos
- [ ] **modalidade** — nome (RF-02)
- [ ] **categoria** — nome, idade mínima, idade máxima (RF-02)
- [ ] **tipo_evento** — descrição (RF-11)
- [ ] **posicao** — nome, id_modalidade (RF-05/10)
- [ ] **responsavel** — nome, cpf, telefone, email, parentesco (RF-16)
- [ ] **jogador** — cpf, nome, data_nascimento, id_responsavel (RF-05)
- [ ] **documento** — id_jogador, tipo_documento, caminho_arquivo (RF-05)
- [ ] **foto_figurinha** — caminho_arquivo, data_upload (RF-03)
- [ ] **escola** — nome, cidade, estado, telefone, id_foto (RF-03)
- [ ] **tecnico** — nome, telefone, email (RF-07)
- [ ] **time** — nome, id_modalidade, id_escola, id_categoria (RF-04)

### Vínculos
- [ ] **tecnico_time** — id_tecnico, id_time, id_foto (RF-07)
- [ ] **participacao_jogador_time** — id_jogador, id_time, numero_camisa, valor_inscricao, id_foto (RF-06)
- [ ] **pagamento_inscricao** — id_participacao, valor_pago, data, forma_pagamento, observações (RF-13)

### Competição
- [ ] **rodada** — numero, data, id_competicao (RF-08)
- [ ] **partida** — id_rodada, times, placar, WO, craque (RF-09)
- [ ] **escalacao** — id_partida, titular, numero_camisa, id_posicao, id_participacao (RF-10)
- [ ] **evento_partida** — id_tipo_evento, minuto, descrição, id_escalacao (RF-11)
- [ ] **suspensao** — id_evento, motivo, qtd_jogos, cumprida (RF-12)

---

## 🎨 FASE 3 — LAYOUTS EXIGIDOS PELO PROFESSOR

> "utilizando obrigatoriamente layouts com linhas, colunas, flex e listview"

- [x] **ListView** — já usado nas telas de cadastro/consulta
- [ ] **Row** — nenhum uso ainda (0 ocorrências)
- [ ] **Expanded + flex** — nenhum uso ainda (0 ocorrências)
- [ ] **GridView** — nenhum uso ainda (0 ocorrências)

---

## ⚙️ FASE 4 — REGRAS DE NEGÓCIO (RNFRs)

- [ ] **RNFR-01.1** — Impedir término < início na competição
- [ ] **RNFR-01.2** — Nome da competição único no banco
- [ ] **RNFR-02.1** — Idade mínima < idade máxima
- [ ] **RNFR-02.2** — Não excluir modalidade/categoria com vínculos
- [ ] **RNFR-03.1** — Campos obrigatórios da escola
- [ ] **RNFR-03.2** — Imagem máx. 5MB, JPG/PNG/WEBP
- [ ] **RNFR-04.1** — Time exige escola + modalidade + categoria
- [ ] **RNFR-04.2** — Nome do time único por escola/modalidade/categoria
- [ ] **RNFR-05.1** — Validar CPF do jogador
- [ ] **RNFR-05.2** — Documentos com acesso restrito
- [ ] **RNFR-05.3** — Jogador exige responsável
- [ ] **RNFR-06.1** — Idade dentro da faixa da categoria
- [ ] **RNFR-06.2** — Jogador não se inscreve 2x no mesmo time
- [ ] **RNFR-07.1** — Técnico vinculado a mais de um time
- [ ] **RNFR-08.1** — Rodada dentro do período da competição
- [ ] **RNFR-08.2** — Número da rodada único por competição
- [ ] **RNFR-09.1** — Partida exige os dois times
- [ ] **RNFR-09.2** — Mesmo time não pode ser casa e visitante
- [ ] **RNFR-09.3** — WO exige indicar time que recebeu
- [ ] **RNFR-10.1** — Escalar só jogador inscrito no time
- [ ] **RNFR-10.2** — Não escalar jogador suspenso
- [ ] **RNFR-11.1** — Evento só de jogador escalado
- [ ] **RNFR-11.2** — Tipo de evento deve ser pré-cadastrado
- [ ] **RNFR-12.1** — Toda suspensão vinculada a um evento
- [ ] **RNFR-12.2** — Atualizar status da suspensão automaticamente
- [ ] **RNFR-13.1** — Pagamento vinculado a uma participação
- [ ] **RNFR-13.2** — Valor pago > 0
- [ ] **RNFR-13.3** — Exibir status financeiro (pago/parcial/pendente)
- [ ] **RNFR-14.1** — Estatísticas em até 3s
- [ ] **RNFR-15.1** — Relatórios exportáveis em PDF/planilha
- [ ] **RNFR-15.2** — Relatório financeiro restrito a administradores
- [ ] **RNFR-16.1** — Validar CPF do responsável

---

## 📈 FASE 5 — CONSULTAS E RELATÓRIOS

- [ ] **RF-14** — Estatísticas de jogadores (gols, cartões, craque)
- [ ] **RF-15** — Relatórios gerenciais (classificação, financeiro, partidas, suspensos)
- [ ] Tela de classificação geral do campeonato

---

## 📱 FASE 6 — ENTREGAS DO PROFESSOR

### Documentação
- [ ] Ajustar diagramas (modelo conceitual/lógico) — verificar se refletem as 20 tabelas
- [ ] Gerar PDF com **capa no padrão ABNT**
- [ ] Entregar no Teams

### Código
- [ ] Commit **semanal** no GitHub (obrigatório)
- [ ] Todas as telas no GitHub até **04/11**
- [ ] Projeto postado entre **11/11 e 24/11**

### Apresentação
- [ ] Gerar **APK** funcional
- [ ] Preparar apresentação (25/11)
- [ ] Mostrar o app funcionando para a sala

---

## 🗓️ CRONOGRAMA

| Data | Entrega |
|------|---------|
| 05/10 (diurno) ou 07/10 (noturno) | Etapa 01 — Tema ✅ |
| 21/10 (noturno) ou 22/10 (diurno) | Etapa 02 — Documentação |
| até 04/11 | Todas as telas no GitHub |
| 11/11 a 24/11 | Etapa 03 — Projeto (commits semanais) |
| 25/11 | Etapa 04 — Apresentação |

---

## 🎯 ORDEM SUGERIDA DE IMPLEMENTAÇÃO

1. **Cadastros básicos** (modalidade, categoria, tipo_evento, posicao) — sem dependências
2. **Pessoas** (responsavel, jogador, documento)
3. **Estrutura** (escola, tecnico, time)
4. **Vínculos** (tecnico_time, participacao_jogador_time)
5. **Competição** (rodada, partida, escalacao, evento_partida, suspensao)
6. **Financeiro** (pagamento_inscricao)
7. **Relatórios e estatísticas**
8. **Regras de negócio** (validações)
9. **APK + apresentação**
