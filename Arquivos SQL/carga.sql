-- --------------------------------------------
-- Inserção dos dados na Tabela 'country'
-- --------------------------------------------
INSERT INTO country(iso_code, location, continent)
SELECT DISTINCT iso_code, location, continent
FROM covid_data;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'population'
-- --------------------------------------------
INSERT INTO population(iso_code, iso_code_country, population, population_density, aged_65_older, aged_70_older, gdp_per_capita,
cardiovasc_death_rate, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand,
life_expectancy, human_development_index)
SELECT DISTINCT covid_data.iso_code, country.iso_code, population, population_density, aged_65_older, aged_70_older, gdp_per_capita,
cardiovasc_death_rate, female_smokers, male_smokers, handwashing_facilities, hospital_beds_per_thousand,
life_expectancy, human_development_index
FROM covid_data JOIN country ON covid_data.iso_code = country.iso_code;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'data_vaccination'
-- --------------------------------------------
INSERT INTO data_vaccination(`date`, iso_code_population, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters,
new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred,
total_boosters_per_hundred, new_vaccinations_smoothed_per_million, new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred, stringency_index)
SELECT DISTINCT covid_data.date, population.iso_code, total_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters,
new_vaccinations, new_vaccinations_smoothed, total_vaccinations_per_hundred, people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred,
total_boosters_per_hundred, new_vaccinations_smoothed_per_million, new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred, stringency_index
FROM covid_data JOIN population ON covid_data.iso_code = population.iso_code;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'data_hospital_icu'
-- --------------------------------------------
INSERT INTO data_hospital_icu(`date`, icu_patients, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
weekly_hosp_admissions, weekly_hosp_admissions_per_million)
SELECT DISTINCT covid_data.date, icu_patients, hosp_patients, hosp_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million,
weekly_hosp_admissions, weekly_hosp_admissions_per_million
FROM covid_data;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'confirmed_cases'
-- --------------------------------------------
INSERT INTO confirmed_cases(`date`, id_data_hospital,  total_cases, new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million, reproduction_rate)
SELECT DISTINCT covid_data.date, dhi.id_data_hospital, total_cases, new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million, reproduction_rate
FROM covid_data JOIN data_hospital_icu dhi ON covid_data.date = dhi.date;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'tests_positivity'
-- --------------------------------------------
INSERT INTO tests_positivity(`date`, id_confirmed_cases, total_tests, new_tests, new_tests_per_thousand, total_tests_per_thousand, new_tests_smoothed,
new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units)
SELECT DISTINCT covid_data.date, cs.id_confirmed_cases, total_tests, new_tests, new_tests_per_thousand, total_tests_per_thousand, new_tests_smoothed,
new_tests_smoothed_per_thousand, positive_rate, tests_per_case, tests_units
FROM covid_data JOIN confirmed_cases cs ON covid_data.date = cs.date;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'excess_mortality'
-- --------------------------------------------
INSERT INTO excess_mortality(`date`, excess_mortality, excess_mortality_cumulative, excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million)
SELECT DISTINCT date, excess_mortality, excess_mortality_cumulative, excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million
FROM covid_data0;


-- --------------------------------------------
-- Inserção dos dados na Tabela 'confirmed_deaths'
-- --------------------------------------------
INSERT INTO confirmed_deaths(`date`, id_data_hospital, id_excess_mortality, total_deaths, new_deaths, total_deaths_per_million, new_deaths_smoothed_per_million)
SELECT DISTINCT covid_data.date, dhi.id_data_hospital, em.id_excess_mortality, total_deaths, new_deaths, total_deaths_per_million, new_deaths_smoothed_per_million
FROM covid_data 
	JOIN data_hospital_icu dhi ON covid_data.date = dhi.date
	JOIN excess_mortality em ON covid_data.date = em.date;