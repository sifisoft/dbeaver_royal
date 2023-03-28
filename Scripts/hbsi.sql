
-- procedimiento almacenado
desc hbsi

desc isDIR

desc isExpedia 



select t.*, t.rowid from rsPublicRates t where pr_id = :rateNum

select t.*, t.rowid from rshbsi_sources t

select t.*, t.rowid from rsgds_hotel t where gds_source like 'EX%'

select * from rsgds_hotel where gds_tax_pct is not null;

select t.*, t.rowid
from rshbsi_sources t

select t.*, t.rowid
from rshotel_ages t
where ag_hotel = '02'


        select  
            pr_id,
            hbsi.getHbsiHotel(gds_source, pr_hotel),
            pr_room_type,
            case when pr_start < trunc(sysdate) then to_char(sysdate,'mm/dd/yyyy') else to_char(pr_start, 'mm/dd/yyyy') end,
            to_char(pr_end, 'mm/dd/yyyy'),
            pr_landpack,
            pr_desc,
            pr_single,
            pr_double,
            pr_triple,
            pr_quad,
            pr_xper,
            pr_disc_ch,
            pr_disc_in,
            pr_cutoff,
            pr_allotment,
            pr_inp_user,
            pr_inp_date,
            pr_mod_user
        from rsPublicRates a, rsgds_hotel
        where nvl(pr_interface_sent,'N') = 'N'
            and pr_end > trunc(sysdate)
            and pr_room_type is not null
            and gds_source in (select source from rshbsi_sources where status = 'A')
            and gds_trav_hotel = pr_hotel 
        order by pr_hotel, pr_room_type, pr_start, pr_end;















update rsPublicRates
set pr_interface_sent = null,
pr_interface_date = null
where pr_id in (38,232,235,238,592,241) and pr_hotel = '02'


update rspublicrates
--set pr_interface_sent = null, pr_interface_error = null
set pr_allotment = 999
where pr_hotel = '03' and pr_allotment is null 

update rspublicrates
set pr_interface_sent = 'Y'
where pr_hotel not in ('03') 




select *
from rshotel

select t.*, t.rowid 
from rsgds_rate t
where gds_source = 'EXPE'

select *
from rsconhed 
where ch_hotel = 99

select * 
from rscondet
where cd_hotel = 99

select t.*, t.rowid
from rshotel t

select t.*, t.rowid
from rscharter t
where ch_hotel = 99 and ch_charter like 'MLT%'


select t.*, t.rowid
from rsmaes t
where ma_source = 'ATI'

select t.*, t.rowid
from rsmanames t
where mn_hotel = '99'

select *
from rsmaes 
where ma_reserv = '990003'

genLibgo_xls

execute genOrbitz_xls('02-JAN-15')


execute genLibgoxls_trav_ca('02-JAN-15')

genCheapCaribbean_xls


select * from oo




select *
from rshotel
order by ho_hotel



select *
from travmarkets


select *
from freserva_hoteles
where rv_agencia in ('LSTHV') and rv_llegada >= '01-JAN-15'


        select  
            hbsi.getHbsiHotel('ATI', al_hotel) al_hotel,
            hbsi.getHbsiRoomRate('ATI', al_hotel, al_room, al_charter, 'ROOM') al_room,
            hbsi.getHbsiRoomRate('ATI', al_hotel, al_room, al_charter, 'RATE') al_rate,            
            a.al_date, 
            a.al_status, 
            a.al_allotment, 
            a.al_cutoff, 
            a.al_interface_sent, 
            a.al_interface_error, 
            a.al_interface_date
        from rsallotments a
        where al_interface_sent is null 
        and exists (
            select 1
            from rsgds_hotel
            where   gds_source = 'ATI'
                and gds_trav_hotel = al_hotel
                and al_interface_sent is null
        )
        and exists (
            select 1
            from rsgds_rate
            where   gds_source = 'ATI' 
                and gds_hotel = al_hotel
                and gds_trav_room = al_room
                and gds_trav_rate = al_charter
       )
        order by al_hotel, al_room, al_charter, al_date;


select * 
from rsallotments
where al_interface_sent is not null

update rsallotments
set al_interface_sent = null


select *
from ccmaes
where cc_emp = 80 and cc_plan = 'A' and cc_tipo = 7 and cc_saldo < 1 and cc_saldo > 0

select *
from diag
where dg_emp = 60 and dg_plan = 'A'  and dg_eje >= 14 and dg_per between 1 and 12 and dg_imp between 0 and 1 
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_cg
 

reserva_hoteles

DROP INDEX HOTEL.RSGDS_RATE_TRAV;

CREATE UNIQUE INDEX HOTEL.RSGDS_RATE_TRAV ON HOTEL.RSGDS_RATE
(GDS_SOURCE, GDS_HOTEL, GDS_TRAV_ROOM, GDS_TRAV_RATE)
NOLOGGING
TABLESPACE HOTEL_IND
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;




        select  
            pr_id,
            hbsi.getHbsiHotel(gds_source, pr_hotel),
            pr_room_type,
            to_char(pr_start, 'mm/dd/yyyy'),
            to_char(pr_end, 'mm/dd/yyyy'),
            pr_landpack,
            pr_desc,
            pr_single,
            pr_double,
            pr_triple,
            pr_quad,
            pr_xper,
            pr_disc_ch,
            pr_disc_in,
            pr_cutoff,
            pr_allotment,
            pr_inp_user,
            pr_inp_date,
            pr_mod_user
        from rsPublicRates a, rsgds_hotel
        where nvl(pr_interface_sent,'N') = 'N'
            and pr_end > trunc(sysdate)
            and gds_source in ('GOGO')
            and gds_trav_hotel = pr_hotel 
/*            and exists (
                select 1
                from rsgds_hotel
                where   gds_source in ('MLT')
                    and gds_trav_hotel = pr_hotel
            ) */
        order by pr_hotel, pr_room_type, pr_start, pr_end;



create table rshotel_ages
(
ag_hotel            varchar2(2),
ag_fromage          number,
ag_toage            number,
ag_ageQualifying    varchar2(1)
)
tablespace hotel


insert into rshotel_ages
values ('02',13,130,'A')


delete from kkk


select * from kkk


insert into rsgds_rate
(gds_source, gds_hotel, gds_room, gds_rate, gds_trav_room, gds_trav_rate)
values ('VAC', '02','GRST','VACEXPKG','ROH','VACEP0T')


