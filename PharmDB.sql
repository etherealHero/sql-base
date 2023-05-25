use master

if not exists (
	select name
	from sys.databases
	where name = N'PharmDB'
) create database [PharmDB]
go

use PharmDB

-- reinstall database
-- remove constraints

-- COMMENT ON FIRST EXECUTE 
if exists (select * from sysobjects 
  where name = 'drugstores' and xtype = 'U') 
    alter table drugstores drop constraint FK_drugstores_cities
if exists (select * from sysobjects 
  where name = 'cashdesk' and xtype = 'U') 
    alter table cashdesk drop constraint FK_cashdesk_drugstores
-- /COMMENT ON FIRST EXECUTE

-- drop tables
if exists (select * from sysobjects 
  where name = 'cities' and xtype = 'U') 
    drop table cities
if exists (select * from sysobjects 
  where name = 'drugstores' and xtype = 'U') 
    drop table drugstores
if exists (select * from sysobjects 
  where name = 'cashdesk' and xtype = 'U') 
    drop table cashdesk

-- initialization
create table cities (
  id int identity not null,
  name varchar(128) not null,
  primary key (id)
)

create table drugstores (
  id int identity not null,
  name varchar(128) not null,
  address varchar(128),
  city_id int not null
  primary key (id)
)

create table cashdesk (
  id int identity not null,
  number int not null,
  description varchar(128),
  drugstore_id int not null
  primary key (id)
)

truncate table cashdesk
truncate table cities
truncate table drugstores

alter table drugstores add constraint FK_drugstores_cities foreign key (city_id)
  references Cities (id)
  on delete cascade on update cascade

alter table cashdesk add constraint FK_cashdesk_drugstores foreign key (drugstore_id)
  references drugstores (id)
  on delete cascade on update cascade

insert cities (name) values
  ('Хабаровск'),
  ('Владивосток'),
  ('Благовещенск')

insert drugstores (name, address, city_id) values
  ('Аптека №1', 'ул. Карла Маркса, 1', 1),
  ('Аптека №2', 'ул. Ленина, 2', 1),
  ('Аптека №3', 'ул. Победы, 3', 1),
  ('Аптека №4', 'ул. Карла Маркса, 15', 1),
  ('Аптека №5', 'ул. Комсомольская, 5', 2),
  ('Аптека №6', 'ул. Большая, 6', 2),
  ('Аптека №7', 'ул. Ленина, 22', 3)

insert cashdesk (number, description, drugstore_id) values
  (1, 'касса 1', 1),
  (2, 'касса 2', 1),
  (3, 'рецептура 1', 1),
  (1, 'касса 1', 2),
  (2, 'касса 2', 2),
  (3, 'касса 3', 2),
  (1, 'рецептура 1', 3),
  (1, 'касса 1', 4),
  (2, 'касса 2', 4),
  (1, 'касса 1', 5),
  (2, 'касса 2', 5),
  (3, 'рецептура 1', 5),
  (4, 'рецептура 2', 5),
  (5, 'рецептура 3', 5),
  (1, 'касса 1', 6),
  (1, 'касса 1', 7),
  (2, 'касса 2', 7),
  (2, 'касса 1', 7),
  (3, 'касса 2', 7),
  (4, 'касса 1', 7),
  (5, 'касса 2', 7)

go
-- select

-- 7. Вывести список всех касс со следующем столбцами: [Аптека], [Адрес аптеки с городом],
-- [Номер кассы], [Описание кассы]
-- Предоставить select запрос и результат.
select
  drug.name as 'Аптека',
  (select cities.name from cities where cities.id = drug.city_id) + ', ' + drug.address as 'Адрес аптеки с городом',
  cash.number as 'Номер кассы',
  cash.[description] as 'Описание кассы'
from cashdesk as cash
  inner join drugstores as drug on drug.id = cash.drugstore_id

-- 8. Вывести список всех аптек, в которых более 3х касс, со столбцами [Аптека], [Город], [Адрес
-- аптеки]
-- Предоставить select запрос и результат.
-- select
--   drug.name as 'Аптека',
--   city.name as 'Город',
--   drug.address as 'Адрес аптеки'
--   -- count(cash.drugstore_id) as 'count'
-- from drugstores as drug
--   inner join cashdesk as cash on cash.drugstore_id = drug.id
--   inner join cities as city on city.id = drug.city_id
-- group by drug.name, drug.address, city.name
-- having count(cash.drugstore_id) > 3

-- 9. Вывести список всех аптек, расположенных по улице Карла Маркса, со столбцами [Аптека],
-- [Город], [Адрес аптеки], [Кол-во касс]
-- Предоставить select запрос и результат.
-- select 
--   drug.name as 'Аптека',
--   city.name as 'Город',
--   drug.address as 'Адрес аптеки',
--   count(cash.id) as 'Кол-во касс'
-- from drugstores as drug
--   inner join cities as city on city.id = drug.city_id
--   inner join cashdesk as cash on cash.drugstore_id = drug.id
-- where drug.address like 'ул. Карла Маркса%'
-- group by city.name, drug.address, drug.name
-- order by drug.name asc

-- 10. Вывести список всех аптек, в которых есть кассы с описанием «Рецептура», со столбцами
-- [Аптека], [Город], [Адрес аптеки], [Кол-во касс с рецептурой]
-- Предоставить select запрос и результат.
-- select 
--   drug.name as 'Аптека',
--   city.name as 'Город',
--   drug.address as 'Адрес',
--   count(cash.id) as 'Кол-во касс с рецептурой'
-- from drugstores as drug
--   inner join cities as city on city.id = drug.city_id
--   inner join cashdesk as cash on cash.drugstore_id = drug.id
-- where cash.[description] like 'рецептура %'
-- group by drug.name, city.name, drug.address

-- 11. Вывести список городов, в которых общее кол-во касс превышает 8, со столбцом [Город]
-- Предоставить select запрос и результат.
-- select 
--   city.name as 'Город'
--   -- count(cashdesk.id)
-- from cities as city
--   inner join drugstores on drugstores.city_id = city.id
--   inner join cashdesk on cashdesk.drugstore_id = drugstores.id
-- group by city.name
-- having count(cashdesk.id) > 8