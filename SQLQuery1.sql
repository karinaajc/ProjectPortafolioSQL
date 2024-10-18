SELECT * 
FROM PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
order by 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccines
--order by 3,4

-- SELECT DATA THAT WE ARE GOING TO BE USING

SELECT location, date, total_cases,new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- Shows the probablity of dying if you contract covid in Spain

SELECT LOCATION, DATE, TOTAL_CASES,TOTAL_DEATHS,(TOTAL_DEATHS/TOTAL_CASES) *100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where location like '%spain'
ORDER BY 1,2

-- LOOKING AT TOTAL CASES VS POPULATION
-- Shows what percentage of population got covid

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
order by 1,2

-- LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT LOCATION,population, max(TOTAL_CASES) as HighestInfectionCount,max(TOTAL_DEATHS/TOTAL_CASES) *100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group by location, population
ORDER BY PercentPopulationInfected desc

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT LOCATION, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
FROM  PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY LOCATION 
ORDER BY TOTALDEATHCOUNT DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT location, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
FROM  PortfolioProject..CovidDeaths
WHERE CONTINENT IS NULL
GROUP BY location 
ORDER BY TOTALDEATHCOUNT DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT (2º FORM)

SELECT CONTINENT, MAX(CAST(TOTAL_DEATHS AS INT)) AS TOTALDEATHCOUNT
FROM  PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
GROUP BY continent 
ORDER BY TOTALDEATHCOUNT DESC


-- GLOBAL NUMBERS

SELECT SUM(NEW_CASES) as total_cases, SUM(CAST(NEW_DEATHS AS int)) as total_deaths, 
SUM(CAST(NEW_DEATHS AS INT))/SUM(NEW_CASES)*100 AS DeathPercentage
from PortfolioProject..CovidDeaths
WHERE CONTINENT IS NOT NULL
--GROUP BY DATE
ORDER BY 1,2

-- Checking Vaccinations table
SELECT *
FROM PortfolioProject..CovidVaccines

-- Join both tables

SELECT *
FROM PortfolioProject.. CovidDeaths dea
JOIN PortfolioProject.. CovidVaccines vac
	ON dea.location = vac.location 
	and dea.date = vac.date

-- Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location order by
dea.location, dea.date) as NewVaccinationsByLocation, 
from PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccines vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3

-- Creating view to store data for later
Create view NewVaccinationsByLocation as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccines vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3



