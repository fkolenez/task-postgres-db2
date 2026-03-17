CREATE TABLE usuarios (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    email     VARCHAR(100) UNIQUE NOT NULL,
    cargo     VARCHAR(50)  NOT NULL,
    criado_em DATE DEFAULT CURRENT_DATE
);

CREATE TABLE moveis (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    material  VARCHAR(50)  NOT NULL,
    preco     NUMERIC(10,2) NOT NULL,
    estoque   INT DEFAULT 0
);

CREATE TABLE pedidos (
    id           SERIAL PRIMARY KEY,
    id_usuario   INT REFERENCES usuarios(id),
    id_movel     INT REFERENCES moveis(id),
    quantidade   INT NOT NULL DEFAULT 1,
    status       VARCHAR(30) DEFAULT 'pendente',
    criado_em    DATE DEFAULT CURRENT_DATE
);


-- ============================================================
-- 2. POPULANDO O BANCO (INSERT)
-- ============================================================

-- Usuários (funcionários da marcenaria)
INSERT INTO usuarios (nome, email, cargo) VALUES
    ('Carlos Souza',    'carlos@marcenaria.com',   'Marceneiro'),
    ('Ana Lima',        'ana@marcenaria.com',       'Vendedora'),
    ('Ricardo Nunes',   'ricardo@marcenaria.com',   'Gerente'),
    ('Fernanda Costa',  'fernanda@marcenaria.com',  'Vendedora'),
    ('Thiago Gomes',    'thiago@marcenaria.com',    'Marceneiro'),
    ('Julia Martins',   'julia@marcenaria.com',     'Assistente'),
    ('Paulo Ramos',     'paulo@marcenaria.com',     'Marceneiro'),
    ('Beatriz Alves',   'beatriz@marcenaria.com',   'Gerente');

-- Móveis
INSERT INTO moveis (nome, material, preco, estoque) VALUES
    ('Mesa de Jantar',      'Madeira Maciça',  1200.00,  5),
    ('Cadeira Rústica',     'Pinus',            350.00, 12),
    ('Guarda-Roupa',        'MDF',              900.00,  4),
    ('Estante de Livros',   'Madeira Maciça',   750.00,  7),
    ('Cama Box Casal',      'MDF',             1500.00,  3),
    ('Banco de Jardim',     'Eucalipto',        280.00, 10),
    ('Escrivaninha',        'Pinus',            620.00,  6),
    ('Mesa de Centro',      'Madeira de Lei',   480.00,  8),
    ('Armário de Cozinha',  'MDF',             1100.00,  2),
    ('Rack para TV',        'Pinus',            390.00,  9);

-- Pedidos
INSERT INTO pedidos (id_usuario, id_movel, quantidade, status) VALUES
    (2, 1,  1, 'entregue'),
    (2, 3,  2, 'entregue'),
    (4, 2,  4, 'entregue'),
    (4, 6,  2, 'em producao'),
    (4, 8,  1, 'entregue'),
    (6, 5,  1, 'pendente'),
    (6, 7,  1, 'em producao'),
    (2, 9,  1, 'entregue'),
    (4, 4,  3, 'entregue'),
    (6, 10, 2, 'pendente'),
    (2, 2,  2, 'entregue'),
    (4, 1,  1, 'em producao'),
    (6, 3,  1, 'entregue'),
    (2, 7,  1, 'entregue'),
    (4, 5,  1, 'pendente');


-- ============================================================
-- 3. CONSULTAS
-- ============================================================


-- ------------------------------------------------------------
-- A) INNER JOIN — Pedidos com nome do funcionário e do móvel
-- ------------------------------------------------------------
SELECT
    usuarios.nome        AS nome_do_funcionario,
    moveis.nome          AS nome_do_movel,
    pedidos.quantidade   AS quantidade_pedida,
    pedidos.status       AS status_do_pedido,
    pedidos.criado_em    AS data_do_pedido
FROM pedidos
INNER JOIN usuarios ON usuarios.id = pedidos.id_usuario
INNER JOIN moveis   ON moveis.id   = pedidos.id_movel
ORDER BY pedidos.criado_em DESC;

-- ------------------------------------------------------------
-- B) GROUP BY + agregações — Total de pedidos por móvel
-- ------------------------------------------------------------
SELECT
    moveis.nome                          AS nome_do_movel,
    moveis.material                      AS material_do_movel,
    COUNT(pedidos.id)                    AS quantidade_de_pedidos,
    SUM(pedidos.quantidade)              AS total_de_unidades_pedidas,
    ROUND(AVG(pedidos.quantidade), 1)    AS media_de_unidades_por_pedido
FROM moveis
INNER JOIN pedidos ON pedidos.id_movel = moveis.id
GROUP BY moveis.nome, moveis.material
ORDER BY quantidade_de_pedidos DESC;


-- ------------------------------------------------------------
-- C) GROUP BY + agregações — Faturamento por funcionário
-- ------------------------------------------------------------
SELECT
    usuarios.nome                              AS nome_do_funcionario,
    usuarios.cargo                             AS cargo_do_funcionario,
    COUNT(pedidos.id)                          AS total_de_pedidos,
    SUM(pedidos.quantidade * moveis.preco)     AS faturamento_gerado
FROM usuarios
INNER JOIN pedidos ON pedidos.id_usuario = usuarios.id
INNER JOIN moveis  ON moveis.id          = pedidos.id_movel
GROUP BY usuarios.nome, usuarios.cargo
ORDER BY faturamento_gerado DESC;

-- ------------------------------------------------------------
-- D) WHERE / filtros — Móveis de MDF com preço acima de R$ 800
-- ------------------------------------------------------------
SELECT
    moveis.nome       AS nome_do_movel,
    moveis.material   AS material_do_movel,
    moveis.preco      AS preco_do_movel,
    moveis.estoque    AS quantidade_em_estoque
FROM moveis
WHERE moveis.material = 'MDF'
  AND moveis.preco > 800.00
ORDER BY moveis.preco DESC;

-- ------------------------------------------------------------
-- E) ORDER BY + LIMIT — Top 3 móveis mais vendidos
-- ------------------------------------------------------------
SELECT
    moveis.nome                    AS nome_do_movel,
    moveis.material                AS material_do_movel,
    moveis.preco                   AS preco_unitario,
    SUM(pedidos.quantidade)        AS total_de_unidades_vendidas
FROM moveis
INNER JOIN pedidos ON pedidos.id_movel = moveis.id
GROUP BY moveis.nome, moveis.material, moveis.preco
ORDER BY total_de_unidades_vendidas DESC
LIMIT 3;
