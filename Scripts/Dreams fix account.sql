
delete from oo


select t.* , t.rowid
from oo t



update ccmaes
set cc_cuenta = (
    select c2
    from oo
    where c1 = cc_factura
)
where cc_emp = 80 and cc_tipo = 1 
and exists (
select 1 
from oo
where cc_factura = c1
)


select *
from diag
where dg_emp = 80 and dg_cg like '700%' and 
exists (
select 1
from oo
where dg_doc = c1
)


update diag
set dg_cg = (
    select c2
    from oo
    where c1 = dg_doc
),
    dg_cgcon = (
    select '430'||substr(c2,4)    
    from oo
    where c1 = dg_doc
    )
where dg_emp = 80
and dg_cg like '430%' 
and exists (
select 1
from oo
where dg_doc = c1
)
    


update diag
set dg_cg = (
    select '700'||substr(c2,4)
    from oo
    where c1 = dg_doc
),
    dg_cgcon = (
    select c2
    from oo
    where c1 = dg_doc
    )
where dg_emp = 80
and dg_cg like '700%' 
and exists (
select 1
from oo
where dg_doc = c1
)
    


select t.*, t.rowid
from rscitycodes t


select t.*, t.rowid
from rsallotments t


select *
from rsopecharter
where OC_OPERATOR = 'MLT1'




