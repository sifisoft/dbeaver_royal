


desc rsmaes



update rsmaes
set ma_can_u = null,
    ma_can_d = null,
    ma_can_t = null,
    ma_can_c = null,
    ma_cancel = null
where ma_hotel = :hotel and ma_reserv = :reserv;    


select ma_hotel
from rsmaes
where ma_reserv = :reserv;
