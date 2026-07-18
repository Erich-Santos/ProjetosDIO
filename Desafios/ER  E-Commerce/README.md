# Projeto de Extended Entity Relationship Model(EER)

## Desafios
Criar um Modelo EER para um e-commerce com as seguintes features inclusas:
  * Cliente PF e PJ - uma diferenciação no tipo de conta para conter apenas uma identificação
  * Pagamento - cadastro de formas de pagamento
  * Entrega - possuir  status e código de rastreio

## Soluções
  1. A variável TIPO_DOCUMENTO(ENUM("CPF","CNPJ")) diferencia a IDENTIFICAÇÃO(VARCHAR(20)) informada na entidade CONTA, podendo ser CPF ou CNPJ
  2. Criada um relacionamento Conta 1:N Forma de Pagamento
  3. Criado um relacionamento Pedido N:1 Entrega. Onde Entrega pode conter diversos pedidos diferentes e nele possui as informações de Entrega[Status_Entrega, Codigo_Rastreio], em Pedido contém o id da entrega.
