SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
  FROM [PortfolioProject].[dbo].[CovidDeaths]

  select *
  from PortfolioProject.dbo.CovidDeaths
  where continent is not Null
  order by 3,4

  --select *
  --from PortfolioProject.dbo.CovidVacinnation
  --order by 3,4

   select location, date, total_cases, new_cases, total_deaths, population
  from PortfolioProject.dbo.CovidDeaths
  order by 1,2

  --Looking at Total Cases and Total Deaths

  select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage 
  from PortfolioProject.dbo.CovidDeaths
  where location like '%ca%'
  order by 1,2
  
  --look at Total Cases vs Population

  select location,date, Total_cases, population, (cast(total_deaths as float)/cast(population as float))*100 as DeathPercentage 
  from PortfolioProject.dbo.CovidDeaths
  where location like '%ca%'
  order by 1,2

  --look at Countries with highest infection rate compared to population

   select location,date, population, max(Total_cases) as highestInfectionCount, (cast(total_cases as float)/cast(population as float))*100 as PercentagePopulationInfected
  from PortfolioProject.dbo.CovidDeaths
  group by population, location
  order by PercentagePopulationInfected desc

  --look at how many people deaths in the countries

select continent,max(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject.dbo.CovidDeaths
  where continent is not null
  group by continent
  order by TotalDeathCount desc

  --showing continents with the highest dealth count per population

  select continent,max(cast(total_deaths as int)) as TotalDeathCount
  from PortfolioProject.dbo.CovidDeaths
  where continent is not null
  group by continent
  order by TotalDeathCount desc

  --Global, numbers

   select date, sum(new_cases ), sum(cast(new_deaths as float)),sum(cast(new_deaths as Float))/sum(new_cases) *100 as DeathPercentage
  from PortfolioProject.dbo.CovidDeaths
  where continent is not null
  --group by date
  order by 1,2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--creating view to store data for later visualization

Create view PercentagePopulationVaccinated 
as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_Vacinnation
, SUM(CONVERT(int,vac.new_Vacinnation)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinnation
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3