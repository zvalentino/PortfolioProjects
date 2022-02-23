--Covid-19 Data Exploration
--Skills used: Joins, Create Tables, Aggregate Functions



SELECT  *
FROM`firstprojectbq-336101.covid.coviddeaths`
ORDER BY  3,4

--Select the data that we will be using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `firstprojectbq-336101.covid.coviddeaths` 
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows the likely hood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM `firstprojectbq-336101.covid.coviddeaths` 
WHERE location = 'United States'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of the population has covid 

SELECT location, date, population, total_cases,(total_cases/population)*100 as  PopulationPercentage
FROM `firstprojectbq-336101.covid.coviddeaths` 
WHERE location = 'United States'
ORDER BY 1,2

--Looking at countries with the highest infection rate compared the Population

SELECT location, population, max(total_cases) as HighestInfectionCountry, max(total_cases/population)*100 as PopulationPercentage
FROM `firstprojectbq-336101.covid.coviddeaths` 
GROUP BY location, population
ORDER BY PopulationPercentage DESC  

--Showing the countries with the highest death count per population

SELECT location, max(total_deaths) as TotalDeathCount
FROM `firstprojectbq-336101.covid.coviddeaths` 
WHERE continent is not null 
GROUP BY location
ORDER BY TotalDeathCount DESC  

--Let's break things down by continent 
--Showing the continents with the highest death count
SELECT location, max(total_deaths) as TotalDeathCount
FROM `firstprojectbq-336101.covid.coviddeaths` 
WHERE continent is null 
GROUP BY location
ORDER BY TotalDeathCount DESC  

--Global numbers 

SELECT date, SUM(new_cases) as SumNewCases, SUM(new_deaths) as SumNewDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM `firstprojectbq-336101.covid.coviddeaths` 
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2

--Total global cases, deaths, and death percentage 

SELECT SUM(new_cases) as SumNewCases, SUM(new_deaths) as SumNewDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM `firstprojectbq-336101.covid.coviddeaths` 
WHERE continent is not null 
ORDER BY 1,2

-- Looking at Total Population vs Vaccinations 

SELECT deaths.continent, deaths.location,deaths.date, deaths.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/)
FROM `firstprojectbq-336101.covid.coviddeaths` deaths
JOIN `firstprojectbq-336101.covid.covidvaccinations` vax
ON  deaths.location = vax.location 
AND deaths.date = vax.date
WHERE deaths.continent is not null 
ORDER BY 2,3


--Creating a new table 

CREATE TABLE covid.PercentPopulationVaccinated
(
    continent string,
    location string,
    date date,
    population integer,
    new_vaccinations integer,
    RollingPeopleVaccinated integer

) AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (PARTITION BY deaths.location ORDER BY deaths.location, deaths.date) as RollingPeopleVaccinated,
FROM `firstprojectbq-336101.covid.coviddeaths` deaths
JOIN `firstprojectbq-336101.covid.covidvaccinations` vax
ON  deaths.location = vax.location 
AND deaths.date = vax.date


select *
from `firstprojectbq-336101.covid.PercentPopulationVaccinated`






