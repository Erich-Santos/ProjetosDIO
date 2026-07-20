# Modelo Relacional - Gestão de Oficina Mecânica

## Descrição Breve
Este projeto apresenta a modelagem de dados (diagrama ER e modelo lógico) para um sistema de controle e gerenciamento de Ordens de Serviço (OS) em uma oficina mecânica. O foco da arquitetura é garantir a integridade das regras de negócio, a precisão dos cálculos financeiros e a manutenção eficiente do histórico de veículos dos clientes, estruturando uma base sólida para a administração e análise dos dados da oficina.

---

## Narrativa e Regras de Negócio
O modelo foi construído para atender ao seguinte cenário operacional:

* Clientes levam veículos à oficina mecânica para serem consertados ou para passarem por revisões periódicas.
* Cada veículo é designado a uma equipe de mecânicos que identifica os serviços a serem executados e preenche uma OS com data de entrega.
* A partir da OS, calcula-se o valor de cada serviço, consultando-se uma tabela de referência de mão-de-obra.
* O valor de cada peça também irá compor a OS.
* O cliente autoriza a execução dos serviços.
* A mesma equipe avalia e executa os serviços.
* Os mecânicos possuem código, nome, endereço e especialidade.
* Cada OS possui: n°, data de emissão, um valor, status e uma data para conclusão dos trabalhos.

---

## Soluções Arquiteturais e Modelagem

Durante o desenvolvimento do diagrama, alguns impasses lógicos foram resolvidos para garantir a normalização e a eficiência do banco de dados:

### 1. Flexibilidade de Equipes (Muitos-para-Muitos)
**Problema:** Mecânicos não podiam ficar presos a uma única equipe fixa.
**Solução:** Criação de um relacionamento N:M entre `MECÂNICO` e `EQUIPE` (gerando a tabela associativa `Compoe`). Isso permite que a oficina aloque um mesmo especialista em diferentes times conforme a demanda.

### 2. Histórico de Manutenção (Normalização do Veículo)
**Problema:** Atrelar a Ordem de Serviço diretamente ao Cliente ou colocar os dados do carro como texto na OS geraria redundância e dificultaria a busca pelo histórico do automóvel.
**Solução:** Isolamento da entidade `VEÍCULO`. O fluxo estruturado foi: `CLIENTE (1:N) VEÍCULO (1:N) OS`. Isso garante que o carro seja cadastrado apenas uma vez e acumule um histórico limpo de serviços.

### 3. Integridade Financeira (Tipagem de Dados)
**Problema:** O cálculo de peças e mão-de-obra não pode sofrer arredondamentos incorretos.
**Solução:** Adoção estrita do tipo `DECIMAL(10,2)` para todos os atributos monetários (valor da OS, valor da peça e valor do serviço), rejeitando o uso de `FLOAT` para evitar perdas de precisão por ponto flutuante no fechamento de caixa. 

### 4. Gestão de Consumo na OS (Atributos em Relacionamentos)
**Problema:** Como precificar corretamente os itens consumidos em uma OS específica.
**Solução:** As tabelas associativas `Usa` (OS e Peças) e `Contem` (OS e Serviços) receberam os atributos necessários. A tabela `Usa` controla a **quantidade** de peças aplicadas, permitindo a multiplicação pelo valor unitário para compor o preço final da Ordem de Serviço.

---