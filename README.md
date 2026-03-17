# 🪵 Prática PostgreSQL — Sistema de Marcenaria

> Atividade prática da disciplina de Banco de Dados — focada em consultas SQL com `INNER JOIN`, `GROUP BY`, `WHERE`, `ORDER BY` e `LIMIT`.

---

## 📌 Contexto da Atividade

Esta atividade simula o banco de dados de uma **marcenaria**, onde temos funcionários com diferentes cargos, um catálogo de móveis feitos com diferentes materiais, e os pedidos realizados por esses funcionários.

O objetivo é colocar em prática os principais conceitos de consulta relacional no PostgreSQL, entendendo como tabelas se relacionam entre si e como extrair informações úteis a partir dessas relações.

---

## 🧠 Conceitos Abordados

### O que é um banco de dados relacional?
Um banco de dados relacional organiza os dados em **tabelas** (como planilhas), onde cada tabela representa uma entidade do mundo real. As tabelas se conectam umas às outras por meio de **chaves estrangeiras** (`FOREIGN KEY`), que criam vínculos entre os registros.

### Por que o PostgreSQL?
O PostgreSQL é um dos SGBDs (Sistemas Gerenciadores de Banco de Dados) mais robustos e utilizados no mercado. Ele é open-source, segue o padrão SQL e suporta recursos avançados como transações, índices, funções e muito mais.

### Estrutura do banco desta atividade

O banco é composto por **3 tabelas**:

| Tabela | O que representa |
|--------|-----------------|
| `usuarios` | Funcionários da marcenaria (com nome, e-mail e **cargo**) |
| `moveis` | Produtos fabricados (com nome, **material** e preço) |
| `pedidos` | Registro de cada pedido, ligando um usuário a um móvel |

As tabelas se relacionam assim:

```
usuarios ──< pedidos >── moveis
```

Ou seja: um usuário pode ter vários pedidos, e um móvel pode aparecer em vários pedidos.

---

## 📂 Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `pratica_postgres.sql` | Script principal com criação das tabelas, inserção de dados e 5 consultas comentadas |
| `docker-compose.yml` | Sobe o PostgreSQL e o pgAdmin via Docker |
| `README.md` | Este arquivo |

---

## 🐳 Como Subir o Ambiente com Docker

### Pré-requisitos
- [Docker](https://www.docker.com/) instalado
- [Docker Compose](https://docs.docker.com/compose/) (já incluso no Docker Desktop)

### Passo a passo

**1. Suba os containers:**
```bash
docker compose up -d
```

**2. Verifique se estão rodando:**
```bash
docker ps
```

Você deve ver dois containers ativos: `meu_postgres` e `meu_pgadmin`.

**3. Acesse o pgAdmin no navegador:**
```
http://localhost:8080
```

Login:
- **E-mail:** `admin@admin.com`
- **Senha:** `senha123`

**4. Conecte ao banco no pgAdmin:**

Clique com o botão direito em **Servers → Register → Server** e preencha:

| Campo | Valor |
|-------|-------|
| Name | Marcenaria (ou qualquer nome) |
| Host | `localhost` |
| Port | `5432` |
| Database | `meu_banco` |
| Username | `admin` |
| Password | `senha123` |

**5. Execute o script SQL:**

No pgAdmin, abra o **Query Tool** e cole o conteúdo do arquivo `pratica_postgres.sql`. Execute tudo de uma vez ou sessão por sessão.

### Para derrubar o ambiente:
```bash
docker compose down
```

> Para apagar também os dados salvos em volume:
> ```bash
> docker compose down -v
> ```

---

## 🔍 O que você vai praticar

O script `pratica_postgres.sql` está dividido em 3 partes:

### 1. Criação das Tabelas (`CREATE TABLE`)
Define a estrutura do banco: quais colunas cada tabela tem, seus tipos de dados e os relacionamentos entre elas.

### 2. Inserção de Dados (`INSERT INTO`)
Popula o banco automaticamente com funcionários, móveis e pedidos fictícios — sem precisar digitar nada manualmente.

### 3. Consultas (`SELECT`)
São 5 consultas organizadas por nível de complexidade:

| Consulta | Recursos utilizados | O que faz |
|----------|-------------------|-----------|
| A | `INNER JOIN` | Lista pedidos com o nome do funcionário e do móvel |
| B | `INNER JOIN` + `GROUP BY` + `COUNT`, `SUM`, `AVG` | Total de pedidos e unidades agrupados por móvel |
| C | `INNER JOIN` + `GROUP BY` + `SUM` | Faturamento gerado por cada funcionário |
| D | `WHERE` com múltiplos filtros | Móveis de MDF com preço acima de R$ 800 |
| E | `INNER JOIN` + `GROUP BY` + `ORDER BY` + `LIMIT` | Top 3 móveis mais vendidos |

---

## 💡 Dicas

- Execute as consultas **uma por vez** para entender o resultado de cada uma.
- Antes de rodar uma consulta com `JOIN`, tente primeiro fazer um `SELECT * FROM` em cada tabela separada para entender o que tem dentro.
- A consulta **E** é a mais completa — ela combina `JOIN`, `GROUP BY`, `ORDER BY` e `LIMIT` em uma única query, um ótimo exemplo de como queries reais funcionam.