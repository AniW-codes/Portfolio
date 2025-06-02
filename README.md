# Covid Project

## Objective
The goal of this project is to analyze the data trends during Covid in the period of 2020 and 2021.

Level: Beginner

**Tableau Analysis** : [Tableau Dashboard](https://public.tableau.com/views/CovidDashboard2020-2021_17440553745980/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


## Basic EDA

```sql
Select *
from CovidDeaths
where continent is not null

select location,date, total_cases,new_cases,total_deaths,population
from CovidDeaths
Order by 1,2
```


## Key Questions
1. **Day by day recorded cases in India**  

```sql

select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_v_TotalCases
from CovidDeaths
where location like '%India%'
Order by 1,2


```
2. **Total Cases v Population; Shows what % of population got covid in India on a daily basis**  

```sql
select location,date, population,total_cases, (total_cases/population)*100 as Cases_per_Pop
from CovidDeaths
where location like '%India%'
Order by 1,2


```



3. **Countries with highest infection rate compared to population**  
```sql

select location, population, Max(total_cases) as Highest_Infection, Max(total_cases/population)*100 as Cases_per_Pop
from CovidDeaths
where continent is not null
Group By location, population
Order By Cases_per_Pop DESC

```

4. **Countries with the highest death count per population**  
```sql
--Cast converts data type from one form to another

select location, Max(cast(total_deaths as int)) as Highest_deaths
from CovidDeaths
where continent is not null
Group By location
Order By Highest_deaths DESC


```

5. **Continents with the highest death count per population**  
```sql

select continent, Max(cast(total_deaths as int)) as Highest_deaths
from CovidDeaths
where continent is not null
Group By continent
Order By Highest_deaths DESC


```
6. **Daily status since 1 Jan 2020**  
```sql
Select date, 
		sum(New_cases)as New_Cases_Daily, 
		sum(cast(new_deaths as int)) as New_Deaths_Daily, 
		(sum(cast(new_deaths as int))/sum(new_cases))*100 as NewDeath_Per_Cases
from CovidDeaths
where continent is not null
Group By date
Order by 1,2


```
7. **Deaths per Cases**  
```sql

Select sum(New_cases)as New_Cases_Daily, 
		sum(cast(new_deaths as int)) as New_Deaths_Daily, 
		(sum(cast(new_deaths as int))/sum(new_cases))*100 as NewDeath_Per_Cases
from CovidDeaths
where continent is not null
Order by 1,2


```
8. **Total Population vs Vaccination**  

```sql
Select CovidDeaths.continent,CovidDeaths.location, 
		CovidDeaths.date, population , CovidVaccinations.new_vaccinations,
		SUM(cast(CovidVaccinations.new_vaccinations as int)) OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
--,(RollPeopleVaccination/Population)*100
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
Order by 2,3



--------------------------With CTE--------------------------------

With PopulationVSVaccination (Continent, Location, Date, Population, New_vaccs, RollPeopleVaccination)
as
(
Select CovidDeaths.continent,CovidDeaths.location,
         CovidDeaths.date, population ,
         CovidVaccinations.new_vaccinations,
         SUM(cast(CovidVaccinations.new_vaccinations as int))
                     OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
)

Select * , (RollPeopleVaccination/Population) * 100 as Percentage_Vaccinated_Pop
from PopulationVSVaccination



-------------------------Using TEMP Tables-------------------------------------

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
Select CovidDeaths.continent,
         CovidDeaths.location,
         CovidDeaths.date,
         population ,
         CovidVaccinations.new_vaccinations,
         SUM(cast(CovidVaccinations.new_vaccinations as int))
                     OVER (Partition By CovidDeaths.location Order by CovidDeaths.date,CovidDeaths.location) as RollPeopleVaccination
--,(RollPeopleVaccination/Population)*100
from CovidDeaths 
join CovidVaccinations
	on CovidDeaths.location = CovidVaccinations.location 
	and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
Order by 1,2 ASC

Select * , (RollingPeopleVaccinated/Population)*100 as VaccinationperPop
from #PercentagePopulationVaccinated


```
