-- initialization
use master

if not exists (
	select name
	from sys.databases
	where name = N'test'
) create database [test]
go

use test

if exists (select * from sysobjects 
  where name = 'Notes' and xtype = 'U') 
    alter table Notes drop constraint FK_Notes_Users
if exists (select * from sysobjects 
  where name = 'Users' and xtype = 'U') 
    drop table Users
if exists (select * from sysobjects 
  where name = 'Notes' and xtype = 'U') 
    drop table Notes

create table Users (
  id bigint identity not null,
  name varchar(100)
  primary key (id)
)

create table Notes (
  id bigint identity not null primary key,
  title varchar(100),
  userId bigint
)

truncate table Users
truncate table Notes

alter table Notes add constraint FK_Notes_Users foreign key (userId) 
    references Users (id) 
    on delete cascade on update cascade

insert Users (name) values
  ('maxim'),
  ('andrew')

insert Notes (userId, title) values 
  (1, 'my first note'),
  (1, 'my second note')


select * from Users
select * from Notes