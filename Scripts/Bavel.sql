



genSunwing
genTCook
genAnexTour
genITSVx


execute testBavel 




select *
from rshotel
order by to_number(ho_hotel)



select  
    'DatosGenerales;' || in_inv_num ||';'||'FacturaComercial'||';'||to_char(in_inv_date,'YYYY-MM-DD') || ';'|| op_inv_currency || ';Y;' ||chr(13)||chr(10)||
    'Proveedor;' || 'TRAV' ||';B116493;'||'TravAmerica Inc'||';'||'4505 Peachtree lakes' ||';'||'Duluth'||';30096;GA;' || 'USA' ||';'||chr(13)||chr(10)||
    'Cliente;' || op_id ||';'||op_taxid||';'||op_name||';'||op_address_1 ||';'||op_address_2||';' ||op_address_4||';'|| getIsoCountry(op_country) ||';'||chr(13)||chr(10)||
    'Establecimientos;' || ho_hotel ||';'||ho_desc||';'||ho_adress||';'||'Cancún' ||';77500;'||'MEX'||';'||chr(13)||chr(10)||
    (
        select 'Detalle;'|| b.in_reserv ||';'|| b.in_voucher||';Hotel reservation;'||in_nites||';Nights;'||in_a_total/in_nites||';'||in_a_total||';' ||chr(13)||chr(10)||
               'DatosdeServicio;'|| b.in_wholes ||';'|| b.in_hotel||';'||ho_desc||';'||getGuestName(b.in_hotel, b.in_reserv)||';'||to_char(in_arrival,'YYYY-MM-DD')|| ';'|| to_char(in_depart,'YYYY-MM-DD')||';' ||chr(13)||chr(10)  
        from rinvoice b  
        where b.in_hotel = i.in_hotel
            and b.in_reserv = i.in_reserv
    )||
    'Referencias;'||in_inv_num||';'||to_char(in_inv_date,'YYYY-MM-DD') ||';'||chr(13)||chr(10)||
    'ResumenImpuestos;VAT;0;0;'||chr(13)||chr(10)||
    'ResumenTotales;'|| (select sum(b.in_a_total) from rinvoice b where b.in_hotel = i.in_hotel and b.in_inv_num = i.in_inv_num) ||';0;'||(select sum(b.in_a_total) from rinvoice b where b.in_hotel = i.in_hotel and b.in_inv_num = i.in_inv_num)
from rinvoice i, rsoperator, rsopecharter, rshotel a
where   oc_charter = in_wholes
    and op_id = oc_operator
    and ho_hotel = in_hotel
    and in_wholes like 'TUI%'
    and in_inv_num = :invoice
    
    
    
    
    
    
select * from rshotel 

select * from rinvoice where in_inv_num = :invoice


select * from rsoperator where op_country = 'EN'

select * from rscountry where co_country like 'M%'

select * from rscountries  where co_desc like 'UNI%'

create table iso3166 (
code    varchar2(3),
nombre  varchar2(240)
)


select t.*, t.rowid 
from rscountry t
where co_iso is null


update rscountry
set co_iso = (select code from iso3166 where trim(upper(nombre)) = trim(upper(co_desc)))
where co_iso is null


 

update rscountry a
set a.co_iso = (select b.co_iso  from rscountries b where trim(upper(b.co_desc)) = trim(upper(a.co_desc)))
where a.co_iso is null


select * from rscountries

desc getguestname


select * from rscountries

select t.*, t.rowid 
from rscountries t
where co_iso is null


update rscountries
set co_iso = (select codigo from iso3166 where trim(upper(nombre)) = trim(upper(co_desc)) )



select * from rsoperator



