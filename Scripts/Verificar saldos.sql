
desc oasisstatement_xls


select t.*, t.rowid from asto t where as_emp = '60' and as_plan = 'A' and as_eje = 13 and as_per = :per and as_asi = :asi;

delete from asto  where as_emp = '60' and as_plan = 'A' and as_eje = 13 and as_per = :per and as_asi = :asi;

select t.*, t.rowid from diag t where dg_emp = '60' and dg_plan = 'A' and dg_eje = 13 and (dg_int =  '&numero' or dg_desc like '%'||:numero||'%') ; -- ojo con los refunds

select t.*, t.rowid from diag t where dg_emp = '60' and dg_plan = 'A' and dg_eje = 13 and dg_per = :per and dg_asi = :asi;

select T.*, t.rowid from ccmaes t where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and cc_per = :per and cc_asi = :asi;

select t.*, t.rowid from ccmaes t where cc_emp = '60' and cc_plan = 'A'  and cc_factura = :invoice;

select t.*, t.rowid from ccmaes t where cc_emp = '60' and cc_plan = 'A' and cc_numero  = :numero order by cc_cuenta, cc_eje, cc_per, cc_asi

select t.*, t.rowid from ccmaes t where cc_emp is null

select t.*, t.rowid from diag t where dg_int = :numero

select * from rinvoice where in_inv_num = :invoice

select * from cuentas where ct_cg = :cuenta
     
select t.*, t.rowid from numeros t where nm_emp = '60' and nm_plan = 'A'  and nm_eje = 13

select * from ccmaes where cc_tipo = 8 and cc_eje = 13

select * from diag where dg_cg = :cuenta and dg_dh = 'H'



--<><><>  PAGOS Y PREPAGOS.... 
        -- Verifica sal do de  cuentas de ccmaes tipo 7(prepago) vs. suma(tipo 6) pagos.
        -- 43001020101004
          select *
          from ccmaes a
          where cc_tipo = 7 and cc_cuenta like '%'||substr(:cta,6,7)  and cc_importe <> cc_saldo
                and cc_importe-cc_saldo <> (select sum(b.cc_importe) from ccmaes b where b.cc_emp = a.cc_emp and b.cc_plan = a.cc_plan and substr(a.cc_cuenta,6,7) = substr(b.cc_cuenta,6,7) and b.cc_tipo = 6 and b.cc_numero = a.cc_numero) 
          order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
                 
              
         -- Verifica saldos de facturas  Saldo tipo 1 mustbe equal to sum (tipo6,8)
         select *
         from ccmaes a
         where cc_emp = '60' and cc_plan = 'A' and cc_tipo = 1 and substr(cc_cuenta,7,6) = substr(:cuenta,7,6)
         order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
         
          and --cc_importe <> cc_saldo and 
            cc_importe-cc_saldo  <> ( select sum(cc_importe) from ccmaes b where a.cc_emp = b.cc_emp and a.cc_plan = b.cc_plan and b.cc_cuenta = a.cc_cuenta and b.cc_factura = a.cc_factura  and b.cc_tipo in ('6','8')  ) 
         order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
         
         select *
         from diag
         where dg_emp = '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_dh = 'H'
         order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi

        -- Verifica aplicacion pagos en diag vs pagos en CCMAES
        -- 43001020101004
        select *
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'D' and dg_cg = :cuenta
            and dg_imp != ( select sum(cc_importe) from ccmaes where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_asi = dg_asi ) 
        order by dg_eje, dg_per, dg_asi    

        -- 430 -H   vs.   tipo 6,8  <><> PAGOS 
        select *
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'H' and dg_cg = :cuenta
            and not exists ( select 1 from ccmaes where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_asi = dg_asi and dg_cg = cc_cuenta and cc_tipo in (6,8) and cc_importe = dg_imp)
        order by dg_eje, dg_per, dg_asi    
        
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'H' and dg_cg = :cuenta
        minus
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A' and cc_tipo in ('6','8') and cc_cuenta = :cuenta
        
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A' and cc_tipo in ('6','8') and cc_cuenta = :cuenta
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'H' and dg_cg = :cuenta
        
        -- Tipo 6,8  vs.   430-H    <><> PAGOS
        select *
        from ccmaes 
        where cc_emp = '60' and cc_plan = 'A'  and cc_tipo in (6,8) and cc_cuenta = :cuenta 
            and not exists ( select 1 from diag where dg_emp = cc_emp and dg_plan = cc_plan and dg_eje = cc_eje and dg_per = cc_per and dg_asi = dg_asi and dg_cg = cc_cuenta and dg_imp = cc_importe)

        -- 430 -D   vs.   tipo 1  <><> FACTURAS 
        select *
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'D' and dg_cg = :cuenta
            and not exists ( select 1 from ccmaes where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_per = dg_per and cc_asi = dg_asi and dg_cg = cc_cuenta and cc_tipo =1 and cc_importe = dg_imp)
        order by dg_eje, dg_per, dg_asi    

        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A' and cc_tipo in ('1') and cc_cuenta = :cuenta
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'D' and dg_cg = :cuenta

        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'D' and dg_cg = :cuenta
        minus
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A' and cc_tipo in ('1') and cc_cuenta = :cuenta
        

        -- Tipo 1  vs.   430-D    <><> FACTURAS
        select 1 
        from ccmaes 
        where cc_emp = '60' and cc_plan = 'A'  and cc_tipo = 1 and cc_cuenta = :cuenta 
            and not exists ( select 1 from diag where dg_emp = cc_emp and dg_plan = cc_plan and dg_eje = cc_eje and dg_per = cc_per and dg_asi = dg_asi and dg_cg = cc_cuenta and dg_imp = cc_importe)


        -- Coincidencia de anticipos DIAG  vs.  CCMAES
        --437010201004
        select *
        from diag
        where dg_emp = '60' and dg_plan = 'A'  and dg_cg = :cuenta and dg_dh = 'H'
            and not exists ( select 1 from ccmaes where cc_emp = '60' and cc_plan = 'A' and cc_eje =dg_eje and cc_asi = dg_asi and cc_importe = dg_imp)

        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A' and cc_tipo in ('7') and cc_cuenta = :cuenta
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'H' and dg_cg = :cuenta
            

        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp = '60' and dg_plan = 'A' and dg_dh = 'H' and dg_cg = :cuenta
        minus
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A' and cc_tipo in ('7') and cc_cuenta = :cuenta
        


        --  Coincidencia de anticipos CCMAES vs DIAG   
        select *
        from ccmaes
        where cc_emp = '60'  and cc_plan = 'A'  and cc_tipo = '7' and cc_cuenta = :cuenta 
            and not exists ( select 1 from diag where dg_emp = cc_emp and dg_plan = dg_plan and dg_eje = cc_eje and dg_per = cc_per and dg_asi = cc_asi and dg_imp = cc_importe)
            
             
                 



select t.*, t.rowid
from rinvoice t
where t.in_ejercicio = 13 and t.in_period = :per and t.in_ledger = :asi;

select t.*, t.rowid
from rinvoice t
where in_inv_num = :invoice;


select sum(in_a_room) room, sum(in_a_total) total, sum(in_a_coop)
from rinvoice t
where in_inv_num = :invoice;



select t.*, t.rowid
from rscharter t
where ch_hotel = :hotel and ch_charter = :charter;


select *
from rinvoice
where in_hotel = :hotel and in_wholes = :charter;


-- Pagos en DIAG que no estan en CCMAES    
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' 
    and dg_plan = 'A'
    and dg_eje = 13
    and dg_cg = :cuenta
    and dg_dh = 'H'
minus
select cc_per, cc_asi, cc_importe
from ccmaes
where cc_emp = '60' 
        and cc_plan = 'A' 
        and cc_cuenta = :cuenta
        and cc_tipo in ( 6,7,8)
        and cc_eje = 13;        
        
-- Pagos en CCMAES que NO están en DIAG
select cc_per, cc_asi, cc_importe
from ccmaes
where cc_emp = '60' 
        and cc_plan = 'A' 
        and cc_cuenta = :cuenta
        and cc_tipo in ( 6,7,8)
        and cc_eje = 13
minus
select dg_per, dg_asi, dg_imp
from diag
where dg_emp = '60' 
    and dg_plan = 'A'
    and dg_eje = 13
    and dg_cg = :cuenta
    and dg_dh = 'H';

--
-- Suma de facturacion y su respectivo saldo
select sum(cc_importe), sum(cc_saldo)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and cc_cuenta = :cuenta and  cc_tipo  =1
and exists (
select 1 
from diag
where dg_emp = cc_emp
and dg_plan = cc_plan
and dg_eje = cc_eje
and dg_per = cc_per
and dg_asi = cc_asi
and dg_imp = cc_importe
) ;

-- total facturado para cuenta en CCMAES
select sum(cc_importe), sum(cc_saldo)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and cc_cuenta = :cuenta and  cc_tipo  =1

-- total facturado para cuenta en DIAG
select sum(dg_imp) 
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 13 and dg_cg = :cuenta and dg_dh = 'D' and dg_per > 0

-- facturas que existen en diag y no en CCMAES
select *
from diag 
where dg_emp = '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_dh = 'D'  and dg_per > 0 and 
        not exists ( select 1 from ccmaes where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_cuenta = dg_cg and cc_tipo = 1 and cc_importe = dg_imp)
        
-- pagos que existen en DIAG pero no en CCMAES
select sum(dg_imp)
--select *  
from diag
where dg_emp = '60' and dg_plan = 'A' and dg_eje = 13 and dg_cg = :cuenta and dg_dh = 'H' and  dg_per > 0 and 
       exists ( select 1 from ccmaes where cc_emp = dg_emp and cc_plan = dg_plan and cc_eje = dg_eje and cc_cuenta = dg_cg and cc_importe = dg_imp and cc_tipo in ('6','8'))
order by dg_emp, dg_plan, dg_eje, dg_per, to_number(dg_asi), dg_apu
       
       
select * 
from ccmaes a
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and cc_cuenta = :cuenta and  cc_tipo  =8

 
    and cc_saldo <> cc_importe - (select sum(cc_importe) from ccmaes b where b.cc_emp = a.cc_emp and b.cc_plan = a.cc_plan and b.cc_eje = a.cc_eje and b.cc_factura = a.cc_factura and b.cc_tipo in ('6','8'))        




-- Obtiene sal dos de prepagos...  ojo 437's ... 
--- <><> paso 1 BALANCEN
select sum(ban_d) D, sum(ban_h ) H,sum(ban_d)- sum(ban_h ) dif  from balancen where ban_emp = '60' and ban_plan = 'A'  and ban_cg =:cuenta and ban_eje = 14

-- <><> paso 2 DIAG
select sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh,'H',dg_imp,0)) H, sum(decode(dg_dh,'D',dg_imp,0))-sum(decode(dg_dh,'H',dg_imp,0)) dif from diag where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_per not in ('0','99')
-- en este paso 2 los DIF's deben de ser iguales tanto en balancen como en DIAG.


--<><> paso 3.1 checa los pagos en CCMAES, debe ser igual al paso 2   437-D
select sum(cc_importe) from ccmaes where cc_emp = '60' and cc_plan = 'A'  and  substr(cc_cuenta,6,7) = substr(:cuenta,6,7) and cc_tipo in ('6')

-- <><> paso 3.2 checa total de prepagos en CCMAES , debe de ser igual al  paso 2  437 - H
select sum(cc_importe) from ccmaes where cc_emp = '60' and cc_plan = 'A'  and  cc_cuenta = :cuenta

-- <><> paso 3.3 checa saldo de prepagos en CCMAES , debe de ser igual a la diferencia del paso 2
select sum(cc_saldo) from ccmaes where cc_emp = '60' and cc_plan = 'A'  and  cc_cuenta = :cuenta


        -- Verifica 473-D vs.  Pagos...  (se utiliza substr pues un prepago llega a la 437.. pero los pagos van a diferentes hoteles)... 
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp 
        from diag where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_per not in ('0','99') and dg_dh = 'D'
        minus
        select  cc_emp, cc_plan, cc_eje, cc_per, cc_asi, sum(cc_importe) 
        from ccmaes where cc_emp = '60' and cc_plan = 'A'  and  substr(cc_cuenta,8,5) = substr(:cuenta,8,5) and cc_tipo in ('6')
        group  by cc_emp, cc_plan, cc_eje, cc_per, cc_asi

        select  cc_emp, cc_plan, cc_eje, cc_per, cc_asi, sum(cc_importe) 
        from ccmaes where cc_emp = '60' and cc_plan = 'A'  and  substr(cc_cuenta,8,5) = substr(:cuenta,8,5) and cc_tipo in ('6')
        group  by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp 
        from diag where dg_emp= '60' and dg_plan = 'A' and substr(dg_cg,8,5) = substr(:cuenta,8,5) and dg_per not in ('0','99') and dg_dh = 'D'
        


        -- Verifica 437-H vs. Prepagos.  (aqui no se usa substr pues la cuenta es 437.. tal cual)
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe from ccmaes where cc_emp = '60' and cc_plan = 'A'  and  cc_cuenta = :cuenta and cc_tipo in ('7')
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp from diag where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_per not in ('0','99') and dg_dh = 'H'



-- <><> paso 4  Saldo en los prepagos deberia de ser igual a la columna dif del  paso 2
--<><><> pagos y notas de credito en CCMAES  vs. 437 al 'D'
-- 437010301066

        -- Pagos y notas de credito en DIAG  vs CCMAES
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi,dg_imp 
        from diag
        where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_per not in ('0','99') and dg_dh = 'D'
        minus 
        select cc_emp, cc_plan , cc_eje, cc_per, cc_asi, sum(cc_importe)
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A'  and  substr(cc_cuenta,'8','5') = substr(:cuenta,'8','5') and cc_tipo in ('6','8')
        group by cc_emp, cc_plan , cc_eje, cc_per, cc_asi


        -- Pagos y notas de credito en CCMAES vs. DIAG 
        select cc_emp, cc_plan , cc_eje, cc_per, cc_asi, sum(cc_importe)
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A'  and  substr(cc_cuenta,'8','5') = substr(:cuenta,'8','5') and cc_tipo in ('6','8')
        group by cc_emp, cc_plan , cc_eje, cc_per, cc_asi
        minus 
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi,dg_imp 
        from diag
        where dg_emp= '60' and dg_plan = 'A' and substr(dg_cg,8,5) = substr(:cuenta,8,5) and dg_per not in ('0','99') and dg_dh = 'D'



-- Si el paso 4 no cuadró, entonces este query arrojará el apunte error para 437 al H.
    select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
    from diag
    where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_dh = 'H' --and dg_per not in ('0') 
    minus
    select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
    from ccmaes
    where cc_emp = '60' and cc_plan = 'A'  and  cc_cuenta = :cuenta

    select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, cc_importe
    from ccmaes
    where cc_emp = '60' and cc_plan = 'A'  and  cc_cuenta = :cuenta
    minus
    select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
    from diag
    where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_dh = 'H' --and dg_per not in ('0') 

 
--<><> Paso 5  437-D  Pagos aplicados
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp= '60' and dg_plan = 'A' and dg_cg = :cuenta and dg_dh = 'D' 
        minus
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, sum(cc_importe)
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A'  and  cc_tipo in ('8','5')  and substr(cc_cuenta,8,5) = substr(:cuenta, 6,7)
        group by cc_emp, cc_plan, cc_eje, cc_per, cc_asi

        --<><><> Checa Pagos
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, sum(cc_importe)
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A'  and  cc_tipo in ('6')  and substr(cc_cuenta,8,5) = substr(:cuenta, 8,5)
        group by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp= '60' and dg_plan = 'A' and substr(dg_cg,8,5) = substr(:cuenta,8,5) and dg_dh = 'D' 

        -- <><>  Checa Notas de credito
        select cc_emp, cc_plan, cc_eje, cc_per, cc_asi, sum(cc_importe)
        from ccmaes
        where cc_emp = '60' and cc_plan = 'A'  and  cc_tipo in ('8')  and substr(cc_cuenta,8,5) = substr(:cuenta, 8,5)
        group by cc_emp, cc_plan, cc_eje, cc_per, cc_asi
        minus
        select dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_imp
        from diag
        where dg_emp= '60' and dg_plan = 'A' and substr(dg_cg,8,5) = substr(:cuenta,8,5) and dg_dh = 'H' 



 
-- Comprueba que el saldo de la factura (tipo 1 sea en realidad lo que se ha aplicado (tipo 6,8) 
select unique cc_factura, cc_importe - cc_saldo
from ccmaes  a
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14  and cc_tipo = 1 
and  exists ( select 1 from ccmaes b where b.cc_emp = '60' and b.cc_plan = 'A' and b.cc_eje = 13 and b.cc_factura = a.cc_factura and b.cc_tipo <> 1) 
minus 
select cc_factura, sum(cc_importe)
from ccmaes 
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14  and cc_tipo in ('6','8')
group by cc_factura;


-- Balance de pagos correcto ????  Lo aplicado es igual al (importe  - saldo) del pago en CCMAES ?
select cc_eje, cc_numero, sum(cc_importe-cc_saldo) pagado
from ccmaes a
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_tipo = 7 
and exists (select 1 from ccmaes b where cc_emp = '60' and cc_plan = 'A' and cc_eje = 13 and a.cc_numero = b.cc_numero and b.cc_tipo = 6)  -- Si tenga pagos aplicados
and not exists ( select 1 from diag  where dg_emp = cc_emp and dg_plan = cc_plan and dg_eje = cc_eje and dg_cg = cc_cuenta and dg_dh = 'D'  and dg_desc like '%'||cc_numero||'%')  -- No tenga un refund or charge backs... 
group by cc_eje, cc_numero 
minus
select cc_eje, cc_numero, sum(cc_importe)
from ccmaes
where cc_emp = '60' and cc_plan = 'A' and cc_eje = 14 and cc_tipo = 6
group by cc_eje, cc_numero;

