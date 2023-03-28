


desc genExpedia_xls

execute genExpedia_xls(trunc(sysdate))

execute genExpedia_xls('28-NOV-17')

desc expedia




select in_reserv, in_inv_date, nvl(UPPER(MN_LAST_N||'/'||MN_FIRST_N),' ') NAME,IN_HOTEL,IN_INV_NUM,IN_VOUCHER,IN_DEPART,IN_NITES,to_char(IN_A_TOTAL,'999999999.00') IN_A_TOTAL,'0.00' TAX,ltrim(rtrim(to_char(IN_A_TOTAL,'999999999.00'))) TOTAL
from rsmanames,rinvoice,rsopecharter
where mn_hotel = in_hotel
 and mn_reserv = in_reserv
 and mn_sequence = 1
 and in_inv_num is not null
 and in_inv_num != '0000000' 
 and in_inv_date >= trunc(sysdate-1)
 and oc_charter = in_wholes
 and oc_operator = 'EXPIDIA'
 order by in_inv_date desc, IN_HOTEL,IN_INV_NUM,IN_VOUCHER;
 
 
 
 


select * 
from rinvoice, rsopecharter 
where in_hotel = '04' and in_inv_date = '24-jul-13' and in_inv_num <> '0000000' and in_wholes like 'EXP%' and oc_charter = in_wholes and oc_operator = 'EXPIDIA' 


select * from rshotel

select *
from rscondet
where cd_sent_date is not null

update rscondet
set cd_sent_date = null
where cd_sent_date is not null


select t.*, t.rowid 
from rsgds_hotel t
where gds_source = 'EX'


select t.*, t.rowid
from rsgds_rate t
where gds_source = 'EX'
AND GDS_HOTEL = '01'


-- Vieja tabla de conversion.
select * from rsroom_exp

select * from rsgds_rate where gds_source = 'EX' and  gds_rate = :RoomRate

desc expedia1


select * from rshotel


select * from mares

desc genExpedia_xls

desc Oasisinterface





select * from rshotel

select * 
from rinvoice
where in_hotel = '07' and in_wholes like 'EXP%' and in_inv_date >= '16-APR-13' and in_inv_num is not null and in_inv_num <> '0000000' and 
exists ( select 1 from rsopecharter where oc_charter = in_wholes and oc_operator = 'EXPIDIA')

 select nvl(UPPER(MN_LAST_N||'/'||MN_FIRST_N),' ') NAME,IN_HOTEL,IN_INV_NUM,IN_VOUCHER,IN_DEPART,IN_NITES,to_char(IN_A_TOTAL,'999999999.00') IN_A_TOTAL,'0.00' TAX,ltrim(rtrim(to_char(IN_A_TOTAL,'999999999.00'))) TOTAL
 from rsmanames,rinvoice,rsopecharter
 where mn_hotel = in_hotel
 and mn_reserv = in_reserv
 and mn_sequence = 1
 and in_inv_num is not null
 and in_inv_num != '0000000'
 --and in_inv_date = xdate
 --and in_inv_date between '09-jul-13' and trunc(sysdate-1)     -- comentar esta
 and in_inv_date > '24-JUL-13'          -- comentar esta linea
 and in_hotel in ('04')                -- comentar esta   
 and oc_charter = in_wholes
 and oc_operator = 'EXPIDIA'
 order by IN_HOTEL,IN_INV_NUM,IN_VOUCHER;
 
 
 
 select unique op_proforma from rsoperator
 
 
 
 select * from rsmaes
 
 desc rstrans_sens
 
 
 select t.*, t.rowid 
 from rsoperator t
 where op_rate_interface = 'Y'
 
 
 
 t