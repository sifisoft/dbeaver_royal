DROP TRIGGER FRONTSENS.FRESERVA_TRAVAMERICA;

CREATE OR REPLACE TRIGGER FRONTSENS.FRESERVA_TRAVAMERICA
after insert or update ON FRONTSENS.FRESERVA for  each row
declare
    cursor c1(xFase varchar2) is
    select *
    from frmodfas
    where mf_fase = xFase;


    pAction     varchar2(1) := 'U';
    vUserTrav   varchar(8) := 'TRAVAMER';
    vc1         c1%rowtype;
begin


    /*
        Parametros de escape.
            * El insert viene de travamer entonces no regresa nada a Travamerica
            * El update viene de trav entonces no regresa nada a Travamerica
    */
    if inserting then
       -- No hay nada que regresar a trav cuando viene un insert de travamerica
       if :new.rv_cap_u = vUserTrav then
          return;
       end if;
    else
        -- Si la reserva esta cancelada entonces ...
       if :new.rv_can_f is not null  then
            -- No regresa nada si el que cancela es travamerica... 
           if :new.rv_can_u = vUserTrav     then
               return;
           end if;
        -- Si la reserva fue modificada entonces ...
      elsif :new.rv_mod_f is not null then
             -- No regresa nada si la modificacion es de travamerica
           if :new.rv_mod_u = vUserTrav  then
               return;
           end if;
       end if;
    end if;
    
    
    -- Travamerica solo aceptara movimientos de actualizacion dentro de la 
    -- ventana de llegada y salida para mercados de Travamerica
    if :new.rv_mayorista in ('AME','EUR','FIT','SUD') and trunc(sysdate) not between :new.rv_llegada and :new.rv_salida then
        return;
    end if;
    
    if inserting then
        pAction := 'I';
    end if;
    
    open c1(:new.rv_fase);
    fetch c1 into vc1;
    close c1;
    
    insert into rstrans
    (tr_stamp, tr_hotel, tr_reserv, tr_source, tr_action, tr_done)
    values(sysdate, vc1.mf_modulo, :new.rv_reserva, 'H', pAction,'N');

end;
/
