

omnibees


/*  Catalogo de agencias OB */
select * 
from rsgdsoperator
where gds_code = 739;

alter table rsgdsoperator add gds_code_ai varchar2(8);


select * from fragen;

select * from kk;

delete from kk;



/* Conversion para Hotel */
select t.*, t.rowid 
from rsgds_hotel t
where gds_hotel = '4484';

/* Conversion para Tarifas y tipo de cuarto */
select *
from rsgds_rate
where gds_source = 'HBDEMXPQ';


    select b.GDS_SOURCE, b.GDS_HOTEL, b.GDS_ROOM, b.GDS_RATE, b.GDS_TRAV_ROOM, b.GDS_TRAV_RATE, b.GDS_TRAV_RATE_GDS, b.GDS_PROMOTAG,
           c.CH_PRI_INV,(decode(c.CH_MARKET,'SUD',b.gds_trav_rate,c.ch_market)) Subchar, (c.ch_market)  Mkt
    from rsgds_rate b , rscharter c
    where   b.gds_source = xSource
        and b.gds_hotel  = xHotel
        and b.gds_room   = xRoom
        and b.gds_rate   = xRate
        and ch_hotel  (+)= b.gds_hotel
        and ch_charter(+)= b.gds_trav_rate;





select *
from fragen
where ag_agencia = '12MX';


select t.*, t.rowid
from rsgds_hotel t
where gds_hotel = '4488';

select * from rsgds_hotel where gds_hotel in ('4480','4481','4484','4485','4488') and gds_source <> 'OB';

delete from rsgds_hotel where gds_hotel in ('4480','4481','4484','4485','4488') and gds_source <> 'OB';


select * from rsmaes where ma_charter like 'BEST%' and ma_inp_d = trunc(sysdate);

select * from rsmaes where  ma_inp_d = trunc(sysdate) and ma_inp_u = 'OMNIBEES'


select * from frpromoc where pc_desc like '%12MX%';

select * from frpromoa;


select t.*, t.rowid
from rsmaes t
where ma_reserv = '020062272';