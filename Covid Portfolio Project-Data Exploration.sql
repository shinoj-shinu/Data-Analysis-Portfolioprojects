*Covid Data Exploration

This project is all about to analsysis the Total deaths and total vacinated details all over the world.

Application used -MY SQL Workbench

Skills used -Basic sql queris, Joins,Agreegate Functions,CTE's, Temp Tables, Windows Functions,Creating Views, Converting Data Types

Basic SQL queris

--Created Database as 'MYPORTFOLIOPROJECT'

CREATE DATABASE MYPORTFOLIOPROJECT;

SHOW DATABASES;

USE MYPORTFOLIOPROJECT;

*Downloaded Data files from https://ourworldindata.org/ and Data's Imported in to MYSQL

SELECT * FROM
MYPORTFOLIOPROJECT.CovidDeaths;

SELECT * FROM
MYPORTFOLIOPROJECT.CovidDeaths
ORDER BY 3,4;

*Covid Vacination details

SELECT * FROM
MYPORTFOLIOPROJECT.Covidvaccinations
ORDER BY 3,4;

*Findout sepecific details

SELECT Location, Date ,total_cases, new_cases, total_deaths, population
FROM MYPORTFOLIOPROJECT.CovidDeaths
ORDER BY 1,2;

--Looking at Total cases vs Total Deaths

SELECT Location, Date ,total_cases, new_cases, total_deaths, population
FROM MYPORTFOLIOPROJECT.CovidDeaths
ORDER BY 1,2;

--Looking at Total cases vs Total Deaths in specific country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM MYPORTFOLIOPROJECT.CovidDeaths
Where location = 'states'
order by 1,2;

--Looking at Total cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM MYPORTFOLIOPROJECT.CovidDeaths
Where location = 'Africa'
order by 1,2;

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM MYPORTFOLIOPROJECT.CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;

-- Countries with Highest Death Count per Population

Select Location, MAX(total_deaths) as TotalDeathCount
FROM MYPORTFOLIOPROJECT.CovidDeaths
Group by Location, Population
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

Select date,SUM(new_cases) as total_cases, sum(new_deaths)as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM MYPORTFOLIOPROJECT.CovidDeaths
where continent is not null 
Group By date
order by 1,2;

-- Looking at Total populations vs Total Vaccinations

--Joins

select *
from MYPORTFOLIOPROJECT.CovidDeaths dea
join MYPORTFOLIOPROJECT.Covidvacimations vac
on dea.location =vac.location
and dea.date =vac.date;

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from MYPORTFOLIOPROJECT.CovidDeaths dea
join MYPORTFOLIOPROJECT.Covidvacimations vac
on dea.location =vac.location
and dea.date =vac.date
where dea.continent is not null	
ORDER BY 2,3;

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MYPORTFOLIOPROJECT.CovidDeaths dea
Join MYPORTFOLIOPROJECT.Covidvacimations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;







-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MYPORTFOLIOPROJECT.CovidDeaths dea
Join MYPORTFOLIOPROJECT.Covidvacimations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

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
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MYPORTFOLIOPROJECT.CovidDeaths dea
Join MYPORTFOLIOPROJECT.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MYPORTFOLIOPROJECT.CovidDeaths dea
Join MYPORTFOLIOPROJECT.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;

























