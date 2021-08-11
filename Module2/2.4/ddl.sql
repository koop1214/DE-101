-- *************** SqlDBM: PostgreSQL ****************;
-- ***************************************************;

CREATE SCHEMA IF NOT EXISTS dw;

DROP TABLE IF EXISTS dw.fact_sales CASCADE;
DROP TABLE IF EXISTS dw.dim_dates CASCADE;
DROP TABLE IF EXISTS dw.dim_customers CASCADE;
DROP TABLE IF EXISTS dw.dim_locations CASCADE;
DROP TABLE IF EXISTS dw.dim_managers CASCADE;
DROP TABLE IF EXISTS dw.dim_products CASCADE;
DROP TABLE IF EXISTS dw.dim_ship_modes CASCADE;

-- ************************************** dw.dim_dates

CREATE TABLE dw.dim_dates
(
    id       int      NOT NULL,
    date     date     NOT NULL,
    year     smallint NOT NULL,
    quarter  smallint NOT NULL,
    month    smallint NOT NULL,
    week     smallint NOT NULL,
    week_day smallint NOT NULL,
    CONSTRAINT pk_dim_dates PRIMARY KEY (id)
);


-- ************************************** dw.dim_customers

CREATE TABLE dw.dim_customers
(
    id      serial      NOT NULL,
    code    varchar(8)  NOT NULL,
    name    varchar(30) NOT NULL,
    segment varchar(20) NOT NULL,
    CONSTRAINT pk_dim_customers PRIMARY KEY (id)
);

-- ************************************** dw.dim_locations

CREATE TABLE dw.dim_locations
(
    id          serial      NOT NULL,
    postal_code varchar(5)  NOT NULL,
    city        varchar(20) NOT NULL,
    state       varchar(20) NOT NULL,
    region      varchar(10) NOT NULL,
    country     varchar(15) NOT NULL,
    CONSTRAINT pk_dim_locations PRIMARY KEY (id)
);

-- ************************************** dw.dim_managers

CREATE TABLE dw.dim_managers
(
    id   serial      NOT NULL,
    name varchar(20) NOT NULL,
    CONSTRAINT pk_dim_managers PRIMARY KEY (id)
);

-- ************************************** dw.dim_products

CREATE TABLE dw.dim_products
(
    id           serial       NOT NULL,
    code         varchar(15)  NOT NULL,
    name         varchar(128) NOT NULL,
    sub_category varchar(15)  NOT NULL,
    category     varchar(15)  NOT NULL,
    CONSTRAINT pk_dim_products PRIMARY KEY (id)
);

-- ************************************** dw.dim_ship_modes

CREATE TABLE dw.dim_ship_modes
(
    id   serial      NOT NULL,
    mode varchar(15) NOT NULL,
    CONSTRAINT pk_dim_ship_modes PRIMARY KEY (id)
);


-- ************************************** dw.fact_sales

CREATE TABLE dw.fact_sales
(
    id            serial        NOT NULL,
    order_code    varchar(14)   NOT NULL,
    is_returned   boolean       NOT NULL,
    order_date_id int           NOT NULL,
    ship_date_id  int           NOT NULL,
    ship_mode_id  int           NOT NULL,
    location_id   int           NOT NULL,
    manager_id    int           NOT NULL,
    customer_id   int           NOT NULL,
    product_id    int           NOT NULL,
    quantity      smallint      NOT NULL,
    sales         numeric(9, 4) NOT NULL,
    profit        numeric(9, 4) NOT NULL,
    discount      numeric(3, 2) NOT NULL,
    CONSTRAINT pk_sales_fact PRIMARY KEY (id),
    CONSTRAINT fact_sales_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES dw.dim_customers (id) ON DELETE CASCADE,
    CONSTRAINT fact_sales_location_id_fkey FOREIGN KEY (location_id) REFERENCES dw.dim_locations (id) ON DELETE CASCADE,
    CONSTRAINT fact_sales_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES dw.dim_managers (id) ON DELETE CASCADE,
    CONSTRAINT fact_sales_order_date_id_fkey FOREIGN KEY (order_date_id) REFERENCES dw.dim_dates (id) ON DELETE CASCADE,
    CONSTRAINT fact_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES dw.dim_products (id) ON DELETE CASCADE,
    CONSTRAINT fact_sales_ship_date_id_fkey FOREIGN KEY (ship_date_id) REFERENCES dw.dim_dates (id) ON DELETE CASCADE,
    CONSTRAINT fact_sales_ship_mode_id_fkey FOREIGN KEY (ship_mode_id) REFERENCES dw.dim_ship_modes (id) ON DELETE CASCADE
);

CREATE INDEX fact_sales_customer_id_index ON dw.fact_sales (customer_id);

CREATE INDEX fact_sales_location_id_index ON dw.fact_sales (location_id);

CREATE INDEX fact_sales_manager_id_index ON dw.fact_sales (manager_id);

CREATE INDEX fact_sales_order_date_id_index ON dw.fact_sales (order_date_id);

CREATE INDEX fact_sales_product_id_index ON dw.fact_sales (product_id);

CREATE INDEX fact_sales_ship_date_id_index ON dw.fact_sales (ship_date_id);

CREATE INDEX fact_sales_ship_mode_id_index ON dw.fact_sales (ship_mode_id);








