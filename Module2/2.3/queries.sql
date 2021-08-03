-- 1. Overview (обзор ключевых метрик):
-- Total Sales  - доход
-- Total Profit - прибыль
-- Profit Ratio - коэффициент прибыли %
-- Avg. Discount - средний размер скидки %

SELECT ROUND(SUM(sales))                     total_sales,
       ROUND(SUM(profit))                    total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100) profit_ratio,
       ROUND(AVG(discount) * 100)            avg_discount
  FROM stg.orders;

-- Sales per Customer - доход с покупателя
SELECT customer_id, SUM(sales) sum_sales
  FROM stg.orders
 GROUP BY customer_id
 ORDER BY SUM(sales) DESC;

-- Profit per Order - прибыль с заказа
SELECT order_id, SUM(profit) sum_profit
  FROM stg.orders
 GROUP BY order_id
 ORDER BY SUM(profit) DESC;

-- Monthly Sales by Segment - Помесячный доход в разрезе сегментов
SELECT DATE_TRUNC('month', order_date)::date year_month, segment, SUM(sales) sum_sales
  FROM stg.orders
 GROUP BY DATE_TRUNC('month', order_date)::date, segment
 ORDER BY DATE_TRUNC('month', order_date)::date, segment;

-- Monthly Sales by Product Category - Помесячный доход в разрезе категорий продуктов
SELECT DATE_TRUNC('month', order_date)::date year_month, category, SUM(sales) sum_sales
  FROM stg.orders
 GROUP BY DATE_TRUNC('month', order_date)::date, category
 ORDER BY DATE_TRUNC('month', order_date)::date, category;


--  2. Product Dashboard (Продуктовые метрики)
-- Sales by Product Category over time (Продажи по категориям)
SELECT order_date, category, SUM(sales) sum_sales
  FROM stg.orders
 GROUP BY order_date, category
 ORDER BY order_date, category;


--  3.  Customer Analysis
-- Sales and Profit by Customer  - доход и прибыль с покупателя
SELECT customer_name, SUM(sales) sum_sales, SUM(profit) sum_profit
  FROM stg.orders
 GROUP BY customer_name
 ORDER BY customer_name;

-- Customer Ranking - рейтинг покупателей по сумме покупок
SELECT RANK() OVER (ORDER BY SUM(sales) DESC), customer_name, SUM(sales) sum_sales
  FROM stg.orders
 GROUP BY customer_name
 ORDER BY SUM(sales) DESC;

-- Sales per region - продажи по регионам
SELECT region, SUM(sales) sum_sales
  FROM stg.orders
 GROUP BY region
 ORDER BY region;