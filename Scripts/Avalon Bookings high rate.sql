

select ma_hotel, ma_reserv, ma_line, ma_charter, ma_room, ma_arrival, ma_depart, ma_nites, ma_adult, ma_due_tot, decode(ma_nites,0,-1, round(ma_due_tot/ma_nites,2)) RN
from rsmaes_avalon
where   ma_arrival >= trunc(sysdate) 
    and ma_mayorista = 'EUR'
    and decode(ma_nites,0,-1, ma_due_tot/ma_nites) > 88
    and exists (
        select 1
        from rshotel
        where ho_avalon = 'HT06' 
            and ho_hotel = ma_hotel
    )
order by ma_hotel, ma_charter, ma_room, ma_arrival