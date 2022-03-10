--Covid-19 Data Exploration Project 
-- Skill used: Joins, Temp Tables, CTE's, Aggregate functions, views, coverting data types


SELECT *
FROM projects..coviddeaths
WHERE continent is not null
ORDER BY 3,4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM projects..coviddeaths
WHERE continent is not null 
ORDER BY 1,2

--Total Cases vs Total Deaths
--Shows the liklihood of you dying in your country from covid

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM projects..coviddeaths
WHERE location = 'United States'
ORDER BY 1,2

--Looking at Total Cases vs Population 
--Shows what percentage of the US has covid

SELECT location, date, population, total_cases,(total_cases/population)*100 as  PopulationPercentage
FROM projects..coviddeaths
WHERE location = 'United States'
ORDER BY 1,2

--Looking at the countries with highest infection rate compared to the population

SELECT location, population, max(total_cases) as HighestInfectionCountry, max(total_cases/population)*100 as PopulationPercentage
FROM projects..coviddeaths
GROUP BY location, population
ORDER BY PopulationPercentage DESC  

--Showing which countries have the highest death count per population

SELECT location, max(total_deaths) as TotalDeathCount
FROM projects..coviddeaths
WHERE continent is not null 
GROUP BY location
ORDER BY TotalDeathCount DESC  

--Let's break things down by continent 
--Showing continents with the highest death count

SELECT location, max(total_deaths) as TotalDeathCount
FROM projects..coviddeaths
WHERE continent is null 
GROUP BY location
ORDER BY TotalDeathCount DESC  

--Global numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM projects..coviddeaths
WHERE continent is not null 
ORDER BY 1,2

--Looking at total population vs vaccinations 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER 
(Partition by dea.location Order by dea.location, CONVERT(date, dea.date))
From projects..coviddeaths dea
Join projects..covidvaccinations vac
On dea.location = vac.location 
and dea.date = vac.date
Where dea.continent is not null
Order by 2, 3

--Using CTE to perfom a calculation on PARTITION BY in query above 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, CONVERT(date, dea.Date)) as RollingPeopleVaccinated
From projects..coviddeaths dea
Join projects..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Use temp table to perform calculation on Partition by in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, CONVERT(date, dea.Date)) as RollingPeopleVaccinated
From projects..coviddeaths dea
Join projects..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date



Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated