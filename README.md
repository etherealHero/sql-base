## requirements

- choco (windows package manager)
- windows 8.1 +

## installation

1. install MSSQL server & SQL Management studio

```console
choco install mssqlserver2014express
choco install mssqlservermanagementstudio2014express
```

2. create database

   - clone repository

   ```console
   git clone https://github.com/etherealHero/sql-base/tree/main
   ```

   - execute PharmDB.sql
   - **or** restore from backup (dist/PharmDB.bak)

3. create diagram in management studio
   1. open Object explorer
   2. right click Database Diagrams -> New Databse Diagram
   3. pick all tables and press Add

<div align="center">
<img src="./src/img/DB_diagram.png" height="auto" width="70%" alt="preview"  />
<p>Diagram result</p>
</div>

<div align="center">
<img src="./src/img/obj_tree.png" height="auto" width="40%" alt="preview"  />
<p>Object tree</p>
</div>
