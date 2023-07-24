-- With Segmentations below:

-- TOTAL
-- PLATINUM (>$50K)
-- GOLD ($25K - <$50K)
-- SILVER ($10K – <$25K)
-- CLIENTELING or CT ($3K - <$10K)
-- OTHERS (Spend threshold < $3K)

-- Write code to show: Total no. of clients, Total Sales, Total no. of transactions, Total items sold, Average transaction value, Unit per transaction, Transactions with more than 2 
-- items of each segmentation.




with segmentation_tab as
(select
	  `member account code`,
	  case
	  when sum(`sales amt`)/23360 > 50000 then 'platinum'
	  when sum(`sales amt`)/23360< 50000 and sum(`sales amt`)/23360> 25000 then 'gold'
	  when sum(`sales amt`)/23360< 25000 and sum(`sales amt`)/23360>10000 then 'silver'
	  when sum(`sales amt`)/23360< 10000 and sum(`sales amt`)/23360> 3000 then 'clienteling'
	  else 'others' end as segmentation
from test_assesment ta
group by `member account code` )

-- total full
select
	  'total' as segmentation,
	  count(distinct `member account code`) as total_no_of_clients,
	  round(sum(`sales amt`)/23360, 2) as total_sales,
	  count(distinct `invoice`) as total_no_of_transactions,
	  sum(`sales qty`) as total_items_sold,
	  round((sum(`sales amt`)/23360)/count(distinct `invoice`), 2) as average_transaction_value,
	  round(sum(`sales qty`)/ count(distinct `invoice`), 2) as unit_per_transaction,
	  (count(distinct `invoice`)- count(case when invoice not in (select invoice 
																  from test_assesment ta
																  group by invoice 
																  having sum(`sales qty`) >=2
								) then invoice end)) as transaction_more_2
from test_assesment ta

union 
-- total platinum
select
	  'platinum' as segmentation,
	  count(distinct `member account code`) as total_no_of_clients,
	  round(sum(`sales amt`)/23360, 2) as total_sales,
	  count(distinct `invoice`) as total_no_of_transactions,
	  sum(`sales qty`) as total_items_sold,
	  round((sum(`sales amt`)/23360)/count(distinct `invoice`), 2) as average_transaction_value,
	  round(sum(`sales qty`)/ count(distinct `invoice`), 2) as unit_per_transaction,
	  (count(distinct `invoice`)- count(case when invoice not in (select invoice 
																  from test_assesment ta
																  group by invoice 
																  having sum(`sales qty`) >=2
								) then invoice end)) as transaction_more_2
from test_assesment ta
where `member account code` in (select `member account code` from segmentation_tab where segmentation = 'platinum')

union 
-- total gold
select
	  'gold' as segmentation,
	  count(distinct `member account code`) as total_no_of_clients,
	  round(sum(`sales amt`)/23360, 2) as total_sales,
	  count(distinct `invoice`) as total_no_of_transactions,
	  sum(`sales qty`) as total_items_sold,
	  round((sum(`sales amt`)/23360)/count(distinct `invoice`), 2) as average_transaction_value,
	  round(sum(`sales qty`)/ count(distinct `invoice`), 2) as unit_per_transaction,
	  (count(distinct `invoice`)- count(case when invoice not in (select invoice 
																  from test_assesment ta
																  group by invoice 
																  having sum(`sales qty`) >=2
		                        ) then invoice end)) as transaction_more_2
from test_assesment ta
where `member account code` in (select `member account code` from segmentation_tab where segmentation = 'gold')

union 
-- total silver
select 
      'silver' as segmentation,
	  count(distinct `member account code`) as total_no_of_clients,
	  round(sum(`sales amt`)/23360, 2) as total_sales,
	  count(distinct `invoice`) as total_no_of_transactions,
	  sum(`sales qty`) as total_items_sold,
	  round((sum(`sales amt`)/23360)/count(distinct `invoice`), 2) as average_transaction_value,
	  round(sum(`sales qty`)/ count(distinct `invoice`), 2) as unit_per_transaction,
	  (count(distinct `invoice`)- count(case when invoice not in (select invoice 
																  from test_assesment ta
																  group by invoice 
																  having sum(`sales qty`) >=2
								) then invoice end)) as transaction_more_2
from test_assesment ta
where `member account code` in (select `member account code` from segmentation_tab where segmentation = 'silver')

union 
-- total clienteling
select 
	  'clienteling' as segmentation,
	  count(distinct `member account code`) as total_no_of_clients,
	  round(sum(`sales amt`)/23360, 2) as total_sales,
	  count(distinct `invoice`) as total_no_of_transactions,
	  sum(`sales qty`) as total_items_sold,
	  round((sum(`sales amt`)/23360)/count(distinct `invoice`), 2) as average_transaction_value,
	  round(sum(`sales qty`)/ count(distinct `invoice`), 2) as unit_per_transaction,
	  (count(distinct `invoice`)- count(case when invoice not in (select invoice 
																  from test_assesment ta
																  group by invoice 
																  having sum(`sales qty`) >=2
								) then invoice end)) as transaction_more_2
from test_assesment ta
where `member account code` in (select `member account code` from segmentation_tab where segmentation = 'clienteling')

union 
-- total others
select 
 	  'others' as segmentation,
	  count(distinct `member account code`) as total_no_of_clients,
	  round(sum(`sales amt`)/23360, 2) as total_sales,
	  count(distinct `invoice`) as total_no_of_transactions,
	  sum(`sales qty`) as total_items_sold,
	  round((sum(`sales amt`)/23360)/count(distinct `invoice`), 2) as average_transaction_value,
	  round(sum(`sales qty`)/ count(distinct `invoice`), 2) as unit_per_transaction,
	  (count(distinct `invoice`)- count(case when invoice not in (select invoice 
																  from test_assesment ta
																  group by invoice 
																  having sum(`sales qty`) >=2
								) then invoice end)) as transaction_more_2
from test_assesment ta
where `member account code` in (select `member account code` from segmentation_tab where segmentation = 'others')









