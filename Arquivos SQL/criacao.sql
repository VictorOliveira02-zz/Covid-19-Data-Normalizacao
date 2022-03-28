-- ---------------------------------------------------
-- Database database_220
-- -----------------------------------------------------
DROP DATABASE IF EXISTS database_220;
CREATE DATABASE IF NOT EXISTS database_220;
USE database_220;


-- -----------------------------------------------------
-- Table COUNTRY
-- -----------------------------------------------------
DROP TABLE IF EXISTS COUNTRY;
CREATE TABLE IF NOT EXISTS COUNTRY(
  iso_code  VARCHAR(10) PRIMARY KEY,
  continent TEXT DEFAULT NULL,
  location TEXT DEFAULT NULL
);

  
-- -----------------------------------------------------
-- Table POPULATION
-- -----------------------------------------------------
DROP TABLE IF EXISTS POPULATION;
CREATE TABLE IF NOT EXISTS POPULATION(
  iso_code VARCHAR(10) PRIMARY KEY,
  iso_code_country VARCHAR(10) DEFAULT NULL,
  population FLOAT DEFAULT NULL,
  population_density FLOAT DEFAULT NULL,
  aged_65_older FLOAT DEFAULT NULL,
  aged_70_older FLOAT DEFAULT NULL,
  gdp_per_capita FLOAT DEFAULT NULL,
  cardiovasc_death_rate FLOAT DEFAULT NULL,
  female_smokers FLOAT DEFAULT NULL,
  male_smokers FLOAT DEFAULT NULL,
  handwashing_facilities FLOAT DEFAULT NULL,
  hospital_beds_per_thousand FLOAT DEFAULT NULL,
  life_expectancy FLOAT DEFAULT NULL,
  human_development_index FLOAT DEFAULT NULL,
  FOREIGN KEY (iso_code_country) REFERENCES COUNTRY (iso_code)
);


-- -----------------------------------------------------
-- Table DATA_VACCINATION
-- -----------------------------------------------------
DROP TABLE IF EXISTS DATA_VACCINATION;
CREATE TABLE IF NOT EXISTS DATA_VACCINATION(
   id_data_vaccination INT PRIMARY KEY AUTO_INCREMENT,
  `date` DATETIME,
  iso_code_population VARCHAR(10),
  total_vaccinations FLOAT DEFAULT NULL,
  people_vaccinated FLOAT DEFAULT NULL,
  people_fully_vaccinated FLOAT DEFAULT NULL,
  total_boosters FLOAT DEFAULT NULL,
  new_vaccinations FLOAT DEFAULT NULL,
  new_vaccinations_smoothed FLOAT DEFAULT NULL,
  total_vaccinations_per_hundred FLOAT DEFAULT NULL,
  people_vaccinated_per_hundred FLOAT DEFAULT NULL,
  people_fully_vaccinated_per_hundred FLOAT DEFAULT NULL,
  total_boosters_per_hundred FLOAT DEFAULT NULL,
  new_vaccinations_smoothed_per_million FLOAT DEFAULT NULL,
  new_people_vaccinated_smoothed FLOAT DEFAULT NULL,
  new_people_vaccinated_smoothed_per_hundred FLOAT DEFAULT NULL,
  stringency_index FLOAT DEFAULT NULL,
  FOREIGN KEY (iso_code_population) REFERENCES POPULATION (iso_code)
);


-- -----------------------------------------------------
-- Table DATA_HOSPITAL_ICU
-- -----------------------------------------------------
DROP TABLE IF EXISTS DATA_HOSPITAL_ICU;
CREATE TABLE IF NOT EXISTS DATA_HOSPITAL_ICU(
   id_data_hospital INT PRIMARY KEY AUTO_INCREMENT,
  `date` DATETIME,
  icu_patients FLOAT DEFAULT NULL,
  hosp_patients FLOAT DEFAULT NULL,
  hosp_patients_per_million FLOAT DEFAULT NULL,
  weekly_icu_admissions FLOAT DEFAULT NULL,
  weekly_icu_admissions_per_million FLOAT DEFAULT NULL,
  weekly_hosp_admissions FLOAT DEFAULT NULL,
  weekly_hosp_admissions_per_million FLOAT DEFAULT NULL
);


-- -----------------------------------------------------
-- Table CONFIRMED_CASES
-- -----------------------------------------------------
DROP TABLE IF EXISTS CONFIRMED_CASES;
CREATE TABLE IF NOT EXISTS CONFIRMED_CASES (
   id_confirmed_cases INT PRIMARY KEY AUTO_INCREMENT,
  `date` DATETIME,
  id_data_hospital INT,
  total_cases FLOAT DEFAULT NULL,
  new_cases FLOAT DEFAULT NULL,
  new_cases_smoothed FLOAT DEFAULT NULL,
  new_cases_per_million FLOAT DEFAULT NULL,
  new_cases_smoothed_per_million FLOAT DEFAULT NULL,
  reproduction_rate FLOAT DEFAULT NULL,
  FOREIGN KEY (id_data_hospital) REFERENCES DATA_HOSPITAL_ICU (id_data_hospital)
);


-- -----------------------------------------------------
-- Table TESTS_POSITIVITY
-- -----------------------------------------------------
DROP TABLE IF EXISTS TESTS_POSITIVITY;
CREATE TABLE IF NOT EXISTS TESTS_POSITIVITY(
   id_tests_positivity INT PRIMARY KEY AUTO_INCREMENT,
  `date` DATETIME,
  id_confirmed_cases INT,
  total_tests FLOAT DEFAULT NULL,
  new_tests FLOAT DEFAULT NULL,
  new_tests_per_thousand FLOAT DEFAULT NULL,
  total_tests_per_thousand FLOAT DEFAULT NULL,
  new_tests_smoothed FLOAT DEFAULT NULL,
  new_tests_smoothed_per_thousand FLOAT DEFAULT NULL,
  positive_rate FLOAT DEFAULT NULL,
  tests_per_case FLOAT DEFAULT NULL,
  tests_units FLOAT DEFAULT NULL,
  FOREIGN KEY (id_confirmed_cases) REFERENCES CONFIRMED_CASES (id_confirmed_cases)
);


-- -----------------------------------------------------
-- Table EXCESS_MORTALITY
-- -----------------------------------------------------
DROP TABLE IF EXISTS EXCESS_MORTALITY;
CREATE TABLE IF NOT EXISTS EXCESS_MORTALITY(
   id_excess_mortality INT PRIMARY KEY AUTO_INCREMENT,
  `date` DATETIME,
  excess_mortality FLOAT DEFAULT NULL,
  excess_mortality_cumulative FLOAT DEFAULT NULL,
  excess_mortality_cumulative_absolute FLOAT DEFAULT NULL,
  excess_mortality_cumulative_per_million FLOAT DEFAULT NULL
);


-- -----------------------------------------------------
-- Table CONFIRMED_DEATHS
-- -----------------------------------------------------
DROP TABLE IF EXISTS CONFIRMED_DEATHS;
CREATE TABLE IF NOT EXISTS CONFIRMED_DEATHS(
  id_confirmed_deaths INT PRIMARY KEY AUTO_INCREMENT,
  id_data_hospital INT,
  id_excess_mortality INT,
  `date` DATETIME,
  total_deaths FLOAT DEFAULT NULL,
  new_deaths FLOAT DEFAULT NULL,
  total_deaths_per_million FLOAT DEFAULT NULL,
  new_deaths_smoothed_per_million FLOAT DEFAULT NULL,
  FOREIGN KEY (id_data_hospital) REFERENCES DATA_HOSPITAL_ICU (id_data_hospital),
  FOREIGN KEY (id_excess_mortality) REFERENCES  EXCESS_MORTALITY (id_excess_mortality)
);


-- -----------------------------------------------------
-- Table covid_data
-- -----------------------------------------------------
DROP TABLE IF EXISTS covid_data;
CREATE TABLE IF NOT EXISTS covid_data (
  iso_code VARCHAR(10),
  continent text,
  location text,
  `date` date  DEFAULT NULL,
  total_cases float DEFAULT NULL,
  new_cases float DEFAULT NULL,
  new_cases_smoothed float DEFAULT NULL,
  total_deaths float DEFAULT NULL,
  new_deaths float DEFAULT NULL,
  new_deaths_smoothed float DEFAULT NULL,
  total_cases_per_million float DEFAULT NULL,
  new_cases_per_million float DEFAULT NULL,
  new_cases_smoothed_per_million float DEFAULT NULL,
  total_deaths_per_million float DEFAULT NULL,
  new_deaths_per_million float DEFAULT NULL,
  new_deaths_smoothed_per_million float DEFAULT NULL,
  reproduction_rate float DEFAULT NULL,
  icu_patients float DEFAULT NULL,
  icu_patients_per_million float DEFAULT NULL,
  hosp_patients float DEFAULT NULL,
  hosp_patients_per_million float DEFAULT NULL,
  weekly_icu_admissions float DEFAULT NULL,
  weekly_icu_admissions_per_million float DEFAULT NULL,
  weekly_hosp_admissions float DEFAULT NULL,
  weekly_hosp_admissions_per_million float DEFAULT NULL,
  new_tests float DEFAULT NULL,
  total_tests float DEFAULT NULL,
  total_tests_per_thousand float DEFAULT NULL,
  new_tests_per_thousand float DEFAULT NULL,
  new_tests_smoothed float DEFAULT NULL,
  new_tests_smoothed_per_thousand float DEFAULT NULL,
  positive_rate float DEFAULT NULL,
  tests_per_case float DEFAULT NULL,
  tests_units float DEFAULT NULL,
  total_vaccinations float DEFAULT NULL,
  people_vaccinated float DEFAULT NULL,
  people_fully_vaccinated float DEFAULT NULL,
  total_boosters float DEFAULT NULL,
  new_vaccinations float DEFAULT NULL,
  new_vaccinations_smoothed float DEFAULT NULL,
  total_vaccinations_per_hundred float DEFAULT NULL,
  people_vaccinated_per_hundred float DEFAULT NULL,
  people_fully_vaccinated_per_hundred float DEFAULT NULL,
  total_boosters_per_hundred float DEFAULT NULL,
  new_vaccinations_smoothed_per_million float DEFAULT NULL,
  new_people_vaccinated_smoothed float DEFAULT NULL,
  new_people_vaccinated_smoothed_per_hundred float DEFAULT NULL,
  stringency_index float DEFAULT NULL,
  population float DEFAULT NULL,
  population_density float DEFAULT NULL,
  median_age float DEFAULT NULL,
  aged_65_older float DEFAULT NULL,
  aged_70_older float DEFAULT NULL,
  gdp_per_capita float DEFAULT NULL,
  extreme_poverty float DEFAULT NULL,
  cardiovasc_death_rate float DEFAULT NULL,
  diabetes_prevalence float DEFAULT NULL,
  female_smokers float DEFAULT NULL,
  male_smokers float DEFAULT NULL,
  handwashing_facilities float DEFAULT NULL,
  hospital_beds_per_thousand float DEFAULT NULL,
  life_expectancy float DEFAULT NULL,
  human_development_index float DEFAULT NULL,
  excess_mortality_cumulative_absolute float DEFAULT NULL,
  excess_mortality_cumulative float DEFAULT NULL,
  excess_mortality float DEFAULT NULL,
  excess_mortality_cumulative_per_million float NULL
);