


select t.*, t.rowid
from rsoperator t
where op_id = 'GROUPS'


select t.*, t.rowid
from rsopecharter t
where oc_charter = :charter

select *
from rsoperator
where  exists ( 
    select 1
    from rsopecharter
    where oc_charter = :charter
        and op_id = oc_operator
        )
        
        
update rsoperator
set op_company = 50
where op_country = 'CA'     