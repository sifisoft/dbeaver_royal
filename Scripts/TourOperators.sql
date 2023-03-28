
select * from rsmaes where ma_reserv = :reserv

select * from rsmanames where mn_reserv = :reserv

select ho_hotel, ho_accounting_code, ho_desc, t.rowid from rshotel t order by ho_hotel

select * from cuentas where ct_nivel =2 and ct_emp = '60' and ct_plan ='A' and ct_eje =13 and ct_cg like '430%' order by ct_cg

select * from rsoperator

select ch_acc_prod from rscharter

desc toInvoicing


select t.*, t.rowid
from rsoperator t
where inv_email like '%'||:email||'%'



select *
from rsoperator
where inv_email like '%;%'

select *
from rscountry


select op_company, co_desc, op_name, inv_method, inv_email
from rsoperator t, rscountry z
where nvl(op_country,'US') != 'MX'
    and co_country (+) = op_country
order by op_company, co_desc, op_name


select op_country, op_name, inv_method, inv_email, op_company, t.rowid
from rsoperator  t
where nvl(op_country,'US') != 'MX'
order by op_country, op_name




select * from rsoperator



update rsoperator
set op_account_base = (select unique substr(ch_acc_inv,6,9) from rscharter where ch_hotel = '01' and ltrim(ch_acc_inv) is not null and ch_charter in (select oc_charter from rsopecharter where oc_operator = op_id))
where op_account_base is null

drop table ooo    

create table ooo
as 
    select op_id operator, substr(ch_acc_inv,6,9) baseAccount 
    from rscharter, rsopecharter, rsoperator 
    where   ch_hotel = '12' and 
            ltrim(ch_acc_inv) is not null and 
            ch_charter  = oc_charter and 
            op_id = oc_operator and 
            op_account_base is null
    group  by op_id, substr(ch_acc_inv,6,9) 
    order by 1,2
            

    
    
select operator, count(*)
from ooo
group by operator
having count(*) > 1
order by 1    

delete from ooo
where operator in ('CICSOLWA','GROUPS','JAREISAI','ORIZOAI','SIGA','SNOWSTD','SOLWAYAR','VBARAI')

select * from ooo


update rsoperator
set op_account_base = (select baseaccount from ooo where op_id = operator)
where exists ( select 1 from ooo where op_id = operator)


select * 
from rsoperator
where op_account_base is not null

update rsoperator set op_account_base = null


desc rscharter


desc rsopecharter


select op_name Tour_Operator, op_id, inv_method, decode(inv_byarrival,'N','Departure','Arrival') generate_Invoice, ch_utl market, op_proforma proforma
from rsoperator, rscharter
where op_id = ch_charter and ch_utl not in ('MEX','USO','DIR')
group by op_id, op_name, inv_method, inv_byarrival, ch_utl, op_proforma
order by ch_utl, op_name


desc Invoices_statement_xls