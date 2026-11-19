// Parte 2 - Amigos de amigos que compraram o Produto X
// "eu" = Ana | Produto X = Notebook
MATCH (eu:Usuario {nome: "Ana"})-[:AMIGO_DE]-(amigo:Usuario)-[:AMIGO_DE]-(fof:Usuario)-[:COMPROU]->(p:Produto {nome: "Notebook"})
WHERE fof <> eu
  AND NOT (eu)-[:AMIGO_DE]-(fof)
RETURN fof.nome AS amigo_de_amigo,
       collect(DISTINCT amigo.nome) AS via,
       p.nome AS produto
ORDER BY amigo_de_amigo;

// Parte 3 - Recomendacao por interesses em comum
// Quem comprou o mesmo produto que a Ana tambem comprou o que?
MATCH (eu:Usuario {nome: "Ana"})-[:COMPROU]->(:Produto)<-[:COMPROU]-(outro:Usuario)-[:COMPROU]->(rec:Produto)
WHERE outro <> eu
  AND NOT (eu)-[:COMPROU]->(rec)
RETURN rec.nome AS recomendacao,
       count(DISTINCT outro) AS compradores_em_comum,
       collect(DISTINCT outro.nome) AS quem_comprou
ORDER BY compradores_em_comum