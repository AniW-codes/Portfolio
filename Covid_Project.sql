Select *
from CovidDeaths
where continent is not null

select location,date, total_cases,new_cases,total_deaths,population
from CovidDeaths
Order by 1,2


select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_v_TotalCases
from CovidDeaths
where location like '%India%'
Order by 1,2


--Total Cases v Population; Shows what % of population got covid
select location,date, population,total_cases, (total_cases/population)*100 as Cases_per_Pop
from CovidDeaths
where location like '%India%'
Order by 1,2

select location,date, population,total_cases, (total_cases/population)*100 as Cases_per_Pop
from CovidDeaths
where location like '%States%'
Order by 1,2

--Countries with highest infection rate compared to population
select location, population, Max(total_cases) as Highest_Infection, Max(total_cases/population)*100 as Cases_per_Pop
from CovidDeaths
where continent is not null
Group By location, population
Order By Cases_per_Pop DESC

--Countries with the highest death count per population; 
--Cast converts data type from one form to another
select location, Max(cast(total_deaths as int)) as Highest_deaths
from CovidDeaths
where continent is not null
Group By location
Order By Highest_deaths DESC

--Continents with the highest death count per population; 
select continent, Max(cast(total_deaths as int)) as Highest_deaths
from CovidDeaths
where continent is not null
Group By continent
Order By Highest_deaths DESC

--Global Numbers
Select date, sum(New_cases)as New_Cases_Daily, sum(cast(new_deaths as int)) as New_Deaths_Daily, (sum(cast(new_deaths as int))/sum(new_cases))*100 as NewDeath_Per_Cases
from CovidDeaths
where continent is not null
Group By date
Order by 1,2

Select sum(New_cases)as New_Cases_Daily, sum(cast(new_deaths as int)) as New_Deaths_Daily, (sum(cast(new_deaths as int))/sum(new_cases))*100 as NewDeath_Per_Cases
from CovidDeaths
where continent is not null
Order by 1,2

------------------------

--Total Population vs Vaccination
Select CovidDeaths.continent,CovidDeaths.location, CovidDeaths.date, population , CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int)) OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
--,(RollPeopleVaccination/Population)*100
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
Order by 2,3



-- With CTE
With PopulationVSVaccination (Continent, Location, Date, Population, New_vaccs, RollPeopleVaccination)
as
(
Select CovidDeaths.continent,CovidDeaths.location, CovidDeaths.date, population , CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int)) OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
)

Select * , (RollPeopleVaccination/Population) * 100 as Percentage_Vaccinated_Pop
from PopulationVSVaccination


-------- Using TEMP Tables
DROP Table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent varchar(200),
Location varchar (200),
Date datetime,
Population numeric,
new_vaccinations int,
RollingPeopleVaccinated int
)

Insert into #PercentagePopulationVaccinated
Select CovidDeaths.continent,CovidDeaths.location, CovidDeaths.date, population , CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int)) OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
--,(RollPeopleVaccination/Population)*100
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
Order by 1,2 ASC

Select * , (RollingPeopleVaccinated/Population)*100 as VaccinationperPop
from #PercentagePopulationVaccinated


----Creating Views for Viz

Create View PercentagePopulationVaccinated as
Select CovidDeaths.continent,CovidDeaths.location, CovidDeaths.date, population , CovidVaccinations.new_vaccinations,
SUM(cast(CovidVaccinations.new_vaccinations as int)) OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
--,(RollPeopleVaccination/Population)*100
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null

Select *
from PercentagePopulationVaccinated
