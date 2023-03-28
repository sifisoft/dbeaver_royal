

create table rstrav_sud_codes 
(
trav_code       varchar2(12),
cun_code        varchar2(12)
)
tablespace hotel
storage (initial 1K next 1K)

select *
from rscharter
where ch_hotel= '01' and ch_charter in 
(
select trav_code 
from rstrav_sud_codes
where cun_code = 'MMTGAP'
)


select *
from rsoperator
where op_proforma = 'Y' and exists (select 1 from rsmaes, rsopecharter where ma_charter= oc_charter and oc_operator = op_id and ma_inp_d = '16-FEB-13') 






update rsmaes
set ma_reserv_nav = ma_charter,
     ma_oasis_rewards = 'W' 
where ma_can_d is null
    and ma_arrival >= '16-FEB-13'
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl = 'SUD' and ch_telex = 'CUN')
    
select ma_hotel, ma_reserv, ma_charter, ma_subchar, 
    (select unique ch_charter from rscharter, rstrav_sud_codes where cun_code = ma_charter and trav_code = ch_charter and ch_nav_room = ma_room)
from rsmaes    
where ma_can_d is null
    and ma_arrival >= '16-FEB-13'
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl = 'SUD' and ch_telex = 'CUN')
    

select count(*)
from rsmaes, rscharter, rstrav_sud_codes     
where ma_can_d is null
    and ma_arrival >= '16-FEB-13'
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl = 'SUD' and ch_telex = 'CUN')
    and  cun_code = ma_charter
    and ch_hotel = ma_hotel
    and ch_charter = trav_code  
    and ch_nav_room = ma_room
    and exists ( select 1 from rsconhed b  where b.ch_hotel = rscharter.ch_hotel and b.ch_charter = rscharter.ch_charter and ch_end_sea > sysdate) 
group by ma_hotel, ma_reserv, ma_charter, ma_subchar, ch_charter, ma_room
having count(*) > 1
order by ma_hotel, ma_reserv, ma_charter, ma_subchar, ch_charter



update rsmaes
set ma_charter = nvl(getSudCharter(ma_hotel, ma_charter, ma_room), ma_charter)
where ma_can_d is null
    and ma_arrival >= '16-FEB-13'
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl = 'SUD' and ch_telex = 'CUN')

-- Reservas sin conversion... 
select *
from rsmaes
where ma_can_d is null and ma_arrival >= '16-FEB-13'
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl = 'SUD')
    and exists ( select 1 from rstrav_sud_codes where cun_code = ma_charter)
order by ma_arrival

-- Reservas de operadores sin cuenta contable y que son agencias de Travamerica
select unique ma_hotel, ma_charter, ch_name, ch_acc_inv, ch_pri_inv
from rsmaes, rscharter
where ma_can_d is null and ma_arrival >= '16-FEB-13'
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_utl = 'SUD')
    and ch_hotel = ma_hotel
    and ch_charter = ma_charter
    and nvl(ch_telex,'X') != 'CUN'
    and (nvl(ch_pri_inv,'N') = 'N' or ch_acc_inv is null)
order by ma_hotel, ma_charter    


update rscharter
set ch_pri_inv = 'Y'
where ch_utl = 'SUD' 
    and nvl(ch_telex,'X') <> 'CUN' 
    and nvl(ch_pri_inv,'N') = 'N'
    and exists ( select 1 from rsmaes where ma_hotel = ch_hotel and ma_charter = ch_charter)
    




select ma_charter, ma_subchar
from rsmaes
where ma_oasis_rewards = 'W'

update rsmaes
set ma_charter = ma_subchar
where ma_oasis_rewards = 'W'

select *
from rsmaes
where ma_can_d is null
    and ma_arrival >= '16-FEB-13' 
    and exists ( select 1 from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter and ch_telex = 'CUN')
order by ma_arrival, ma_hotel    
     

select * from rsconhed

select ch_nav_room
from rscharter
where ch_hotel = '01' and ch_charter in ('FRWSTD','FRWSUN')    

    
update rscharter
set ch_telex = 'CUN'
where exists ( select 1 from rstrav_sud_codes where cun_code = ch_charter) 


-- Banderea RSMAES a reservas que se van a afectar.
update rsmaes
set ma_oasis_rewards = 'Z',
    ma_reserv_nav = ma_charter
where   ma_can_d is null 
    and ma_arrival between trunc(sysdate) and '15-feb-13'
    and exists ( select 1 from rstrav_sud_codes where trav_code = ma_charter)

-- Actualizael tipo de cuarto en ma_room 
update rsmaes
set ma_room = (select ch_nav_room from rscharter where ch_hotel = ma_hotel and ch_charter = ma_charter)
where ma_oasis_rewards = 'Z'
    and ma_room = 'ROH'
    and exists ( select 1 from rscharter where ma_hotel = ch_hotel and ma_charter = ch_charter and nvl(ch_nav_room,'ROH') <> 'ROH' )
    
select ho_hotel_cancun hotel_cancun, ma_reserv, ma_charter CUN_CODE, ma_reserv_nav TRAV_CODE, ma_room, ma_arrival, ma_depart
from rsmaes, rshotel
where ma_oasis_rewards = 'Z'
    and ma_hotel = ho_hotel 
order by ho_hotel_cancun    

update rsmaes
set ma_charter = (select cun_code from rstrav_sud_codes where trav_code = ma_charter group by cun_code)
where ma_oasis_rewards = 'Z'
    and exists ( select 1 from rstrav_sud_codes where trav_code = ma_charter )
   

select * from rstrans

insert into rstrans
select sysdate, ma_hotel, ma_reserv,'T','U','N',null,null
from rsmaes
where ma_oasis_rewards = 'Z'    
    

select * 
from rstrans
where tr_reserv = :reserv

select * from freserva_hoteles where rv_reserva = :reserv




/


update rsoperator
set inv_byarrival = 'Y'
where  exists ( select 1 from rsopecharter, rscharter where ch_charter = oc_charter and ch_utl = 'SUD' and op_id = oc_operator)

select * from rstrans


insert into rstrans
select sysdate, ma_hotel, ma_reserv, 'T','U','N',null,null
from rsmaes
where ma_oasis_rewards = 'W'




desc travInvoicing

desc travInvoicing_byDepart


update rsmaes
set ma_proforma = proforma_seq.nextval
where 

select to_char(sysdate,'ddmm') ||lpad(proforma_seq.nextval,4,'0') 
from dual;

alter sequence proforma_seq start with 1 

execute genProformaNumber('17-FEB-13')

select ma_hotel, ma_charter, ma_reserv, ma_arrival, ma_depart, ma_proforma
from rsmaes
where ma_proforma is not null 
