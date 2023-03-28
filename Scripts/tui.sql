
desc gentui


execute gentui('21-FEB-14')


select * from kkkk


select *
from rinvoice
where in_wholes in (
select  oc_charter
from rsopecharter
where oc_charter in ('TUIKOC','TUIKAI','TNORAI')
) and in_inv_date = trunc(sysdate-1)


select *
from all_objects
where object_name like '%TUI%'


select *
from rinvoice
where in_inv_num = :invoice

select *
from rscharter
where ch_charter = 'TUIOC'

select *
from rsopecharter
where oc_chaRter = 'TNORSTD'



select * 
from rsoperator
where op_id in ('TUIKOC','TUIKAI','TNORAI')

select * from rsoperator where op_name like '%TUI%'


select * from kk3

select * from kk4

select * from travdates order by trav_date


pendinv_pckg

RepArrivalsInvoice