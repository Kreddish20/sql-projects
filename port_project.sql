select *
From portfolio_project.dbo.CovidDeaths$
order by 3,4
--select *
--From portfolio_project.dbo.CovidVaccinations$
--order by 3,4;


-- Select data to use

select location, date, total_cases, new_cases, total_deaths, population
From portfolio_project.dbo.CovidDeaths$
order by 1,2;


--Total cases / Total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPercentage
From portfolio_project.dbo.CovidDeaths$
where location like '%states%'
order by 1,2;

--total cases / population
select location, date, total_cases,population, (total_cases/population)*100 as casesPerCapita
From portfolio_project.dbo.CovidDeaths$
where location like '%states%'
order by 1,2;


select location, MAX(total_cases) as highest_cases, population, MAX((total_cases/population))*100 as MaxcasesPercapita
From portfolio_project.dbo.CovidDeaths$
--where location like '%states%'
group by location, population
order by MaxcasesPercapita desc;


select location, MAX(cast(total_deaths as int)) as highest_deaths
From portfolio_project.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
group by location, population
order by highest_deaths desc;

select location, MAX(cast(total_deaths as int)) as highest_deaths
From portfolio_project.dbo.CovidDeaths$
--where location like '%states%'
where continent is null
group by location
order by highest_deaths desc;


--Continents with highest death rate
select continent,MAX(cast(total_deaths as int)) as highest_deaths
From portfolio_project.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by highest_deaths desc;


select date, SUM(new_cases) as totalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercentage
From portfolio_project.dbo.CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2;


select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations as int)) OVER (Partition by cd.location Order by cd.location, cd.date) as rollingVacCount,
--(rollingVacCount/population)*100
from portfolio_project.dbo.CovidDeaths$ cd
join portfolio_project.dbo.CovidVaccinations$ cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
order by 2,3;


With PopvsVac (continent, location, date, population, new_vaccinations, rollingVacCount)
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations as int)) OVER (Partition by cd.location Order by cd.location, cd.date) as rollingVacCount
from portfolio_project.dbo.CovidDeaths$ cd
join portfolio_project.dbo.CovidVaccinations$ cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null
--order by 2,3
)
select *, (rollingVacCount/population)*100
from PopvsVac



--views

Create view percentpopulationVac as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(cast(cv.new_vaccinations as int)) OVER (Partition by cd.location Order by cd.location, cd.date) as rollingVacCount
from portfolio_project.dbo.CovidDeaths$ cd
join portfolio_project.dbo.CovidVaccinations$ cv
	on cd.location = cv.location
	and cd.date = cv.date
where cd.continent is not null


select *
from percentpopulationVac;