use PortfolioProject

select * from coviddeaths
order by 3,4

select * from coviddeaths
where continent is not null
order by 3,4


--select * from covidvaccination
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
where continent is not null
order by 1,2

--percentage of people got death
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deatpercentage
from coviddeaths
where location like '%states%'
and continent is not null
order by 1,2

--percentage of people got covid
select location,date,population,total_cases,(total_cases/population)*100 as covidpercentage
from coviddeaths
where location like '%states%'
order by 1,2

--infection rate
select location,population,max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as covidpercentage
from coviddeaths
--where location like '%states%'
group by location, population
order by covidpercentage desc

--countries with highest death count

select location,max(cast(total_deaths as int)) as totaldeathcounts from coviddeaths
--where location like '%states%'
where continent is not null
group by location 
order by totaldeathcounts desc

--by continent
select location,max(cast(total_deaths as int)) as totaldeathcounts from coviddeaths
--where location like '%states%'
where continent is null
group by location 
order by totaldeathcounts desc

-- continents with high death counts

select continent,max(cast(total_deaths as int)) as totaldeathcounts from coviddeaths
--where location like '%states%'
where continent is not null
group by continent 
order by totaldeathcounts desc

--global no's

select date,sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage--,total_deaths,(total_deaths/total_cases)*100 as deatpercentage
from coviddeaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

select sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage--,total_deaths,(total_deaths/total_cases)*100 as deatpercentage
from coviddeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

-- tot population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as cumltvpplvacc
--,(cumltvpplvacc/population)*100
from CovidDeaths dea join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE

with PopvsVac(Continent,location,date,population,new_vaccinations,cumltvpplvacc) 
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, 
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as cumltvpplvacc
--,(cumltvpplvacc/population)*100
from CovidDeaths dea join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(cumltvpplvacc/population)*100
from PopvsVac

---temp table

create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
cumltvpplvacc numeric)

insert into percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as cumltvpplvacc
--,(cumltvpplvacc/population)*100
from CovidDeaths dea join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select * ,(cumltvpplvacc/population)*100
from percentpopulationvaccinated

drop table percentpopulationvaccinated

--creating view to store data for vis

create view percentpeoplevaccinated as 
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.date) as cumltvpplvacc
--,(cumltvpplvacc/population)*100
from CovidDeaths dea join CovidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from percentpeoplevaccinated














































