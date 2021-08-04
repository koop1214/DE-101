-- ************************************** dw.dim_dates

INSERT INTO dw.dim_dates
  WITH dates AS (
      SELECT dd::date AS dt
        FROM GENERATE_SERIES
                 ('2016-01-01'::timestamp
                 , '2020-12-31'::timestamp
                 , '1 day'::interval) dd
  )
SELECT TO_CHAR(dt, 'YYYYMMDD')::int  AS id,
       dt                            AS date,
       DATE_PART('year', dt)::int    AS year,
       DATE_PART('quarter', dt)::int AS quarter,
       DATE_PART('month', dt)::int   AS month,
       DATE_PART('week', dt)::int    AS week,
       DATE_PART('isodow', dt)::int  AS week_day
  FROM dates
 ORDER BY dt;

-- ************************************** dw.dim_customers

INSERT INTO dw.dim_customers(code, name, segment)
SELECT DISTINCT customer_id AS code, customer_name AS name, segment
  FROM stg.orders
 ORDER BY customer_id;

-- ************************************** dw.dim_locations

-- City Burlington, Vermont doesn't have postal code
UPDATE stg.orders
   SET postal_code = '05401'
 WHERE city = 'Burlington'
   AND postal_code IS NULL;

INSERT INTO dw.dim_locations(postal_code, city, state, region, country)
SELECT DISTINCT postal_code, city, state, region, country
  FROM stg.orders
 ORDER BY postal_code;

-- ************************************** dw.dim_managers

INSERT INTO dw.dim_managers(name)
SELECT person
  FROM stg.people
 ORDER BY person;

-- ************************************** dw.dim_products

INSERT INTO dw.dim_products(code, name, sub_category, category)
SELECT DISTINCT product_id, product_name, subcategory, category
  FROM stg.orders
 ORDER BY product_id;

-- ************************************** dw.dim_ship_modes

INSERT INTO dw.dim_ship_modes(mode)
SELECT DISTINCT ship_mode
  FROM stg.orders
 ORDER BY ship_mode;

-- ************************************** dw.fact_sales

INSERT INTO dw.fact_sales(order_code, is_returned, order_date_id, ship_date_id, ship_mode_id, location_id, manager_id,
                          customer_id, product_id, quantity, sales, profit, discount)
SELECT o.order_id                             AS order_code,
       r.status IS NOT NULL                   AS is_returned,
       TO_CHAR(o.order_date, 'YYYYMMDD')::int AS order_date_id,
       TO_CHAR(o.ship_date, 'YYYYMMDD')::int  AS ship_date_id,
       s.id                                   AS ship_mode_id,
       l.id                                   AS location_id,
       m.id                                   AS manager_id,
       c.id                                   AS customer_id,
       p.id                                   AS product_id,
       o.quantity,
       o.sales,
       o.profit,
       o.discount
  FROM stg.orders o
           LEFT JOIN (SELECT DISTINCT * FROM stg.returns) r ON o.order_id = r.order_id
           JOIN dw.dim_ship_modes s ON o.ship_mode = s.mode
           JOIN dw.dim_locations l ON o.postal_code = l.postal_code AND o.city = l.city
           JOIN dw.dim_customers c ON o.customer_id = c.code
           JOIN dw.dim_products p ON o.product_id = p.code AND o.product_name = p.name
           JOIN stg.people pp ON o.region = pp.region
           JOIN dw.dim_managers m ON pp.person = m.name
 ORDER BY o.row_id;
