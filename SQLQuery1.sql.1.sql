


select * from protfolio..
covidVacc 
where continent is not null

order by 3,4

--select data that we are going to choosing


select location ,date ,total_cases,new_cases,total_deaths,population

from protfolio.dbo.covidVacc order by 1,2

--looking at total cases vs total deaths

select location ,date ,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathper

from protfolio.dbo.covidVacc
where location like '%africa%'

order by 1,2

--look at total cases vs population

select location ,date ,total_cases,population,(total_cases/population)*100 as DeathPerc

from protfolio.dbo.covidVacc
where continent is not null

order by 1,2

--looking at countries 
select location  ,max(total_cases) as highInfection,max((total_deaths/total_cases))*100 
as PerpopAffected
from protfolio.dbo.covidVacc
where location like '%africa%'
group by location ,population
order by PerpopAffected

--how many people die 
select location  ,max(cast(total_deaths as int)) as totalDeaths
from protfolio.dbo.covidVacc
where continent is not null
group by location 
order by totalDeaths desc


--break down by continent
select continent  ,max(cast(total_deaths as int)) as totalDeaths
from protfolio.dbo.covidVacc
where continent is not null
group by continent
order by totalDeaths desc

--showing contients with the highest deaths 

select continent  ,max(cast(total_deaths as int)) as totalDeaths
from protfolio.dbo.covidVacc
where continent is not null
group by continent
order by totalDeaths desc

select * from protfolio..covidVacc

--global numbers

select sum(new_cases) as total_Cases , sum(cast(new_deaths as int)) as total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathper
from protfolio.dbo.covidVacc
where continent is not null
order by 1,2

--group by

select *
from protfolio..covidVacc dea
join protfolio..covidDeath vac
 on dea.location =vac.location
 and dea.date =vac.date

 -- total pop and vacc

 
with PopvsVac (continent,location,date,population,new_vaccanations,rollvac)
as 
(
select dea.continent, dea.location ,dea.date,dea.population ,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by
dea.location ,dea.date) as rollvac
--,(rollvac/population)*100
from protfolio..covidVacc dea
join protfolio..covidDeath vac

 on dea.location =vac.location
 and dea.date =vac.date

 where dea.continent is not null
--order by 2,3

)

select * ,
(rollvac/population)*100
from PopvsVac
--use cte











--tmp table
drop table if  exists percentPopulation
create table percentPopulation(continent varchar(225),
location varchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
rollvac numeric )


insert into percentPopulation
select dea.continent, dea.location ,dea.date,dea.population ,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by
dea.location ,dea.date) as rollvac
--,(rollvac/population)*100
from protfolio..covidVacc dea
join protfolio..covidDeath vac

 on dea.location =vac.location
 and dea.date =vac.date

 where dea.continent is not null
--order by 2,3


select *, (rollvac/population)*100
from percentPopulation

--creating view to store data 

create view  perpopulationvacc
as
select dea.continent, dea.location ,dea.date,dea.population ,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by
dea.location ,dea.date) as rollvac
--,(rollvac/population)*100
from protfolio..covidVacc dea
join protfolio..covidDeath vac

 on dea.location =vac.location
 and dea.date =vac.date

 where dea.continent is not null
--order by 2,3







