-- --------------------------------------------
-- Inserção dos dados na Tabela 'country'
-- --------------------------------------------
INSERT INTO country(iso_code, continent, location,stringency_index)
SELECT iso_code, continent, location, stringency_index
FROM covid_data;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'population'
-- --------------------------------------------
INSERT INTO population(id_country, population, population_density, aged_65_older, aged_70_older, gdp_per_capita,
cardiovasc_death_rate, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand,
life_expectancy, human_development_index)
SELECT country.id_country, population, population_density, aged_65_older, aged_70_older, gdp_per_capita,
cardiovasc_death_rate, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand,
life_expectancy, human_development_index
FROM covid_data LEFT JOIN country
ON covid_data.iso_code = country.iso_code;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'data_vaccination'
-- --------------------------------------------
INSERT INTO data_vaccination(id_population, id_country, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters,
new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred,
total_boosters_per_hundred, new_vaccinations_smoothed_per_million, new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred)
SELECT p.id_population, p.id_country, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters,
new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred,
total_boosters_per_hundred, new_vaccinations_smoothed_per_million, new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred
FROM covid_data JOIN population p
ON covid_data.population = p.population;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'tests_positivity'
-- --------------------------------------------
INSERT INTO tests_positivity(id_population, total_tests, new_tests, new_tests_per_thousand, total_tests_per_thousand, new_tests_smoothed,
new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units, `date`)
SELECT p.id_population, total_tests, new_tests, new_tests_per_thousand, total_tests_per_thousand, new_tests_smoothed,
new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units, `date`
FROM covid_data JOIN population p
ON covid_data.population = p.population;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'data_hospital_icu'
-- --------------------------------------------
INSERT INTO data_hospital_icu(id_tests_positivity, icu_patients, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
weekly_hosp_admissions, weekly_hosp_admissions_per_million)
SELECT tp.id_tests_positivity, icu_patients, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
weekly_hosp_admissions, weekly_hosp_admissions_per_million
FROM covid_data JOIN tests_positivity tp
ON covid_data.date = tp.date;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'confirmed_cases'
-- --------------------------------------------
INSERT INTO confirmed_cases(id_data_hospital, total_cases, new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million, reproduction_rate)
SELECT dhi.id_data_hospital, total_cases, new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million, reproduction_rate
FROM covid_data JOIN data_hospital_icu dhi
ON covid_data.icu_patients = dhi.icu_patients;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'excess_mortality'
-- --------------------------------------------
INSERT INTO excess_mortality(excess_mortality, excess_mortality_cumulative, excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million)
SELECT excess_mortality, excess_mortality_cumulative, excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million
FROM covid_data;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'confirmed_deaths'
-- --------------------------------------------
INSERT INTO confirmed_deaths(id_data_hospital, id_excess_mortality, id_confirmed_cases, total_deaths, new_deaths, total_deaths_per_million, new_deaths_smoothed_per_million)
SELECT dhi.id_data_hospital, em.id_excess_mortality, cc.id_confirmed_cases, total_deaths, new_deaths, total_deaths_per_million, new_deaths_smoothed_per_million
FROM covid_data 
	JOIN data_hospital_icu dhi ON covid_data.icu_patients = dhi.icu_patients
	JOIN excess_mortality em ON covid_data.excess_mortality = em.excess_mortality
	JOIN confirmed_cases cc ON covid_data.reproduction_rate = cc.reproduction_rate;