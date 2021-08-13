## Extracting System (#3)
Задача системы понять систему источник и уметь к ней подключиться, чтобы забирать данные.

В Pentaho DI существует множество шагов для извлечения данных, вот лишь несколько из них:

### [CSV file input](https://help.hitachivantara.com/Documentation/Pentaho/9.1/Products/CSV_File_Input)
![](https://files.mtstatic.com/site_7183/42852/0?Expires=1628778051&Signature=cYIsBov6uYGqFhtHTE4SvDPsYKGcpttbo-MZTqdJtGZQh56vMtBVXkxwvAs7pMJ9X2S~L2i7N1MfayZGzrzKJA9rIzljqGoMMWp4gCWjLu1KaMLQoqxXz7VVoO5-ojpzx5qfVdTpUlbA1qWchgsI~8YPHKWd5fVa96CYuWkUFIw_&Key-Pair-Id=APKAJ5Y6AV4GI7A555NA)

Читает данные из текстовых файлов с разделителями. Есть возможность указать параметры парсинга (разделитель, кодировка и т.д.). Есть автоопределение полей (Get fields), а также возможность ручного описания полей.

### [JSON input](https://help.hitachivantara.com/Documentation/Pentaho/9.1/Products/JSON_Input)
![](https://help.hitachivantara.com/@api/deki/files/42955/GUID-01C24F82-9F9F-4030-9983-2B830CBDC4EB-low.png?revision=1)

Извлекает данные из различных JSON-структур (файлы либо входящие данных из предыдущих шагов) и преобразует их в записи, используй JSONPath-выражения.

### [Table Input](https://help.hitachivantara.com/Documentation/Pentaho/9.1/Products/Table_Input)
![](https://help.hitachivantara.com/@api/deki/files/43169/GUID-48A91D8A-AEFC-43F6-A4F9-8EC66992CB3B-low.png?revision=1)

Читает информацию из различных баз данных при наличии соответствующего JDBC-драйвера. В запросах могут использоваться переменные, в том числе и из предыдущих шагов транформации.  
                             
## Error Event Handler (#5)
Задача системы отлавливать ошибки и принимать решения, что делать дальше, чтобы не сломать весь ETL процесс.

В Pentaho DI есть несколько шагов, позволяющих управлять потоком ошибок. Среди них валидация и фильтрация.

### [Data Validator](https://wiki.pentaho.com/display/EAI/Data+Validator)
![](https://wiki.pentaho.com/download/attachments/4358152/data-validator-error-handling.png?version=1&modificationDate=1220508119000&api=v2)

Валидирует входящие данные с помощью набора правил. Среди правил: граничные условия, регулярные выражения, белый список, проверка на null. В исходящие данные будет помещено поле с указанием описания ошибок.

## Deduplication System (#7)
Задача системы выявлять дубликаты записей и устранять их.

### [Unique Rows](https://help.hitachivantara.com/Documentation/Pentaho/9.1/Products/Using_the_Unique_Rows_step_on_the_Pentaho_engine)
![](https://help.hitachivantara.com/@api/deki/files/43214/GUID-F718112A-FA08-425A-925B-C23EB3900322-low.png?revision=1)

Удаляет дублирующиеся строки в отсортированных входных данных. Возможен поиск без учета регистра. Вместо удаления строк можно перенаправить дубли в поток ошибок.

## Surrogate Key Creation System (#10)
Задача системы генерить суррогатные ключи для наших натуральных ключей.

При первичной загрузке данных можно использовать шаг "Add Sequence".

### [Add Sequence](https://help.hitachivantara.com/Documentation/Pentaho/9.1/Products/Add_sequence)
![](https://help.hitachivantara.com/@api/deki/files/42789/GUID-28E71F68-C171-4DB5-A7F9-5A607B33A23D-low.png?revision=1)

Извлекает новое значение из последовательности. Можно использовать внутренний счетчик, указав начальное значение, максимальное значение и дельту, либо использовать последовательность из БД.

## Surrogate Key Pipeline (#14)
Задача системы использовать правильный суррогатный ключ при создании таблицы фактов.

### [Combination lookup-update](https://wiki.pentaho.com/display/EAI/Combination+lookup-update)
![](./screenshots/combination_lookup.png)

Помимо обновления измерений, может использоваться для поиска соответствующего суррогатного ключа по бизнес-ключу.

## Data Conformer (#8)
Задача системы согласовывать измерения и показатели из разных систем источников для использования их в отчетности.

### [Stream lookup](https://wiki.pentaho.com/display/EAI/Stream+Lookup)
![](https://wiki.pentaho.com/download/attachments/8292102/StreamLookupTableInputSample.PNG?version=1&modificationDate=1344422259000&api=v2)

Позволяет искать данные, используя информацию, полученную на других этапах трансформации. Данные, поступающие с шага-источника, сначала считываются в память, а затем используются для поиска данных из основного потока. Есть возможность указывать поля для извлечения.

## Late-Arriving Data Handler (#16)
Задача системы обрабатывать данные Dimemsion, которые появились позже. Обычно подходит для SCD 2-го типа.

### [Dimension lookup/update](https://wiki.pentaho.com/display/EAI/Dimension+Lookup-Update)
![](./screenshots/dimension_update.png)

Обновляет измерения c SCD 2-го типа, так же используется для поиска по этому измерению.
При обновлении можно указывать поля для версии, поля для диапазона дат актуальности.
     
## Sort System (#28)
Задача системы упорядочивать строки.

### [Sort rows](https://help.hitachivantara.com/Documentation/Pentaho/9.1/Products/Sort_rows)
![](https://help.hitachivantara.com/@api/deki/files/46982/GUID-5362BBA8-DE65-4C7A-91B9-D95CE198BAE5-low.png?revision=1)

Упорядочивает строки по значениям полей по возрастанию или убыванию. Также позволяет убрать дубли, оставив только первое вхождение.






