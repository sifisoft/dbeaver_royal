

select unique cm_grupo
from frconmaes
where cm_fecha_fin > sysdate


select *
from mares
where mr_reserva = :booking

select *
from rsmaes
where ma_reserv = :reserv





select *
from fragen

select *
from rsoperator


select count(*)
from frpromoa


insert into rsoperator
(OP_ID, OP_NAME, OP_ADDRESS_1, OP_ADDRESS_2, OP_COUNTRY, OP_CITY, INV_FAX, INV_EMAIL, INV_METHOD, INV_BYARRIVAL,
         MARKTSEG_ID , OP_MARKET, OP_CONTRACT_CONTACT, OP_ISCATALOG, OP_PHONE, OP_FAX, OP_TAXID, OP_INV_CURRENCY,  OP_RES_CURRENCY,
         OP_RAZON_SOCIAL, OP_GUARANTEE)
select ag_agencia OP_ID, ag_nombre OP_NAME, ag_dir1 OP_ADDRESS_1, ag_dir2 OP_ADDRESS_2, ag_pais OP_COUNTRY, ag_codpos OP_CITY, ag_fax INV_FAX, ag_correo_factura_electronica INV_EMAIL, 'MAN' INV_METHOD,'Y' INV_BYARRIVAL,
         ag_mayorista MARKTSEG_ID , ag_mayorista OP_MARKET, ag_cont_admon OP_CONTRACT_CONTACT, 'Y' OP_ISCATALOG, ag_tel OP_PHONE, ag_fax OP_FAX, ag_rfc OP_TAXID, ag_moneda OP_INV_CURRENCY,  ag_moneda OP_RES_CURRENCY,
         ag_razon_soc OP_RAZON_SOCIAL, '99' OP_GUARANTEE           
from fragen t
where ag_mayorista not in ('AME','EUR','FIT','GAR') and exists ( select 1 from rsmaes  where ma_charter = ag_agencia and ma_depart > '01-jan-13' )  and not exists ( select 1 from rsoperator where op_id = ag_agencia)  
 and nvl(ag_dir1,'.') <> '7' and nvl(ag_tel,'.') <> '7'






insert into rscharter
(CH_HOTEL, CH_CHARTER, CH_NAME, CH_ADRESS_1, CH_ADRESS_2, CH_COUNTRY, CH_CITY,  CH_CONTACT, CH_TEL, CH_FAX,
  CH_ROTH, CH_GUARAN, CH_IVA, CH_TIP, CH_PRI_INV, CH_SALES, CH_UTL, CH_ALLINC, CH_MARKET)
select ho_hotel CH_HOTEL, ag_agencia CH_CHARTER, ag_nombre CH_NAME, nvl(ag_dir1,'.') CH_ADRESS_1, nvl(ag_dir2,'.') CH_ADRESS_2, ag_pais CH_COUNTRY, nvl(ag_codpos,'.') CH_CITY, nvl(ag_cont_admon,'.') CH_CONTACT, ag_tel CH_TEL, ag_fax CH_FAX,
         'Y' CH_ROTH, '0' CH_GUARAN, 'Y' CH_IVA, 'R' CH_TIP,  'N' CH_PRI_INV, ag_cont_ventas CH_SALES, ag_mayorista CH_UTL, 'Y' CH_ALLINC, decode(ag_mayorista,'SUD','SUD','MEX') CH_MARKET
from fragen, rshotel
where ag_mayorista not in ('AME','EUR','FIT','GAR') and exists (  select 1 from rsmaes  where ma_charter = ag_agencia and ma_depart > '01-jan-13' )  and not exists ( select 1 from rscharter where ch_charter = ag_agencia) and ag_agencia is not null
         and nvl(ag_dir1,'.') <> '7' and nvl(ag_tel,'.') <> '7' and ho_hotel not in ('99')





-- Se crea tabla de tarifas...
create table kk 
as 
select ch_mayorista, ch_agencia, ch_hotel, ch_anio, ch_revision, ch_grupo, ch_fecha_ini, ch_fecha_fin, ch_tarifa,  '01' CD_TYPE, ch_tarifa CD_ROOM, ch_sencilla CD_SINGLE, ch_doble CD_DOBLE, ch_triple CD_TRIPLE, ch_cuadruple CD_QUAD,
         ch_menor CD_ADITION, 0 CD_DES_CHI, nvl(ch_bebe,0)*100/decode(nvl(ch_menor,1),0,1,ch_menor) CD_DES_BAY, 0 CD_CUNA, 'OAS33' CD_MOD_USER, 'N' CD_ACTIVO, ' ' cd_hotel, 'USD' cd_moneda
from  frtarifcm a
where ch_fecha_fin >= '28-dec-12'
          and ch_mayorista not in ('AME','EUR','FIT','GAR')
          and ch_grupo = 'A'
order by 2,1          
                    

-- Se actualizan los que estan activos
update kk 
set cd_activo = 'Y'
where exists ( 
                select 1 
                from frconmaes
                where cm_mayorista = ch_mayorista
                    and cm_agencia = ch_agencia
                    and cm_hotel = ch_hotel 
                    and cm_anio = ch_anio
                    and cm_revision = ch_revision
                    and cm_grupo = ch_grupo
                    and cm_fecha_ini <= ch_fecha_ini
                    and cm_fecha_fin >= ch_fecha_ini
                    and cm_fecha_ini <= ch_fecha_fin
                    and cm_fecha_fin >= ch_fecha_fin
                    and cm_activo = 'Y'
         ) 

-- Se actualiza la moneda
update kk 
set cd_moneda = 'USD'
where cd_activo = 'Y' 
and exists
( 
                select 1 
                from frconmaes
                where cm_mayorista = ch_mayorista
                    and cm_agencia = ch_agencia
                    and cm_hotel = ch_hotel 
                    and cm_anio = ch_anio
                    and cm_revision = ch_revision
                    and cm_grupo = ch_grupo
                    and cm_activo = 'Y'
                    and cm_fecha_ini <= ch_fecha_ini
                    and cm_fecha_fin >= ch_fecha_ini
                    and cm_fecha_ini <= ch_fecha_fin
                    and cm_fecha_fin >= ch_fecha_fin
                    and cm_moneda = 'USD'
 ) 
 

update kk 
set cd_moneda = 'MEX'
where cd_activo = 'Y' 
and exists
( 
                select 1 
                from frconmaes
                where cm_mayorista = ch_mayorista
                    and cm_agencia = ch_agencia
                    and cm_hotel = ch_hotel 
                    and cm_anio = ch_anio
                    and cm_revision = ch_revision
                    and cm_grupo = ch_grupo
                    and cm_activo = 'Y'
                    and cm_fecha_ini <= ch_fecha_ini
                    and cm_fecha_fin >= ch_fecha_ini
                    and cm_fecha_ini <= ch_fecha_fin
                    and cm_fecha_fin >= ch_fecha_fin
                    and cm_moneda = 'MEX'
 ) 
 
 




-- Se actualiza el hotel travamerica
update kk
set cd_hotel = (select ho_hotel from rshotel where to_number(ho_hotel_cancun) = to_number(ch_hotel))


alter table kk modify cd_hotel varchar2(2)

-- se insertan los registros en RSCONDET
INSERT INTO RSCONDET
(CD_HOTEL, CD_CHARTER, CD_TYPE, CD_END_SEA, CD_ROOM, CD_SINGLE, CD_DOBLE, CD_TRIPLE, CD_QUAD, CD_ADITION, CD_DES_CHI, CD_DES_BAY, CD_CUNA, CD_MOD_USER, CD_MOD_DATE)
select cd_hotel CD_HOTEL, ch_agencia CD_CHARTER, '01' CD_TYPE, ch_fecha_fin CD_END_SEA, CD_ROOM, CD_SINGLE, CD_DOBLE, CD_TRIPLE, CD_QUAD, CD_ADITION, CD_DES_CHI, CD_DES_BAY, CD_CUNA, CD_MOD_USER, trunc(sysdate) CD_MOD_DATE
from kk
where cd_activo = 'Y'

insert into rsconhed
(CH_HOTEL, CH_CHARTER, CH_TYPE, CH_END_SEA, CH_STA_SEA, CH_DESC, CH_ACTIV, CH_DIVISA)
select cd_hotel CH_HOTEL, ch_agencia CH_CHARTER, '01' CH_TYPE, ch_fecha_fin CH_END_SEA, ch_fecha_ini CH_STA_SEA, 'TRASPASO' CH_DESC, 'Y' CH_ACTIV, cd_moneda CH_DIVISA
from kk
where cd_activo = 'Y' and not exists ( select 1 from rsconhed where ch_hotel = cd_hotel and ch_charter = ch_agencia and ch_type = '01' and ch_end_sea = ch_fecha_fin and ch_sta_sea = ch_fecha_ini)
group by cd_hotel, ch_agencia, ch_fecha_fin, ch_fecha_ini, cd_moneda



SELECT cd_hotel, cd_charter, cd_type, ch_sta_sea, ch_end_sea, cd_room, cd_single, cd_doble, cd_triple, cd_quad, cd_adition, cd_des_chi, cd_des_bay, ch_divisa
FROM RSCONDET, RSCONHED
WHERE CD_MOD_USER = 'OAS33' 
    and  ch_hotel = cd_hotel
    and ch_charter = cd_charter
    and ch_type = cd_type
    and ch_end_sea = cd_end_sea 
ORDER BY CD_CHARTER, CD_HOTEL


--- Se revisan e insertan duplicados... 
select ch_hotel CD_HOTEL, ch_agencia CD_CHARTER, '01' CD_TYPE, ch_fecha_fin CD_END_SEA, CD_ROOM, count(*)
from kk
where cd_activo = 'Y'
group by ch_hotel, ch_agencia, '01', ch_fecha_fin, cd_room
having count(*) > 1
order by 2,1

select t.*, t.rowid
from kk t
where ch_hotel = :hotel and ch_agencia = :agencia and cd_activo = 'Y'  
order by ch_fecha_ini, cd_room

select *
from frconmaes
where cm_agencia = :agencia and cm_hotel = :hotel and cm_grupo = 'A'
order by cm_fecha_ini





select * from kk


select *
from rshotel





select *
from kk
where cd_activo = 'N'





select ho_hotel CD_HOTEL, cm_agencia CD_CHARTER, '01' CD_TYPE, cm_fecha_fin CD_END_SEA, ch_tarifa CD_ROOM, ch_sencilla CD_SINGLE, ch_doble CD_DOBLE, ch_triple CD_TRIPLE, ch_cuadruple CD_QUAD,
         ch_menor CD_ADITION, 0 CD_DES_CHI, nvl(ch_bebe,0)*100/decode(nvl(ch_menor,1),0,1,ch_menor) CD_DES_BAY, 0 CD_CUNA
from  frtarifcm, frconmaes a, rshotel
where       cm_fecha_fin >= '01-dec-12'
          and to_number(ho_hotel_cancun) = to_number(cm_hotel)
          and cm_activo = 'Y'
          and cm_grupo = 'A'
          and cm_mayorista not in ('AME','EUR','FIT','GAR')
          and cm_revision = (select max(b.cm_revision) from frconmaes b where a.cm_mayorista = b.cm_mayorista and a.cm_agencia = b.cm_agencia and a.cm_hotel = b.cm_hotel and a.cm_fecha_ini = b.cm_fecha_ini and a.cm_fecha_fin = b.cm_fecha_fin and b.cm_activo = 'Y')
          and ch_mayorista = cm_mayorista
          and ch_agencia = cm_agencia
          and ch_hotel = cm_hotel
          and ch_anio = cm_anio
          and ch_revision = cm_revision
          and ch_grupo = cm_grupo
order by 2,1



select *
from kk
where ch_agencia = 'MAGNI'

select * 
from frtarifcm
where ch_agencia = 'MAGNI' and ch_hotel = 1 and ch_grupo = 'A'
order by ch_tarifa, ch_fecha_ini


select *
from frconmaes
where cm_agencia = 'MAGNI' and cm_hotel = 1 and cm_grupo = 'A'


select * 
from rsconhed
where ch_charter = 'MAGNI' AND CH_HOTEL = '01'







select ho_hotel CH_HOTEL, cm_agencia CH_CHARTER,  cm_fecha_fin CH_END_SEA, cm_fecha_ini CH_STA_SEA
from frconmaes a, rshotel
where cm_fecha_fin >= '01-dec-12'
          and to_number(ho_hotel_cancun) = to_number(cm_hotel)
          and cm_activo = 'Y'
          and cm_grupo = 'A'
          and cm_mayorista not in ('AME','EUR','FIT','GAR')
          and cm_revision = (select max(b.cm_revision) from frconmaes b where a.cm_mayorista = b.cm_mayorista and a.cm_agencia = b.cm_agencia and a.cm_hotel = b.cm_hotel and a.cm_fecha_ini = b.cm_fecha_ini and a.cm_fecha_fin = b.cm_fecha_fin and b.cm_activo = 'Y')
          and exists ( select 1 from rsconhed where ch_hotel = ho_hotel and ch_charter = cm_agencia and ch_sta_sea = cm_fecha_ini and ch_end_sea = cm_fecha_fin )
          








desc rsconhed


select *
from cat
where table_name like 'RSCONH%'









DROP INDEX HOTEL.IND_UNQ_RSCONDET;

CREATE UNIQUE INDEX HOTEL.IND_UNQ_RSCONDET ON HOTEL.RSCONDET
(CD_HOTEL, CD_CHARTER, CD_TYPE, CD_ROOM, CD_END_SEA)
NOLOGGING
TABLESPACE HOTEL_IND
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          4120K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DESC PCKGCRSRATES


select ch_charter,ch_desc, ch_sta_sea, ch_end_sea, ch_type, cd_room
  from rsconhed, rscondet, rsopecharter
where   ch_hotel  = :xhotel and
    ch_charter = oc_charter and
    oc_operator = :xoperator and
    :xarrival between ch_sta_sea and ch_end_sea and
    cd_hotel = ch_hotel and 
    cd_charter = ch_charter and 
    cd_type = ch_type and 
    cd_end_sea = ch_end_sea
 order by ch_type;
 
 
 
 
 desc mentry
 
 desc pckgCRSRates
 
 select *
 from rsroom
 
 select *
 from rsmaes
 where ma_reserv = '683958'
 
 select *
 from rscondet
 where cd_hotel= '01' and cd_charter = 'MAGNI' and cd_type = '01' and cd_room = 'DSTD' 
 
 select *
 from rsconhed
 where ch_hotel= '01' and ch_charter = 'MAGNI' 
 
 
 select *
 from rsoperator
 where op_id = 'MAGNI'
 
 desc crsquery
 
 
 select *
 from rsrldet
 WHERE rd_reserv = '683960'
 
 select *
 from rsmaes
 where ma_reserv = '683960'
 
 
 select *
 from rsconhed
 
 
 
 desc crsqueryAccounting
 
 
 desc mentry
 
 
 delete from kkk
 
 select * from kkk
 
select distinct nvl( cd_room,'ROH') cd_room
from rsconhed, rscondet
where ch_hotel = '04'
    and ch_charter = 'APPLE'
    and ch_type = '01'
    and :xarrival between ch_sta_sea and ch_end_sea
    and :xarrival+:xnights-1 between ch_sta_sea and ch_end_sea
    and ch_activ ='Y'
    and cd_hotel = ch_hotel
    and cd_charter = ch_charter
    and cd_type = ch_type
    and cd_end_sea = ch_end_sea;



select *
from rsconhed
where ch_hotel = :hotel
    and ch_charter = :touroperator
order by ch_sta_sea     




 
 
 update rsoperator a
 set op_guarantee = 99
 where not exists (select 1 from rsoperator_back b where a.op_id = b.op_id) 
 
 
 select unique ch_charter
 from rsconhed, rsoperator
 where ch_charter = op_id and 
           ch_divisa <> op_res_currency and
           op_guarantee = 99
           
           
select *
from rscondet
where cd_charter = :operator

select T.ROWID, T. * -- unique ch_divisa
from rsconhed T
where ch_charter = :operator
 
 select OP_ID, OP_NAME, OP_INV_CURRENCY, OP_RES_CURRENCY,  t.rowid
 from rsoperator t
 where op_id = :operator
 
 
 select  unique cd_charter
 from rscondet
 where cd_single < 800  and cd_single > 0 and 
          exists ( select 1 from rsconhed where ch_hotel = cd_hotel and ch_charter = cd_charter and ch_type = cd_type and ch_end_sea = cd_end_sea and nvl(ch_divisa,'USD') <> 'USD')
          
          
select *
from fragen
where ag_agencia = :operator          

select * from rsopecharter

insert into rsopecharter
select op_id, op_id, null
from rsoperator
where op_guarantee = 99 
    and not exists ( select 1 from rsopecharter where oc_charter = op_id)

select *
from rsconhed
where ch_desc = 'TRASPASO' and not exists ( select 1 from rsoperator where op_id = ch_charter )

select * 
from rsoperator

desc rsoperator

select nvl(op_res_currency, op_inv_currency) op_res_currency
from rsoperator, rsopecharter
where  op_id = oc_operator
    and  oc_charter = 'APPLE'
    
   

select op_name, count(*)
from rsoperator
group by op_name 
having count(*) > 1   


select *
from rsoperator
where op_name = :opName
    
    
desc toinvoicing

select t.*, t.rowid
from rshotel t


select *
from mares
where mr_reserva = '683997'

select *
from mares
where mr_reserva ='165035'


select *
from rsmaes
where ma_reserv = '683997'


select *
from fragen
where ag_agencia = 'CARIBEAN'

select *
from rscharter
where ch_country = 'SW'

update rscharter
set ch_country = 'PT'
where ch_country = 'PO'


select *
from rsoperator
where op_country = 'SW'


update rsoperator
set op_country = 'PT'
where op_country = 'PO'



select t.*, t.rowid
from rscountry t