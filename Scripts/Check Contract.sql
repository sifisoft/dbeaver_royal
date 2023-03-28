select *
from rshotel

select *
from fragen
where ag_agencia =  :ag

select *
from fragen
where ag_nombre like '%'||:agencia||'%'

select t.*, t.rowid
from frconmaes t
where cm_agencia = :agencia  and cm_activo = 'Y'  and cm_fecha_fin > trunc(sysdate) -- and cm_hotel = to_number(:hotel) --and cm_grupo = 'A'
order by cm_agencia, cm_fecha_ini

select t.*, t.rowid
from  frtarifcm t
where ch_agencia = :agencia and ch_grupo = 'A'   and ch_fecha_fin >= '18-FEB-13'
order by ch_agencia, ch_fecha_ini


select *
from rscondet
where cd_charter = :agencia and cd_end_sea > trunc(sysdate)

select *
from rsconhed
where ch_charter = :agencia

select *
from rsopecharter 
where oc_charter = :agencia

select t.*, t.rowid
from rsoperator t
where op_name like 'BEST %'
--where op_id = :agencia


select *
from rsmaes
where ma_reserv = '131363'





desc mentry

desc pckgCRSRates

desc crsmodify


