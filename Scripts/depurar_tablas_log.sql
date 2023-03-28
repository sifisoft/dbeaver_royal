
 -- RSRL
select *
from rsrlhead
where rh_arrival < '01-jan-11'

delete from rsrldet
where exists ( select 1 from rsrlhead where rd_hotel = rh_hotel and rd_number = rh_number and rh_arrival < '01-sep-12')


delete from rsrlname
where exists ( select 1 from rsrlhead where rn_hotel = rh_hotel and rn_number = rh_number and rh_arrival < '01-sep-12')


delete from rsrlhead 
where rh_arrival < '01-sep-12'

 -- CONHED LOG
delete from rsmaesmo_rf
where mm_date < '01-jan-11'
