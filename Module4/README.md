# Модуль 4

### 4.4: ETL Компоненты и начало работы с ETL на примере Pentaho Data Integration
Создайте трансформации, чтобы получить такой же результат, как в модуле 2:
* [загрузите данные из Superstore Excel файла в staging](4.4/etl/staging.ktr)

![staging](4.4/screenshots/staging.png)  

* загрузить данные из staging-таблиц в dwh
    * [dim tables](4.4/etl/dwh_dim.ktr)
![dim tables](4.4/screenshots/dwh_dim.png)
  
    * [fact table](4.4/etl/fact_table.ktr)
![dim tables](4.4/screenshots/fact_table.png)
      
Создайте общее [задание](4.4/etl/stg_to_dwh.kjb) для выполнения всех трансформаций
![job](4.4/screenshots/job.png)

### 4.5: 34 ETL Подсистемы
В качестве практики вам необходимо выявить 8-10 подсистем в ETL Pentaho DI и написать небольшой [отчет](./4.5/subsystems.md), в котором вы приложите print screen компонента (ETL подсистемы) и напишите про его свойства.

