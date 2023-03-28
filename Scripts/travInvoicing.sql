


execute TravInvoicing.generate;

execute TravInvoicing_byDepart.generate;

execute TravInvoicing_mex.generate;

execute TravInvoicing_eur.generate;

execute genProformaNumber(trunc(sysdate+2));


execute avalonBookings.getAvalonBookings;


select a.*, b.ma_reserv
from rsmaes_avalon a 
left outer join rsmaes b on b.ma_reserv =  a.ma_reserv||'-'||a.ma_line
where a.ma_reserv = 'GOCRS220002679'
            and exists (
                select 1
                from entidad_avalon_crs
                where   entidad_negocio_avalon = a.ma_charter
                    and cod_crs is not null
            )

;

select * 
from entidad_avalon_crs
where   entidad_negocio_avalon = :entidadNegocio
and cod_crs is not null;
  
  select a.*
        from rsmaes_avalon a
        left outer join rsmaes b on b.ma_hotel = a.ma_hotel and b.ma_reserv =  a.ma_reserv||'-'||a.ma_line
        where   a.ma_can_d is null
            and a.ma_mayorista in ('USA','ALG','CAN','SUD','EUR')
            and a.ma_arrival between sysdate-120 and sysdate-1
            and b.ma_reserv is null         -- No existe en RSMAES
            and exists (
                select 1
                from entidad_avalon_crs
                where   entidad_negocio_avalon = a.ma_charter
                    and cod_crs is not null
            )
        ;

