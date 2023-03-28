

-- Avalon booking
select ma_reserv, ma_line
from rsmaes_avalon
where ma_reserv = 'GOCRS220021443';

-- Buscar reserva en RSMAES con linea integrada
select *
from rsmaes
where ma_reserv = 'GOCRS220021443-1';

-- Draft booking
select *
from rinvoice
where in_reserv = 'GOCRS220021443-1'

