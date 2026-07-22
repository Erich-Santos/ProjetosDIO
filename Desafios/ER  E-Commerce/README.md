# Projeto de Entity Relationship Model(ER)

## Desafio 1
Criar um Modelo ER para um e-commerce com as seguintes features inclusas:
  * Cliente PF e PJ - uma diferenciação no tipo de conta para conter apenas uma identificação
  * Pagamento - cadastro de formas de pagamento
  * Entrega - possuir  status e código de rastreio

### Soluções
  1. A variável TIPO_DOCUMENTO(ENUM("CPF","CNPJ")) diferencia a IDENTIFICAÇÃO(VARCHAR(20)) informada na entidade CONTA, podendo ser CPF ou CNPJ
  2. Criada um relacionamento Conta 1:N Forma de Pagamento
  3. Criado um relacionamento Pedido N:1 Entrega. Onde Entrega pode conter diversos pedidos diferentes e nele possui as informações de Entrega[Status_Entrega, Codigo_Rastreio], em Pedido contém o id da entrega.


## Desafio 2
Refinar o modelo conceitual e criar um script SQL para construção do banco de dados, percistêcia de dados e querys que explorem a liguagem DQL
  Instruções mínimas para querys
  * Recuperações simples com SELECT Statement
  * Filtros com WHERE Statement
  * Crie expressões para gerar atributos derivados
  * Defina ordenações dos dados com ORDER BY
  * Condições de filtros aos grupos – HAVING Statement
  * Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados 

### Soloções
  1. Preechidas as tabelas com 20 linhas
  2. Foram criadas 18 querys que exploram a funcionalidade do banco
  3. Utilização de CTE na maioria das peguntas para facilitar manutenção e legibilidade
  4. Comandos utilizados: SELECT DISTINCT, CTE(com WITH  AS), LEFT JOIN, INNER JOIN, WHERE, AGREGAÇÕES, GROUP BY, ORDER BY, LIMIT, HAVING, IS NOT/ IS NULL, OPERADORES, LIKE   