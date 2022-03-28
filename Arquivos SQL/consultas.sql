-- -----------------------------------------------------
-- 1. Quantos países estão na base de dados?
-- -----------------------------------------------------
SELECT COUNT(DISTINCT location)
FROM country
WHERE iso_code NOT LIKE '%OWID%';


-- -----------------------------------------------------
-- 2. Qual o total de casos para o mundo no dia 01/02/2022?
-- -----------------------------------------------------
select sum(new_cases) as 'Total de Casos'
from confirmed_cases
where date = '2022-02-01';


-- -----------------------------------------------------
-- 3. Quais foram os 10 países com mais casos confirmados no mês de janeiro/2022 (ordem descrescente)?
-- -----------------------------------------------------
SELECT DISTINCT country.location 
FROM country 
	JOIN population ON country.iso_code = population.iso_code_country
    JOIN data_vaccination ON country.iso_code = data_vaccination.iso_code_population
    JOIN confirmed_cases ON data_vaccination.date = confirmed_cases.date
WHERE confirmed_cases.date BETWEEN '2022-01-01' AND '2022-01-31'
ORDER BY country.location DESC
LIMIT 10;


-- -----------------------------------------------------
-- 4. Liste os 10 países com maior e os 10 com menor expectativa de vida.
-- -----------------------------------------------------
WITH maior AS(
	SELECT country.location, 
    ROW_NUMBER() OVER(ORDER BY population.life_expectancy DESC) AS lex
	FROM country
	JOIN population ON country.iso_code = population.iso_code_country
    WHERE country.iso_code NOT LIKE '%OWID%'
	ORDER BY  population.life_expectancy DESC
    ),
menor AS(
	SELECT country.location, 
    ROW_NUMBER() OVER(ORDER BY population.life_expectancy ASC) AS lex
	FROM country
	JOIN population ON country.iso_code = population.iso_code_country
    WHERE country.iso_code NOT LIKE '%OWID%'
	ORDER BY  population.life_expectancy ASC
    )
SELECT maior.location AS 'Maior expectativa de vida',
	   menor.location AS 'Menor expectativa de vida'
FROM maior, menor
WHERE maior.lex = menor.lex
LIMIT 10;


-- -----------------------------------------------------
-- 5. Liste os continentes contendo o total de casos de cada um em 2021
-- -----------------------------------------------------
SELECT DISTINCT country.continent, SUM(confirmed_cases.new_cases) AS 'Total de casos em 2021'
FROM country 
	JOIN population ON country.iso_code = population.iso_code_country
    JOIN data_vaccination ON country.iso_code = data_vaccination.iso_code_population
    JOIN confirmed_cases ON data_vaccination.date = confirmed_cases.date
WHERE confirmed_cases.date BETWEEN '20221-01-01' AND '2021-12-31'
GROUP BY country.continent;


-- -----------------------------------------------------
-- 6. Liste os países da Europa e inclua as informações do total de pessoas totalmente
-- vacinadas em 2021, em valores absolutos e percentuais. Ordene o resultado em
-- ordem decrescente pelo percentual de vacinados.
-- -----------------------------------------------------
SELECT country.location, 
abs(max(data_vaccination.people_fully_vaccinated)) AS 'Pessoas totalmente vacinadas',
round((max(data_vaccination.people_fully_vaccinated)*100/population.population),2) AS `Pessoas totalmente vacinadas(%)`
FROM country 
	JOIN population ON country.iso_code = population.iso_code_country
    JOIN data_vaccination ON country.iso_code = data_vaccination.iso_code_population
WHERE population.iso_code = data_vaccination.iso_code_population AND country.continent = 'Europe' AND data_vaccination.date LIKE '2021%'
GROUP BY country.location
ORDER BY `Pessoas totalmente vacinadas(%)` DESC;


-- -----------------------------------------------------
-- 7. Liste os países informando o grau de restrições que foram aplicadas à população
-- (há um atributo com este índice (stringency) que engloba várias medidas como
-- fechamento de escolas, proibição de viagens, . . . ) e o total de novos casos por
-- milhão de habitantes confirmados para o mês de janeiro/2022.
-- -----------------------------------------------------
SELECT country.location,
round(avg(data_vaccination.stringency_index),2),
round(sum(confirmed_cases.new_cases_per_million),2)
FROM country 
	JOIN population ON country.iso_code = population.iso_code_country
    JOIN data_vaccination ON country.iso_code = data_vaccination.iso_code_population
    JOIN confirmed_cases ON data_vaccination.date = confirmed_cases.date
WHERE country.iso_code = population.iso_code_country AND confirmed_cases.date LIKE '2022-01%'
GROUP BY country.location;


-- -----------------------------------------------------
-- 8. Quais países não possuem informação de pacientes na UTI para o mês de janeiro/2022
-- -----------------------------------------------------
WITH paises AS(
	SELECT country.location, sum(data_hospital_icu.icu_patients) AS patients
FROM country 
	JOIN population ON country.iso_code = population.iso_code_country
    JOIN data_vaccination ON country.iso_code = data_vaccination.iso_code_population
    JOIN data_hospital_icu ON data_hospital_icu.date = data_vaccination.date
	WHERE data_hospital_icu.date LIKE '2022-01%' AND country.iso_code NOT LIKE 'OWID%'
    GROUP BY country.location 
    )
SELECT location
FROM paises
WHERE paises.patients IS NULL;


-- -----------------------------------------------------
-- 9. Qual foi o dia com a maior quantidade de novos casos registrados de COVID-19 no Brasil?
-- -----------------------------------------------------
SELECT DISTINCT confirmed_cases.date
FROM country 
	JOIN population ON country.iso_code = population.iso_code_country
    JOIN data_vaccination ON country.iso_code = data_vaccination.iso_code_population
    JOIN confirmed_cases ON data_vaccination.date = confirmed_cases.date
WHERE country.iso_code = 'BRA'
ORDER BY confirmed_cases.new_cases DESC
LIMIT 1;

-- -----------------------------------------------------
-- 10. Qual foi o dia com a maior quantidade de mortes confirmadas por COVID-19 no mundo?
-- -----------------------------------------------------
SELECT date
FROM confirmed_deaths
WHERE (
    SELECT max(total_deaths)
    FROM confirmed_deaths
    )
ORDER BY total_deaths DESC
LIMIT 1;