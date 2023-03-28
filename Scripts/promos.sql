


select pa_hotel, pa_mayorista, pa_agencia, pa_grupo, pa_tipo_prom, pa_tabla, pa_tarifa, pa_fecha_apl, pa_fecha_aplf, pa_fecha_ini, pa_fecha_fin, pa_status, pa_individual, pa_doble 
from frpromoa
where pa_hotel = 2 and pa_agencia = 'MAGNI' AND '22-DEC-19' between pa_fecha_apl and pa_fecha_aplf and pa_tabla = 'ej' and pa_tarifa = 'GDLA'
order by pa_fecha_ini desc 

select * from frpromoa;


select *
from rshotel;


--pa_cap_f >= sysdate -35 and pa_tarifa = 'DSTD';


select *
from frpromoc
where pc_tabla = 'h1';



select *
from rsmaes
where ma_reserv = '120297906';


movBookings