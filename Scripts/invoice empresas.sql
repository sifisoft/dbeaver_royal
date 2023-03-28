

invstat_pckg

inv_eVouchersByDepart_pckg

TravProduction



select t.*, t.rowid
from rsempresa_invoices t
order by ei_emp, ei_hotel



select * 
from rinvoice
where in_inv_num = '3006000001'


select in_empresa, count(*)
from rinvoice
where in_inv_date = trunc(sysdate)
group by in_empresa










insert into rsempresa_invoices
select :empDestino, ei_hotel, replace(ei_invoice_seq,30,:empDestino)
from rsempresa_invoices


DELETE FROM rsempresa_invoices
WHERE EI_EMP = 60 AND EI_INVOICE_SEQ NOT LIKE '60%'

select *
from rinvoice_eur
where in_arrival > sysdate-80
order by in_arrival desc

select * 
from rinvoice




select * from rinvoice_head
order by in_inv_date desc


select *
from rinvoice
where in_reserv = '690423'


select *
from rsmaes
where ma_reserv = '690423'


select *
from rinvoice
where in_empresa is not null

update rinvoice
set in_empresa = '60' 
where in_inv_num is not null and in_inv_date = trunc(sysdate)




select *
from rsoperator
where op_country != 'MX' and op_company is null