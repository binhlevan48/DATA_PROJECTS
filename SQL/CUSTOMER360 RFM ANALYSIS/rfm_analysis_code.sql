with rfm_score as
(with rn_rfm as -- Tính row_number của từng chỉ số r,f,m
(select customerid,
	   datediff(date('2022-09-02'), max(purchase_date)) as recency,
	   row_number() over( order by datediff(date('2022-09-02'), max(purchase_date))) as rn_recency,
	   coalesce(round(count(purchase_date)/(datediff(date('2022-09-02'),max(created_date))/365), 2))
	   as frequency, -- Chia cho thời gian hợp đồng, tránh frequency lớn vì contract_age lớn
	   row_number() over( order by round(count(purchase_date)/(datediff(date('2022-09-02'),max(created_date))/365), 2)) as rn_frequency,
	   coalesce(round(sum(gmv)/(datediff(date('2022-09-02'),max(created_date))/365), 0))
	   as monetary, -- Tương tự, cũng chia cho contract_age
	   row_number() over( order by round(sum(gmv)/(datediff(date('2022-09-02'),max(created_date))/365), 0)) as rn_monetary
from customer_transaction ct
join customer_registered cr 
on ct.CustomerID = cr.ID 
where CustomerID <> '0' and stopdate is null
group by CustomerID)

select customerid,
       recency,
       frequency,
       monetary,
       -- Tính R_score
       case 
       when recency >= (select recency from rn_rfm where rn_recency = 1) and 
            recency < (select recency from rn_rfm where rn_recency = round((select count(customerid)*0.25 from rn_rfm),0)) then '4'     
       when recency >= (select recency from rn_rfm where rn_recency = round((select count(customerid)*0.25 from rn_rfm),0)) and
            recency < (select recency from rn_rfm where rn_recency = round((select count(customerid)*0.5 from rn_rfm),0)) then '3'
       when recency >= (select recency from rn_rfm where rn_recency = round((select count(customerid)*0.5 from rn_rfm),0)) and
            recency < (select recency from rn_rfm where rn_recency = round((select count(customerid)*0.75 from rn_rfm),0)) then '2'
       else '1'
       end as R,
       -- Tính F_score
       case
       when frequency >= (select frequency from rn_rfm where rn_frequency = 1) and
            frequency < (select frequency from rn_rfm where rn_frequency = round((select count(customerid)*0.25 from rn_rfm),0)) then '1'
       when frequency >= (select frequency from rn_rfm where rn_frequency = round((select count(customerid)*0.25 from rn_rfm),0)) and
            frequency < (select frequency from rn_rfm where rn_frequency = round((select count(customerid)*0.5 from rn_rfm),0)) then '2'
       when frequency >= (select frequency from rn_rfm where rn_frequency = round((select count(customerid)*0.5 from rn_rfm),0)) and
            frequency < (select frequency from rn_rfm where rn_frequency = round((select count(customerid)*0.75 from rn_rfm),0)) then '3'
       else '4'     
       end as F, 
       -- Tính M_score
       case
       when monetary >= (select monetary from rn_rfm where rn_monetary = 1) and 
            monetary < (select monetary from rn_rfm where rn_monetary = round((select count(customerid)*0.25 from rn_rfm),0)) then '1'
       when monetary >= (select monetary from rn_rfm where rn_monetary = round((select count(customerid)*0.25 from rn_rfm),0)) and
            monetary < (select monetary from rn_rfm where rn_monetary = round((select count(customerid)*0.5 from rn_rfm),0)) then '2'
       when monetary >= (select monetary from rn_rfm where rn_monetary = round((select count(customerid)*0.5 from rn_rfm),0)) and
            monetary < (select monetary from rn_rfm where rn_monetary = round((select count(customerid)*0.75 from rn_rfm),0)) then '3'
       else '4'
       end as M
from rn_rfm)

-- Tổng hợp tổ hợp RFM
select customerid,
       recency,
       frequency,
       monetary,
       concat(r,f,m) as rfm
from rfm_score
