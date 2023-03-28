






select *
from rinvoice where in_reserv = :reserv;

select * from rsopecharter where oc_charter = 'TRHSPW3R';

select * from rsoperator where op_id = 'TRANHO';

create directory TRANSAT as '/logs/transat';

execute genTransatxls('18-aug-18','25-aug-18');

execute genTravelBrands_xls('18-aug-18','25-aug-18');



select ho_name in_hotel,
        in_reserv,
        in_wholes,
        ma_inp_d in_inp_date,
        in_arrival,
        in_depart,
        in_nites,
        in_adult,
        in_child,
        in_infant,
        in_a_total,
        in_inv_num,
        in_inv_date,
        in_voucher,
        nvl(UPPER(MN_LAST_N||'/'||MN_FIRST_N),' ') NAME,
        ho_hotel
 from rsmanames,rinvoice,rsopecharter, rshotel, rsmaes
 where mn_hotel = in_hotel
 and mn_reserv = in_reserv
 and mn_sequence = 1
 and in_inv_num is not null
 and in_inv_num != '0000000' and in_inv_num != '2065935'
 and in_inv_date between :xinidate and :xenddate
 and oc_charter = in_wholes
 and oc_operator = 'TRANHO'
 and ho_hotel = mn_hotel
 and ma_hotel = in_hotel
 and ma_reserv = in_reserv
 order by IN_HOTEL,IN_INV_NUM,IN_VOUCHER