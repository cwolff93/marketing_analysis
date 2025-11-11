## Foi realizada uma LEFT JOIN uma vez que nem toda lead se torna uma venda e é necessário manter as informações para analisar quais campanhas tiveram mais sucesso baseadas no número de vendas.

SELECT 
  date_venda,
  l.campaign AS lead_campaign,
  v.campaign AS venda_campaign,
  l.term AS lead_term,
  v.term AS venda_term,
  l.source AS leads_source,
  v.source AS venda_source
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
WHERE date_venda IS NOT NULL
AND l.source <> v.source
OR l.term <> v.term
OR l.campaign <> v.campaign;

## Existem algumas linhas nas quais as colunas possuem informações divergentes entre as tabelas leads e vendas. Caso seja um comportamento esperado, a tabela não precisa ser corrigida, porém caso isso represente um erro na coleta de dados é necessário verificar o que está ocorrendo. Apesar de ter sido verificado na análise, não fiz alterações nos nomes dos dados, mesmo que alguns fossem muito semelhantes, por não ter conhecimento acerca do funcionamento da empresa e a alteração desses dados sem consultar as regras de negócio poderia causar mais problemas.

SELECT 
  date_lead, 
  date_venda, 
  l.email AS email,
  l.medium AS lead_medium,
  v.medium AS venda_medium,
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
WHERE l.medium = 'cpc'
AND date_venda IS NOT NULL;

## Partindo do princípio que a data da tabela lead é a data na qual o usuário se tornou um lead e a data da tabela vendas é a data que a venda foi consolidada e o lead tornou-se cliente, 
existem apenas 16 compras com origem de medium CPC de um universo de 227 leads provenientes desse medium, correspondente a uma taxa de conversão de 7%.

## As datas de venda se concentram nos dias 2025-09-20 e 2025-09-21, havendo vendas realizadas antes da data de lead para um mesmo e-mail. Os dados de date_lead podem estar se sobrepondo para e-mails repetidos, 
  considerando a possibilidade de acesso por meio de diferentes campanhas por um mesmo usuário, mas pode ser apenas o material disponibilizado para o teste.

SELECT 
  date_lead, 
  date_venda, 
  l.email AS email,
  CASE
    WHEN date_venda IS NOT NULL THEN "2 - Customer"
    ELSE "1 - Lead"
  END AS deal_stage
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email;

# Caso seja uma informação disponível, seria interessante criar uma coluna de date_lost para definir quando aquela lead desistiu de se tornar um cliente, 
assim como definir a página de desistência. Dessa forma seria possível analisar se há algum motivo por trás da desistência como custo, 
falta de interesse no material ofertado, não compreensão da tela de checkout, excesso de informações sendo requisitadas para venda, entre outros.

UPDATE `e-tensor-411113.marketing_test.vendas`
SET lead_source = 'ACAO F1 COMBO'
WHERE lead_source = 'ACAO F1  COMBO';

UPDATE `e-tensor-411113.marketing_test.vendas`
SET lead_source = 'ACAO F1 COMBO'
WHERE lead_source = 'ACAO F1 COMBO ';

# Alteração do valor na coluna de Lead Source por motivo de espaços extras no nome 'ACAO F1 COMBO'

UPDATE `e-tensor-411113.marketing_test.leads`
SET lead_source = 'BREAKPOINT F1 COMBO'
WHERE lead_source = 'BREAKPOINT F1  COMBO';

UPDATE `e-tensor-411113.marketing_test.leads`
SET lead_source = 'BREAKPOINT F1 COMBO'
WHERE lead_source = 'BREAKPOINT F1 COMBO ';

# Alteração do valor na coluna de Lead Source por motivo de um espaços extras no nome 'BREAKPOINT F1 COMBO'

SELECT 
  campaign, 
  medium,
  source,
  COUNT(*) AS amount
FROM `e-tensor-411113.marketing_test.vendas`
GROUP BY campaign, medium, source
ORDER BY amount DESC;

## Existem 23 linhas de vendas que possuem campaign, medium e source nulos e cada campanha geralmente corresponde a um único medium com uma única source. 
Por ser o segundo resultado com mais vendas é importante verificar o motivo desses dados estarem nulos para melhor analisar as informações.

SELECT 
  source,
  COUNT(*) AS amount,
  ROUND(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER () * 100,2) AS Percentage
FROM `e-tensor-411113.marketing_test.vendas`
GROUP BY source
ORDER BY amount DESC;

## Multiplicar a medida de COUNT por 1.0 para transformá-la em float e não fazer com que o valor seja arredondado. Somar todos os counts uma vez que o campo 'source' 
é de string e não pode ser apenas somado e por último aplicar o total OVER todas as linhas, fazendo com que o valor do count seja dividido pelo total para cada source.

## A source mais frequente é instagram, com quase 44% dos resultados.

SELECT 
  campaign,
  COUNT(*) AS amount
FROM `e-tensor-411113.marketing_test.vendas`
GROUP BY campaign
HAVING campaign = 'acao-XXX_live-direto_funil-2_biocreator';

## A campanha 'acao-XXX_live-direto_funil-2_biocreator' possui 6 vendas cadastradas na tabela de vendas. 

SELECT 
  date_venda,
  l.email AS lead_email,
  v.email AS venda_email,
  l.campaign AS lead_campaign,
  v.campaign AS venda_campaign
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
WHERE date_venda IS NOT NULL
AND v.campaign = 'acao-XXX_live-direto_funil-2_biocreator';

## Utilizando a coluna de lead_campaign é possível ver que existem duas campanhas distintas que se "tornam" a campanha esperada na busca 'acao-XXX_live-direto_funil-2_biocreator', 
o que pode ser um erro na coleta de dados ou pode ser um comportamento esperado, mas cabe a anotação para verificação.

SELECT 
  COUNT(l.date_lead) AS total_leads,
  COUNT(v.date_venda) AS total_sales,
  ROUND((COUNT(v.date_venda)/COUNT(l.date_lead)) * 100,2) AS conversion_rate
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email;

## A taxa de conversão geral é de 12,32%

SELECT
  l.campaign, 
  l.source,
  COUNT(l.date_lead) AS total_leads,
  COUNT(v.date_venda) AS total_sales,
  ROUND((COUNT(v.date_venda)/COUNT(l.date_lead)) * 100,2) AS conversion_rate
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
GROUP BY campaign, source
ORDER BY Conversion_Rate DESC;

# Por meio desse código é possível verificar a combinação de campaign e source para definir quais tiveram mais sucesso.

SELECT
  l.lead_source,
  l.source, 
  COUNT(l.date_lead) AS total_leads,
  COUNT(v.date_venda) AS total_sales,
  ROUND((COUNT(v.date_venda)/COUNT(l.date_lead)) * 100,2) AS conversion_rate
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
GROUP BY CUBE (l.lead_source, l.source)
ORDER BY Conversion_Rate DESC;


## A source com a maior taxa de conversão é o portal, com o instagram em segundo lugar e email em terceiro. Dependendo do mínimo estabelecido por parte da empresa e 
o custo de implementação das campanhas de acordo com a source, é possível definir se elas serão mantidas ou não.

## Ao realizar o GROUP BY CUBE é possível verificar as combinações de lead_source e source ao mesmo tempo, além dos valores gerais e para cada um deles, o que ajuda a definir 
  quais são as médias para cada lead_source e verificar se existem sources que atuam como outliers (como o linkedin para a lead_source F1) para diminuir a média. Alterando o ORDER BY para lead_source e 
  depois amount é possível verificar o desempenho das lead_sources com mais detalhe, mas verificando com a taxa de conversão no ORDER BY, é possível verificar a combinação dos dois que está acima 
  da média geral de 12,32% com facilidade.

SELECT
  l.content, 
  COUNT(l.date_lead) AS total_leads,
  COUNT(v.date_venda) AS total_sales,
  ROUND((COUNT(v.date_venda)/COUNT(l.date_lead)) * 100,2) AS conversion_rate
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
GROUP BY content
ORDER BY Conversion_Rate DESC;

SELECT
  l.term, 
  COUNT(l.date_lead) AS total_leads,
  COUNT(v.date_venda) AS total_sales,
  ROUND((COUNT(v.date_venda)/COUNT(l.date_lead)) * 100,2) AS conversion_rate
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
GROUP BY term
ORDER BY Conversion_Rate DESC;

# Por meio desse código é possível verificar quais os terms com a maior taxa de conversão.

SELECT 
  CASE
    WHEN l.email LIKE "%@gm%" THEN "Gmail"
    WHEN l.email LIKE "%@hot%" THEN "Hotmail"
    ELSE "Outros"
  END AS email_lead,
  COUNT(l.date_lead) AS total_leads,
  COUNT(v.date_venda) AS total_sales,
  ROUND((COUNT(v.date_venda)/COUNT(l.date_lead)) * 100,2) AS conversion_rate
FROM `e-tensor-411113.marketing_test.leads` AS l
LEFT JOIN `e-tensor-411113.marketing_test.vendas` AS v
ON l.email = v.email
GROUP BY email_lead
ORDER BY conversion_rate DESC

## Uma análise com Python seria interessante para verificar se a diferença entre os níveis de conversão para os diferentes emails tem significância estatística. 
  Caso sim, é possível analisar as causas para a diferença, como a possibilidade de um email como Gmail ou outros domínios estarem reconhecendo as informações enviadas como spam e impactando as vendas. 
  O terceiro grupo é classificado como outros por possivelmente ser composto por emails com domínios próprios, como de empresas e que podem possuir filtros de spam/firewall diferentes.
