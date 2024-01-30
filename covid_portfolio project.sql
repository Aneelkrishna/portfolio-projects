--SELECT *
--FROM portfolio..Covidvaccinations
--ORDER BY 3,4;

SELECT *
FROM portfolio..CovidDeaths
WHERE continent is NOT NULL and population is NOT NULL
ORDER BY 3,4;

-- select the data we are going to use
SELECT Location,date,total_cases,new_cases,total_deaths,population
FROM portfolio..CovidDeaths
WHERE continent is NOT NULL and population is NOT NULL
ORDER BY 1,2;

-- looking at total cases vs total deaths

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
FROM portfolio..CovidDeaths
WHERE Location like '%india%'
and continent is NOT NULL and population is NOT NULL
ORDER BY 1,2;

SELECT Location,date,total_cases,population,(total_cases/population)*100 as percentofpopulationinfected
FROM portfolio..CovidDeaths
--WHERE Location like '%india%'
WHERE continent is NOT NULL and population is NOT NULL
ORDER BY 1,2;

SELECT Location,population,MAX(total_cases) as Highestinfectioncount,MAX(total_cases/population)*100 as percentofpopulationinfected
FROM portfolio..CovidDeaths
--WHERE Location like '%india%'
WHERE continent is NOT NULL and population is NOT NULL
GROUP BY Location,population
ORDER BY percentofpopulationinfected DESC


SELECT Location,MAX(CAST(total_deaths AS INT)) as TotalDeathcount
FROM portfolio..CovidDeaths
--WHERE Location like '%india%'
WHERE continent is NOT NULL and population is NOT NULL
GROUP BY Location
ORDER BY TotalDeathcount DESC

SELECT continent,MAX(CAST(total_deaths AS INT)) as TotalDeathcount
FROM portfolio..CovidDeaths
--WHERE Location like '%india%'
WHERE continent is NOT NULL and population is NOT NULL
GROUP BY continent
ORDER BY TotalDeathcount DESC

SELECT Location,MAX(CAST(total_deaths AS INT)) as TotalDeathcount
FROM portfolio..CovidDeaths
--WHERE Location like '%india%'
WHERE continent is NULL and population is NOT NULL
GROUP BY Location
ORDER BY TotalDeathcount DESC

SELECT SUM(new_cases) as toalcases,SUM(CAST(new_deaths as INT)) as totaldeaths,(SUM(CAST(new_deaths as INT))/SUM(new_cases))*100 as Deathpercentage
FROM portfolio..CovidDeaths
--WHERE Location like '%india%'
WHERE continent is NOT NULL and population is NOT NULL
--GROUP BY date
ORDER BY 1,2

SELECT *
FROM portfolio..CovidDeaths dea
JOIN portfolio..Covidvaccinations vac
  ON dea.location =vac.location
  and dea.date = vac.date
where population is not null

--total population vs vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
FROM portfolio..CovidDeaths dea
JOIN portfolio..Covidvaccinations vac
  ON dea.location =vac.location
  and dea.date = vac.date
where dea.population is not null and dea.continent is NOT NULL
ORDER BY 2,3



--use CTE
with popvsvac (continent,location,date,population,new_vaccinations,peoplevaccinated)
as 
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
FROM portfolio..CovidDeaths dea
JOIN portfolio..Covidvaccinations vac
  ON dea.location =vac.location
  and dea.date = vac.date
where dea.population is not null and dea.continent is NOT NULL
--ORDER BY 2,3
)
SELECT * ,(peoplevaccinated/population)*100
FROM popvsvac


CREATE TABLE percentpeoplevaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
people_vaccinated numeric
)

INSERT INTO percentpeoplevaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
FROM portfolio..CovidDeaths dea
JOIN portfolio..Covidvaccinations vac
  ON dea.location =vac.location
  and dea.date = vac.date
where dea.population is not null and dea.continent is NOT NULL
--ORDER BY 2,3


SELECT * ,(people_vaccinated/population)*100
FROM percentpeoplevaccinated

--creating view to store data for later visualizations

create view percentpeoplevaccinte as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,dea.date) as peoplevaccinated
FROM portfolio..CovidDeaths dea
JOIN portfolio..Covidvaccinations vac
  ON dea.location =vac.location
  and dea.date = vac.date
where dea.population is not null and dea.continent is NOT NULL
--ORDER BY 2,3

select * 
from percentpeoplevaccinated