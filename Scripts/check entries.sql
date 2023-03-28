





-- CCMAES  X   ASI
select  t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 12 and cc_per = :per and cc_asi = :asi

-- CCMAES X INVOICE
select  t.*, t.rowid
from ccmaes t
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 12 and cc_factura = :invoice

-- DIAG X ASI
select t.*, t.rowid
from diag t
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 12 and dg_per = :per and dg_asi = :asi

-- ASTO X ASI
select t.*, t.rowid
from asto t
where as_emp = '60' and as_plan = 'A' and as_eje = 12 and as_per = :per and as_asi = :asi


-- INVOICE X ASI
select *
from rinvoice
where in_ejercicio = 12 and in_period = :per and in_ledger= :asi

-- CHARTER X CODIGO 
select *
from rscharter 
where ch_hotel = :hotel and ch_chaRter = :charter