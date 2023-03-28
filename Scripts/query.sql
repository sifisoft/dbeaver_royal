select rownum,  ho_name, ho_tui,in_wholes, in_arrival, in_depart, in_reserv,  in_voucher, in_nites, guests, in_a_total, in_inv_num, mn_last_n, mn_first_n
from 
( 
select ho_name, ho_tui,in_wholes, in_arrival, in_depart, in_reserv, nvl(trim(in_voucher),in_agcy_cnf) in_voucher, in_nites, in_adult||'/'||in_child guests, in_a_total, in_inv_num, mn_last_n, mn_first_n
from rinvoice, rsmanames, rshotel
where       in_wholes in (select oc_charter from rsopecharter where oc_operator in ('TUIOC','FRTUIAI'))
          and ho_hotel = in_hotel
          and mn_hotel (+) = in_hotel
          and mn_reserv (+) = in_reserv
          and mn_sequence (+) = 1
          and in_hotel = :paramHotel
          and in_inv_num = :paramInvoice
order by ho_name, in_wholes, in_inv_num, in_arrival
)
