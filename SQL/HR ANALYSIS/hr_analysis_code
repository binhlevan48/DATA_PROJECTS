-- Tổng số nhân viên 
select count(employee_code) from hr_data

-- Số nhân viên theo work_location

select work_location,
       count(employee_code) as no_emps
from hr_data
group by work_location 
order by no_emps desc

-- Số lượng nhân viên theo CB

select CB,
	count(employee_code) as no_emps
from hr_data hd 
group by CB 
order by no_emps asc

-- Số lượng nhân viên theo NG

select NG,
	count(employee_code) as no_emps
from hr_data hd 
group by NG 
order by no_emps desc

-- Số lượng nhân viên theo statement_type

select statement_type,
	count(employee_code) as no_emps
from hr_data hd
group by statement_type 
order by no_emps desc

-- Số lượng nhân viên theo PT

select PT,
	count(employee_code) as no_emps
from hr_data hd 
group by PT 
order by no_emps desc

-- số lượng nhân viên chấm dứt hđlđ

select statement_type,
	statement_name,
	count(employee_code) as no_emps
where statement_type like 'ZG%'
group by statement_name

-- Số lượng nhân viên tuyển mới

select statement_type,
	count(employee_code) as no_emps
from hr_data
where statement_type like 'ZA%'

-- Số lượng nhân sự theo thâm niên hiện tại

with nhom_thamnien as 

(select employee_code,
	   case 
	   when thamnien > 10 then '>10'
	   when thamnien > 5 and thamnien < 10 then '5-10'
	   when thamnien >3 and thamnien < 5 then '3-5'
	   when thamnien >1 and thamnien < 3 then '1-3'
	   else '<1'
	   end as nhom_thamnien
from (select employee_code,
	      round(datediff(day,employee_work_date, date(now()))/365, 2) as thamnien
      from hr_data
      where statement_type != 'ZG - Chấm dứt HĐLĐ') as thamnien
)
select nhom_thamnien,
	count(employee_code) as no_emps
from nhom_thamnien
group by nhom_thamnien
order by no_emps desc

-- Số lượng nhân viên chấm dứt hđlđ, tuyển mới hàng tháng năm 2019

select month(statement_valid_date) as Month2019,
       count(case when statement_type = 'ZG - Chấm dứt HĐLĐ' then employee_code end) as chamdut,
       count(case when statement_type = 'ZA - Tuyển mới' then employee_code end) as tuyenmoi
from hr_data
where year(statement_valid_date) = 2019
group by Month2019, statement_type
order by Month2019 asc

-- Số lượng nhân sự nghỉ việc theo thời gian làm việc

with thamnien_term as

(select employee_code,
	 case 
	 when thamnien > 10 then '>10'
	 when thamnien > 5 and thamnien < 10 then '5-10'
	 when thamnien >3 and thamnien < 5 then '3-5'
	 when thamnien >1 and thamnien < 3 then '1-3'
	 else '<1'
	 end as nhom_thamnien
from (select employee_code,
	      round(datediff(day,employee_work_date, date(now()))/365, 2) as thamnien
      from hr_data
      where statement_type = 'ZG - Chấm dứt HĐLĐ') as thamnien
)
select nhom_thamnien,
       count(employee_code) as no_emmps
from thamnien_term
group by nhom_thamnien
order by no_emps desc



