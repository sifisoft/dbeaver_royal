
-- proforma number: mmddyynnnnnn       (nnnnnn = consecutivo) usamos el   700001 para proformas manuales

select t.ma_proforma, t.*, t.rowid from rsmaes t where ma_reserv = :reserv;
 


execute genProformaNumber(trunc(sysdate-1))

desc genProformaNumber


select t.*, t.rowid from rsmaes t where ma_proforma = :proforma

select t.*, t.rowid from rsmaes t where ma_proforma like '0703%'

select * -- ma_hotel, ma_charter, trunc(ma_inp_d) ma_inp_d
from rsmaes
where  ma_can_d is null
    and trunc(ma_inp_d) between :xInputDate-15 and :xInputDate
    and ma_inp_d >= '16-Feb-13'
    and ma_proforma is null
    and ma_due_tot > 50
    and exists ( 
            select 1 
            from rsoperator, rsopecharter 
            where  nvl(op_proforma,'N') = 'Y'
                and oc_operator = op_id
                and ma_charter = oc_charter
    ) 
--group by ma_hotel, ma_charter, trunc(ma_inp_d)    
order by ma_charter, ma_hotel;    


select  unique
    'java SendMail '  ||
    '"' || ltrim(rtrim(inv_email)) ||'" '||
    '" Invoice Attached :: TravAmerica Inc ::" '||
    '"<b>Dear Travel Partner,<br/><br/> Please find attached TravAmerica Invoice(s)<br/><br/> Thank you for your business.</b>" '||
    '"'||
    '/logs/vouchers/pdf/P'||ma_hotel||'_'||ma_proforma||'.pdf '
from rsmaes, rsopecharter, rsoperator
where   ma_proforma like to_char(sysdate-1,'ddmm')||'%'
     and ma_can_d is null
     and oc_charter = ma_charter 
     and op_id = oc_operator  
     and inv_email is not null



    
    

select  unique
    'java SendMail '  ||
    --'"' || ltrim(rtrim(inv_email)) ||'" '||
    '" logs@travamerica.com " '||
    '" Proforma '|| ma_proforma ||' Attached :: TravAmerica Inc :: Oasis Hotels :: Agency: '||ma_charter||' Input Date: '||to_char(sysdate-1,'dd/mm/yy')||' " '||
    '"<b>Dear Travel Partner,<br/><br/> Please find attached TravAmerica Proforma(s)<br/><br/> Thank you for your business.</b>" '||
    '"'||
    '/logs/vouchers/pdf/P'||ma_hotel||'_'||ma_proforma||'.pdf "'
from rsmaes, rsopecharter, rsoperator
where   ma_proforma like to_char(sysdate-1,'ddmm')||'%'
     and ma_can_d is null
     and oc_charter = ma_charter
     and op_id = oc_operator
     and inv_email is not null
     
     
update rsoperator
set inv_email = inv_email || ' cmitchell@travamerica.com   sandra@travamerica.com '
where op_proforma = 'Y' and inv_email is not null     

desc freserva@cun_oc

desc OasisInterface

select * from mares

alter table mares add mr_junior number(1)


select count(*)
from rstrans@cun_oc
where tr_done = 'N'


select *
from rsoperator
where op_name like '%PEL%'

select *
from rsoperator_back
where op_id like '%PELI%'

update rsoperator a
set op_name = ( select b.op_name from rsoperator_back b where b.op_id = a.op_id)
where exists ( select 1 from rsoperator_back b where b.op_id = a.op_id and b.op_name != a.op_name) 

desc oasisInterface

desc OasisInterfaceOC