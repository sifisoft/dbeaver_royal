

describe  genCheapCaribbean_xls;

execute genCheapCaribbean_xls( trunc(sysdate)-1, trunc(sysdate))

execute genCheapCaribbean_xls( '30-AUG-15', '5-SEP-15')




select IN_HOTEL,HO_NAME, IN_INV_NUM,IN_VOUCHER,IN_ARRIVAL,nvl(UPPER(MN_LAST_N||'/'||MN_FIRST_N),' ') NAME,to_char(IN_A_TOTAL,'999999999.00') IN_A_TOTAL, in_sent, in_inv_date
 from rsmanames,rinvoice,rsopecharter, rshotel
 where mn_hotel = in_hotel
 and mn_reserv = in_reserv
 and in_hotel= ho_hotel
 and mn_sequence = 1
 and in_inv_num is not null
 and in_inv_num != '0000000'
 and in_inv_date between '30-aug-15' and '05-sep-15'
 --and in_inv_date > '05-sep-15'
 --and nvl(in_sent,'N') = 'N'
 and oc_charter = in_wholes
 and oc_operator = 'CHEAPAI'
  order by IN_HOTEL,IN_INV_NUM,IN_VOUCHER;



update rinvoice
set in_sent = 'N'
where in_inv_num is not null
    and in_inv_num != '0000000'
    and in_inv_date >= '30-aug-15'
    and in_sent is not null 
    --and nvl(in_sent,'N') = 'N'
    and exists (
        select 1
        from rsopecharter
        where oc_operator = 'CHEAPAI'
            and oc_charter = in_wholes
)


select sum(in_a_total)
 from rsmanames,rinvoice,rsopecharter, rshotel
 where mn_hotel = in_hotel
 and mn_reserv = in_reserv
 and in_hotel= ho_hotel
 and mn_sequence = 1
 and in_inv_num is not null
 and in_inv_num != '0000000'
 and in_inv_date between '30-jun-13' and '27-jul-13'
 and nvl(in_sent,'N') = 'N'
 and oc_charter = in_wholes
 and oc_operator = 'CHEAPAI'
 order by IN_HOTEL,IN_INV_NUM,IN_VOUCHER;



select *
from rinvoice
where in_inv_num = '1040312'


