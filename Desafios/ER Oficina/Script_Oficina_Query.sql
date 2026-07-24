USE oficina;

/* 
 1. HISTÓRICO DE ATENDIMENTO
 O balcão de atendimento precisa puxar o histórico da cliente "Ana Souza".
 Escreva uma query que retorne o Nome e Sobrenome do Cliente, o Modelo 
 do Veículo, a Placa, a Data de Emissão da OS e o Status atual de 
 todas as ordens de serviço ligadas a ela.
*/
WITH historico as (
	SELECT concat(cl.nome, " ", cl.sobrenome) as Cliente, v.modelo, v.placa, v.idVeiculo as idVeiculo
    FROM cliente cl
    JOIN veiculo v ON cl.idCliente = v.idCliente
    WHERE cl.nome = "Ana" AND sobrenome = "Souza"
)
SELECT h.*, os.data_emissao as Data_Emissao, os.status_os as Status
FROM historico h
JOIN os ON h.idVeiculo = os.idVeiculo;

/* 
 2. INDICADORES DE ESTOQUE E CUSTOS
 Para otimizar as compras do mês, precisamos saber quais peças têm maior 
 giro e trazem mais retorno. Liste o Nome da Peça, a Quantidade Total 
 utilizada (somando todas as OS) e o Volume Financeiro Total (soma do 
 valor gerado) por cada peça. Ordene o resultado para mostrar as peças 
 com maior volume financeiro no topo.
*/
SELECT p.peca as Peças, SUM(po.quantidade) as QTD_Total, SUM(po.quantidade * po.valor_unitario) as Financeiro_Total
FROM peca p
JOIN peca_os po ON p.idPeca = po.idPeca
GROUP BY p.peca
ORDER BY Financeiro_Total DESC;

/* 
 3. DESEMPENHO E FATURAMENTO POR EQUIPE
 Para o fechamento financeiro, crie um relatório que mostre a eficiência 
 de cada equipe. Retorne o Nome da Equipe, a quantidade de Ordens de 
 Serviço executadas por ela e o Faturamento Total (soma do valor total). 
 Considere APENAS as ordens com status 'Finalizado'.
*/
SELECT e.nome_equipe as Equipe, COUNT(os.idOs) as OS, SUM(os.valor_total) as Faturamento
FROM os
JOIN equipe e ON os.idEquipe = e.idEquipe
WHERE os.status_os = "Finalizado"
GROUP BY e.nome_equipe;

/* 
 4. RASTREABILIDADE DE MÃO DE OBRA
 Houve um retorno de garantia referente aos serviços executados na OS nº 2. 
 Para fins de auditoria, escreva uma consulta que retorne o Nome, Sobrenome 
 e Especialidade de TODOS os mecânicos que compunham a equipe responsável 
 por essa OS específica.

*/
WITH equipe_responsavel as (
	SELECT os.idOs as OS, os.idEquipe as idEquipe, e.nome_equipe as Equipe
	FROM os
	JOIN equipe e ON os.idEquipe = e.idEquipe
	WHERE os.idOs = 2
) -- Encontrando o responsável pela OS n°2
SELECT concat(m.nome, " ", m.sobrenome) as Mecanico, m.especialidade as Especialidade
FROM equipes_mem em -- Elo dentre as 3 tabelas
JOIN equipe_responsavel er on em.idEquipe = er.idEquipe
JOIN mecanico m on m.idMecanico = em.idMecanico;

/* 
 5. CLASSIFICAÇÃO DE CLIENTES VIP (Análise de Receita)
 A gestão quer lançar um programa de fidelidade e precisa identificar o 
 perfil dos clientes mais rentáveis (que trazem mais receita geral). 
 
 Escreva uma query que retorne as seguintes colunas:
 - Nome e Sobrenome do Cliente (juntos em uma única coluna chamada "Cliente")
 - A quantidade de veículos distintos que este cliente possui na oficina.
 - A quantidade total de Ordens de Serviço (OS) geradas por ele.
 - O Valor Total Gasto por ele na oficina (somando todas as OS de 
   todos os carros dele).
 
 Regras estritas:
 - Mostre APENAS os clientes cujo "Valor Total Gasto" ultrapasse R$ 500,00.
 - Ordene do cliente que gastou mais para o que gastou menos.
 
*/
WITH gasto_cliente as (
SELECT v.idCliente, v.idVeiculo, COUNT(os.idOs) as OS, SUM(valor_total) as Valor_Gasto
FROM veiculo v
JOIN os ON os.idVeiculo = v.idVeiculo
GROUP BY v.idCliente, v.idVeiculo
) -- agrupando valores por carros 
SELECT concat(cl.nome, " ",cl.sobrenome) as Cliente, COUNT(gc.idVeiculo) as Veiculos,SUM(gc.OS) as OS ,SUM(gc.Valor_Gasto) as Total_Gasto -- somatorio dos subtotais por cliente
FROM cliente cl
JOIN gasto_cliente gc on cl.idCliente = gc.idCliente
GROUP BY cl.nome, cl.sobrenome
HAVING Total_Gasto > 500 
ORDER BY Total_Gasto desc;
