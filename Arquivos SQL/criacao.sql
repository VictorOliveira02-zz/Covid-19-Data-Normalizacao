-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema DATABASE-220
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema DATABASE-220
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DATABASE-220` DEFAULT CHARACTER SET utf8 ;
USE `DATABASE-220` ;

-- -----------------------------------------------------
-- Table `DATABASE-220`.`DATA_HOSPITAL_ICU`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`DATA_HOSPITAL_ICU` (
  `id_data_hospital` INT NOT NULL AUTO_INCREMENT,
  `icu_patients` FLOAT NULL,
  `hosp_patients` FLOAT NULL,
  `hosp_patients_per_million` FLOAT NULL,
  `weekly_icu_admissions` FLOAT NULL,
  `weekly_icu_admissions_per_million` FLOAT NULL,
  `weekly_hosp_admissions` FLOAT NULL,
  `weekly_hosp_admissions_per_million` FLOAT NULL,
  PRIMARY KEY (`id_data_hospital`),
  UNIQUE INDEX `id_data_hospital_UNIQUE` (`id_data_hospital` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`CONFIRMED_CASES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`CONFIRMED_CASES` (
  `id_confirmed_cases` INT NOT NULL AUTO_INCREMENT,
  `total_cases` FLOAT NULL,
  `new_cases` FLOAT NULL,
  `new_cases_smoothed` FLOAT NULL,
  `new_cases_per_million` FLOAT NULL,
  `new_cases_smoothed_per_million` FLOAT NULL,
  `reproduction_rate` FLOAT NULL,
  `id_data_hospital` INT NOT NULL,
  PRIMARY KEY (`id_confirmed_cases`, `id_data_hospital`),
  UNIQUE INDEX `id_casos_confirmados_UNIQUE` (`id_confirmed_cases` ASC) VISIBLE,
  INDEX `fk_CONFIRMED_CASES_DATA_HOSPITAL_ICU1_idx` (`id_data_hospital` ASC) VISIBLE,
  CONSTRAINT `fk_CONFIRMED_CASES_DATA_HOSPITAL_ICU1`
    FOREIGN KEY (`id_data_hospital`)
    REFERENCES `DATABASE-220`.`DATA_HOSPITAL_ICU` (`id_data_hospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`EXCESS_MORTALITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`EXCESS_MORTALITY` (
  `id_excess_mortality` INT NOT NULL AUTO_INCREMENT,
  `excess_mortality` FLOAT NULL,
  `excess_mortality_cumulative` FLOAT NULL,
  `excess_mortality_cumulative_absolute` FLOAT NULL,
  `excess_mortality_cumulative_per_million` FLOAT NULL,
  PRIMARY KEY (`id_excess_mortality`),
  UNIQUE INDEX `id_excess_mortality_UNIQUE` (`id_excess_mortality` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`CONFIRMED_DEATHS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`CONFIRMED_DEATHS` (
  `id_confirmed_deaths` INT NOT NULL AUTO_INCREMENT,
  `total_deaths` FLOAT NULL,
  `new_deaths` FLOAT NULL,
  `total_deaths_per_million` FLOAT NULL,
  `new_deaths_smoothed_per_million` FLOAT NULL,
  `id_data_hospital` INT NOT NULL,
  `id_excess_mortality` INT NOT NULL,
  `id_confirmed_cases` INT NOT NULL,
  PRIMARY KEY (`id_confirmed_deaths`, `id_data_hospital`, `id_excess_mortality`, `id_confirmed_cases`),
  UNIQUE INDEX `id_confirmed_deaths_UNIQUE` (`id_confirmed_deaths` ASC) VISIBLE,
  INDEX `fk_CONFIRMED_DEATHS_DATA_HOSPITAL_ICU1_idx` (`id_data_hospital` ASC) VISIBLE,
  INDEX `fk_CONFIRMED_DEATHS_EXCESS_MORTALITY1_idx` (`id_excess_mortality` ASC) VISIBLE,
  INDEX `fk_CONFIRMED_DEATHS_CONFIRMED_CASES1_idx` (`id_confirmed_cases` ASC) VISIBLE,
  CONSTRAINT `fk_CONFIRMED_DEATHS_DATA_HOSPITAL_ICU1`
    FOREIGN KEY (`id_data_hospital`)
    REFERENCES `DATABASE-220`.`DATA_HOSPITAL_ICU` (`id_data_hospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONFIRMED_DEATHS_EXCESS_MORTALITY1`
    FOREIGN KEY (`id_excess_mortality`)
    REFERENCES `DATABASE-220`.`EXCESS_MORTALITY` (`id_excess_mortality`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CONFIRMED_DEATHS_CONFIRMED_CASES1`
    FOREIGN KEY (`id_confirmed_cases`)
    REFERENCES `DATABASE-220`.`CONFIRMED_CASES` (`id_confirmed_cases`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`TESTS_POSITIVITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`TESTS_POSITIVITY` (
  `id_tests_positivity` INT NOT NULL AUTO_INCREMENT,
  `total_tests` FLOAT NULL,
  `new_tests` FLOAT NULL,
  `new_tests_per_thousand` FLOAT NULL,
  `total_tests_per_thousand` FLOAT NULL,
  `new_tests_smoothed` FLOAT NULL,
  `new_tests_smoothed_per_thousand` FLOAT NULL,
  `positive_rate` FLOAT NULL,
  `tests_per_case` FLOAT NULL,
  `tests_units` FLOAT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`id_tests_positivity`),
  UNIQUE INDEX `id_tests_positivity_UNIQUE` (`id_tests_positivity` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`DATA_VACCINATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`DATA_VACCINATION` (
  `id_data_vaccination` INT NOT NULL AUTO_INCREMENT,
  `total_vaccinations` FLOAT NULL,
  `people_vaccinated` FLOAT NULL,
  `people_fully_vaccinated` FLOAT NULL,
  `total_boosters` FLOAT NULL,
  `new_vaccinations` FLOAT NULL,
  `new_vaccinations_smoothed` FLOAT NULL,
  `total_vaccinations_per_hundred` FLOAT NULL,
  `people_vaccinated_per_hundred` FLOAT NULL,
  `people_fully_vaccinated_per_hundred` FLOAT NULL,
  `total_boosters_per_hundred` FLOAT NULL,
  `new_vaccinations_smoothed_per_million` FLOAT NULL,
  `new_people_vaccinated_smoothed` FLOAT NULL,
  `new_people_vaccinated_smoothed_per_hundred` FLOAT NULL,
  PRIMARY KEY (`id_data_vaccination`),
  UNIQUE INDEX `id_data_vaccination_UNIQUE` (`id_data_vaccination` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`COUNTRY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`COUNTRY` (
  `id_country` INT NOT NULL AUTO_INCREMENT,
  `iso_code` TEXT NULL,
  `continent` TEXT NULL,
  `location` TEXT NULL,
  PRIMARY KEY (`id_country`),
  UNIQUE INDEX `id_country_UNIQUE` (`id_country` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`POPULATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`POPULATION` (
  `id_population` INT NOT NULL AUTO_INCREMENT,
  `population` FLOAT NULL,
  `population_density` FLOAT NULL,
  `aged_65_older` FLOAT NULL,
  `aged_70_older` FLOAT NULL,
  `gdp_per_capita` FLOAT NULL,
  `cardiovasc_death_rate` FLOAT NULL,
  `female_smokers` FLOAT NULL,
  `male_smokers` FLOAT NULL,
  `handwashing_facilities` FLOAT NULL,
  `hospital_beds_per_thousand` FLOAT NULL,
  `life_expectancy` FLOAT NULL,
  `human_development_index` FLOAT NULL,
  `id_country` INT NOT NULL,
  PRIMARY KEY (`id_population`, `id_country`),
  UNIQUE INDEX `id_population_UNIQUE` (`id_population` ASC) VISIBLE,
  INDEX `fk_POPULATION_COUNTRY1_idx` (`id_country` ASC) VISIBLE,
  CONSTRAINT `fk_POPULATION_COUNTRY1`
    FOREIGN KEY (`id_country`)
    REFERENCES `DATABASE-220`.`COUNTRY` (`id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`POPULATION_HAS_VACCIONATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`POPULATION_HAS_VACCIONATION` (
  `id_data_vaccination` INT NOT NULL,
  `id_population` INT NOT NULL,
  `id_country` INT NOT NULL,
  PRIMARY KEY (`id_data_vaccination`, `id_population`, `id_country`),
  INDEX `fk_DATA_VACCINATION_has_POPULATION_POPULATION1_idx` (`id_population` ASC, `id_country` ASC) VISIBLE,
  INDEX `fk_DATA_VACCINATION_has_POPULATION_DATA_VACCINATION1_idx` (`id_data_vaccination` ASC) VISIBLE,
  CONSTRAINT `fk_DATA_VACCINATION_has_POPULATION_DATA_VACCINATION1`
    FOREIGN KEY (`id_data_vaccination`)
    REFERENCES `DATABASE-220`.`DATA_VACCINATION` (`id_data_vaccination`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DATA_VACCINATION_has_POPULATION_POPULATION1`
    FOREIGN KEY (`id_population` , `id_country`)
    REFERENCES `DATABASE-220`.`POPULATION` (`id_population` , `id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`POPULATION_HAS_TESTS_POSITIVITY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`POPULATION_HAS_TESTS_POSITIVITY` (
  `id_population` INT NOT NULL,
  `id_country` INT NOT NULL,
  `id_tests_positivity` INT NOT NULL,
  PRIMARY KEY (`id_population`, `id_country`, `id_tests_positivity`),
  INDEX `fk_POPULATION_has_TESTS_POSITIVITY_TESTS_POSITIVITY1_idx` (`id_tests_positivity` ASC) VISIBLE,
  INDEX `fk_POPULATION_has_TESTS_POSITIVITY_POPULATION1_idx` (`id_population` ASC, `id_country` ASC) VISIBLE,
  CONSTRAINT `fk_POPULATION_has_TESTS_POSITIVITY_POPULATION1`
    FOREIGN KEY (`id_population` , `id_country`)
    REFERENCES `DATABASE-220`.`POPULATION` (`id_population` , `id_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_POPULATION_has_TESTS_POSITIVITY_TESTS_POSITIVITY1`
    FOREIGN KEY (`id_tests_positivity`)
    REFERENCES `DATABASE-220`.`TESTS_POSITIVITY` (`id_tests_positivity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DATABASE-220`.`TESTS_POSITIVITY_HAS_DATA_HOSPITAL_ICU`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DATABASE-220`.`TESTS_POSITIVITY_HAS_DATA_HOSPITAL_ICU` (
  `id_tests_positivity` INT NOT NULL,
  `id_data_hospital` INT NOT NULL,
  PRIMARY KEY (`id_tests_positivity`, `id_data_hospital`),
  INDEX `fk_TESTS_POSITIVITY_has_DATA_HOSPITAL_ICU_DATA_HOSPITAL_ICU_idx` (`id_data_hospital` ASC) VISIBLE,
  INDEX `fk_TESTS_POSITIVITY_has_DATA_HOSPITAL_ICU_TESTS_POSITIVITY1_idx` (`id_tests_positivity` ASC) VISIBLE,
  CONSTRAINT `fk_TESTS_POSITIVITY_has_DATA_HOSPITAL_ICU_TESTS_POSITIVITY1`
    FOREIGN KEY (`id_tests_positivity`)
    REFERENCES `DATABASE-220`.`TESTS_POSITIVITY` (`id_tests_positivity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TESTS_POSITIVITY_has_DATA_HOSPITAL_ICU_DATA_HOSPITAL_ICU1`
    FOREIGN KEY (`id_data_hospital`)
    REFERENCES `DATABASE-220`.`DATA_HOSPITAL_ICU` (`id_data_hospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
