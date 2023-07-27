select count(distinct(CustomerID)) as total_key , cast(Date as Date) as Date , 'BHD' as Service_Name

from Log_BHD_MovieID BHD

left join MV_PropertiesShowVN MV

on BHD.MovieID = MV.ID

where isDRM = 1

group by cast(Date as Date)

union

select count(distinct(CustomerID)) as total_key , cast(Date as Date) as Date , 'FIM+' as Service_Name

from Log_Fimplus_MovieID FIM

left join MV_PropertiesShowVN MV

on FIM.MovieID = MV.ID

where isDRM = 1

group by cast(Date as Date)

union

select count(distinct(L.CustomerID)) as total_key , L.Date , 'PHIM GOI' as Service_Name

from Log_Get_DRM_List L

left join Customers C on L.CustomerID = C.customerid and L.Mac = C.mac

left join CustomerService CS on L.CustomerID = CS.CustomerID

group by L.Date

order by Date desc
