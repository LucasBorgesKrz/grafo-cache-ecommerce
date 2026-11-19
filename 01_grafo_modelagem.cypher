// Parte 1 - Modelo de grafo: sistema de recomendacao
// Nos: Usuario e Produto | Relacionamentos: AMIGO_DE e COMPROU

// Limpa o grafo para o script poder ser executado varias vezes
MATCH (n) DETACH DELETE n;

// Garante ids unicos
CREATE CONSTRAINT usuario_id IF NOT EXISTS FOR (u:Usuario) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT produto_id IF NOT EXISTS FOR (p:Produto) REQUIRE p.id IS UNIQUE;

// Nos: Usuario
UNWIND [
  {id: 1, nome: "Ana"},
  {id: 2, nome: "Bruno"},
  {id: 3, nome: "Carla"},
  {id: 4, nome: "Diego"},
  {id: 5, nome: "Elisa"},
  {id: 6, nome: "Fabio"}
] AS u
CREATE (:Usuario {id: u.id, nome: u.nome});

// Nos: Produto
UNWIND [
  {id: 101, nome: "Notebook", preco: 4899.00},
  {id: 102, nome: "Mouse",    preco: 89.90},
  {id: 103, nome: "Teclado",  preco: 249.90},
  {id: 104, nome: "Headset",  preco: 199.90},
  {id: 105, nome: "Monitor",  preco: 1299.00}
] AS p
CREATE (:Produto {id: p.id, nome: p.nome, preco: p.preco});

// Relacionamentos: AMIGO_DE (uma seta por amizade; nas consultas usamos a seta sem direcao)
UNWIND [
  [1, 2], // Ana   -> Bruno
  [1, 3], // Ana   -> Carla
  [2, 3], // Bruno -> Carla
  [2, 4], // Bruno -> Diego
  [3, 5], // Carla -> Elisa
  [4, 6]  // Diego -> Fabio
] AS par
MATCH (a:Usuario {id: par[0]}), (b:Usuario {id: par[1]})
CREATE (a)-[:AMIGO_DE]->(b);

// Relacionamentos: COMPROU (usuario, produto)
UNWIND [
  [1, 103],           // Ana:   Teclado
  [2, 103], [2, 104], // Bruno: Teclado, Headset
  [3, 105],           // Carla: Monitor
  [4, 101], [4, 102], [4, 103], // Diego: Notebook, Mouse, Teclado
  [5, 101], [5, 105], // Elisa: Notebook, Monitor
  [6, 101], [6, 103], [6, 104]  // Fabio: Notebook, Teclado, Headset
] AS c
MATCH (u:Usuario {id: c[0]}), (p:Produto {id: c[1]})
CREATE (u)-[:COMPROU]->(p);