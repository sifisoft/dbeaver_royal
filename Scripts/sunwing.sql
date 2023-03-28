
genSunwing


execute genSunwing('08-SEP-14')


PckgSunwing

select *
from rsgds_rate
where gds_source = 'SW'



select * 
from rsinvoice_hotels

select * from rshotel

        select     in_hotel
        from     rsinvoice_hotels
        where    nvl(in_generate_invoice,'N') = 'Y';




desc travInvoicing_sunwing  

execute TRAVINVOICING_SUNWING.generate

-- Fechas importantes
--      28-Ene   arrancamos facturaci�n total
--      12-Mar..   se envi� complemento con 1,965  reservas  ma_vip = 'R'



select * from rsgds_hotel


select * from rsmaes where ma_reserv = :reserv

select * from rsmanames where mn_reserv = :reserv


select * from rspaxes_ages




 select IN_HOTEL,IN_PACKAGE,IN_RESERV,nvl(UPPER(MN_LAST_N||'/'||MN_FIRST_N),' ') NOMBRE,nvl(IN_VOUCHER, IN_AGCY_CNF) in_voucher,
        to_char(IN_ARRIVAL,'MM/DD') IN_ARRIVAL,to_char(IN_DEPART,'MM/DD') IN_DEPART,IN_NITES,IN_ADULT,IN_CHILD,
        IN_A_ROOM,IN_A_COOP
 from rinvoice, rsmanames, rsopecharter
 where in_hotel = :xhotel
            and in_inv_num is not null
            and in_inv_date between :xstart and :xend
            and mn_hotel = in_hotel
            and mn_reserv = in_reserv
            and mn_sequence = 1
            and oc_charter = in_wholes
            and oc_operator = 'REDSEAI'
            and in_inv_num <> '0000000'
            and not exists ( select 1 from rsmaes where ma_hotel = in_hotel and ma_reserv = in_reserv and nvl(ma_vip,'X') = 'E')
order by IN_HOTEL,IN_INV_NUM,IN_VOUCHER;




select count(*) from rsmaes where ma_vip = 'Q'


update rinvoice 
set in_sent = 'Y'
where       in_inv_num is not null
            and in_inv_date between '22-apr-13' and '30-apr-13'
            and exists ( select 1 from rsopecharter where oc_charter = in_wholes and oc_operator = 'REDSEAI')
            and in_inv_num <> '0000000'
            and not exists ( select 1 from rsmaes where ma_hotel = in_hotel and ma_reserv = in_reserv and nvl(ma_vip,'X') = 'E')     


select * from rsavailable_sum_trg


select * from rsmaes where ma_voucher = '59766461';



select a.ma_hotel, a.ma_reserv, a.ma_arrival, a.ma_depart, a.ma_charter, a.ma_room, b.* 
from rsmaes2 a, rsmanames2 b
where ma_voucher = :sunwingConf 
    and ma_can_d is null
    and mn_hotel = ma_hotel
    and mn_reserv = ma_reserv
order by mn_reserv, mn_special    
;




desc rsconhed

select t.*, t.rowid 
 from rssunwing_ebb ;
 
 select * from rsmanames2;
 
 select ma_hotel, ma_reserv, ma_arrival, ma_depart, ma_room, ma_can_d, ma_adult, ma_infant
 from rsmaes2 where ma_voucher = :sunwingBooking;
 
 select *
 from rsmanames2
 where mn_reserv in ( select ma_reserv from rsmaes2 where ma_voucher = :sunwingBooking) 
 order by mn_reserv;
 