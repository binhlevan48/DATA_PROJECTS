-- Big project for SQL
-- Link instruction: https://docs.google.com/spreadsheets/d/1WnBJsZXj_4FDi2DyfLH1jkWtfTridO2icWbWCh7PLs8/edit#gid=0
-- In this project, we will write 08 query in Bigquery base on Google Analytics dataset.
-- Table Schema: https://support.google.com/analytics/answer/3437719?hl=en
-- Format Element: https://cloud.google.com/bigquery/docs/reference/standard-sql/format-elements



--Query 01: calculate total visit, pageview, transaction and revenue for Jan, Feb and March 2017 order by month
#standardSQL

SELECT 
      format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
      count(totals.visits) as visits,
      sum(totals.pageviews) as pageviews,
      sum(totals.transactions) as transactions,
      sum(totals.totaltransactionRevenue)/1000000 as revenue
     
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170101' and '20170331'
group by month
order by month;



-- Query 02: Bounce rate per traffic source in July 2017
#standardSQL
SELECT  
        trafficSource.source,
        sum( totals.visits) totals_visits,
        sum(totals.bounces) totals_bounces,
        (sum(totals.bounces)/sum(totals.visits)) as bounce_rate

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` 
where _table_suffix between '20170701' and'20170731'
group by trafficSource.source
order by sum(totals.visits) DESC;



-- Query 3: Revenue by traffic source by week, by month in June 2017
( SELECT 
      case when format_date("%Y%m", parse_date("%Y%m%d", date)) ='201706' then 'month'
      end as timetype,
      format_date("%Y%m", parse_date("%Y%m%d", date)) as time,
      trafficSource.source,
      sum(totals.totaltransactionRevenue)/1000000 as revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170601' and '20170631'
group by trafficSource.source, time, timetype)
union all
(SELECT
      case when format_date("%Y%W", parse_date("%Y%m%d", date)) <>'201706' then 'week'
      end as timetype,
      format_date("%Y%W", parse_date("%Y%m%d", date)) as time,
      trafficSource.source,
      sum(totals.totaltransactionRevenue)/1000000 as revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170601' and '20170631'
group by trafficSource.source, time, timetype)
order by revenue desc;

--Có thể đặt 'week' as time_type, nó sẽ tự tạo 1 cột là time_type, và gán gtri là week hoặc month
with month_data as(
SELECT
  "Month" as time_type,
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  trafficSource.source AS source,
  SUM(totals.totalTransactionRevenue)/1000000 AS revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
_TABLE_SUFFIX BETWEEN '20170601' AND '20170631'
GROUP BY 1,2,3
order by revenue DESC
),

week_data as(
SELECT
  "Week" as time_type,
  format_date("%Y%W", parse_date("%Y%m%d", date)) as date,
  trafficSource.source AS source,
  SUM(totals.totalTransactionRevenue)/1000000 AS revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
_TABLE_SUFFIX BETWEEN '20170601' AND '20170631'
GROUP BY 1,2,3
order by revenue DESC
)

select * from month_data
union all
select * from week_data


--Query 04: Average number of product pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017. Note: totals.transactions >=1 for purchaser and totals.transactions is null for non-purchaser
#standardSQL
with a as 
(SELECT 
      format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
      fullVisitorID,
      totals.pageviews,
      case 
      when totals.transactions >= 1 then 'purchaser'
      when totals.transactions is null then 'nonpurchaser'
      end as status,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170601' and '20170731')
select 
      a.month,
      a.status,
      sum(pageviews)/count(distinct fullVisitorId) as avg_pageviews,
from a
group by month, status;

--cách 2
with purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  group by month
)

select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
left join non_purchaser_data using(month)
order by pd.month


-- Query 05: Average number of transactions per user that made a purchase in July 2017
#standardSQL
SELECT 
       format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
       count(distinct fullVisitorId) as num_of_user,
       sum(totals.transactions) as num_of_transactions,
       sum(totals.transactions)/count(distinct fullVisitorID) as avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170701' and '20170731'
and totals.transactions is not null
group by month;



-- Query 06: Average amount of money spent per session
#standardSQL
SELECT 
      format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
      round(avg(totals.totaltransactionRevenue/totals.visits), 2) as avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170701' and '20170731'
      and totals.transactions is not null
group by month;



-- Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
#standardSQL
select v2ProductName as other_purchased_products,
       sum(productQuantity) as quantity
FROM  `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
      UNNEST (hits) hits,
      UNNEST (hits.product) product
where fullVisitorId in 
      (select distinct fullVisitorId,
       FROM
       `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
        UNNEST (hits) hits,
        UNNEST (hits.product) product
      where product.v2ProductName="YouTube Men's Vintage Henley"
        and productRevenue is not null
        and _table_suffix between '20170701' and '20170731')
and _table_suffix between '20170101' and '20170731'
and productRevenue is not null
and v2ProductName <> "YouTube Men's Vintage Henley"
group by v2ProductName
order by quantity desc;



--Query 08: Calculate cohort map from pageview to addtocart to purchase in last 3 month. For example, 100% pageview then 40% add_to_cart and 10% purchase.
#standardSQL

--đề bài này là, với mỗi sản phẩm, nó sẽ trải qua 3 giai đoạn, view -> add to card -> purchase, thì mình đang muốn tìm ra ở từng giai đoạn, số lượng items(sp) rớt xuống còn bao nhìu %

with
product_view as(
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  count(product.productSKU) as num_product_view
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
AND hits.eCommerceAction.action_type = '2'
GROUP BY 1
),

add_to_cart as(
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  count(product.productSKU) as num_addtocart
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
AND hits.eCommerceAction.action_type = '3'
GROUP BY 1
),

purchase as(
SELECT
  format_date("%Y%m", parse_date("%Y%m%d", date)) as month,
  count(product.productSKU) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
AND hits.eCommerceAction.action_type = '6'
group by 1
)

select
    pv.*,
    num_addtocart,
    num_purchase,
    round(num_addtocart*100/num_product_view,2) as add_to_cart_rate,
    round(num_purchase*100/num_product_view,2) as purchase_rate
from product_view pv
join add_to_cart a on pv.month = a.month
join purchase p on pv.month = p.month
order by pv.month


Cách 2: Có thể dùng count(case when) hoặc sum(case when)

with product_data as(
select
    format_date('%Y%m', parse_date('%Y%m%d',date)) as month,
    count(CASE WHEN eCommerceAction.action_type = '2' THEN product.v2ProductName END) as num_product_view,
    count(CASE WHEN eCommerceAction.action_type = '3' THEN product.v2ProductName END) as num_add_to_cart,
    count(CASE WHEN eCommerceAction.action_type = '6' THEN product.v2ProductName END) as num_purchase
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
,UNNEST(hits) as hits
,UNNEST (hits.product) as product
where _table_suffix between '20170101' and '20170331'
and eCommerceAction.action_type in ('2','3','6')
group by month
order by month
)

select
    *,
    round(num_add_to_cart/num_product_view * 100, 2) as add_to_cart_rate,
    round(num_purchase/num_product_view * 100, 2) as purchase_rate
from product_data

