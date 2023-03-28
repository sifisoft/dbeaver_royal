
select max(dg_per)
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_asi <10000;

commit;

select *
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_per = 8
order by dg_asi, dg_apu;

SELECT *
FROM diag
WHERE dg_emp = 70 AND dg_plan ='A' AND dg_eje = 18 AND dg_per = 10


-- Inserta en CCMAES los movimientos por periodo de la 60 a la 70, solo movimientos de SUD
insert into ccmaes
select 70, cc_plan, cc_eje, cc_per, cc_cuenta, cc_factura, cc_fecmov, cc_feccon, cc_fecven, cc_tipo, cc_asi, cc_apu, cc_tmov, cc_banco, cc_banrec, cc_numero, cc_pago, cc_importe, cc_saldo, cc_impext, cc_salext, cc_moneda, cc_cambio, cc_rooming, cc_servicio, cc_consec, cc_quien, cc_impaga, cc_clicod
from ccmaes a 
where cc_emp = 60 
    and substr(cc_cuenta, 6,2) = '04'
    and cc_eje = 18
    and cc_per = :per
;



-- Inserta en DIAG    
insert into diag    
select 70, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where   dg_emp = 60
    and dg_plan = 'A'
    and dg_eje = 18
    and dg_per = :per
    and dg_asi in (
        select unique b.dg_asi
        from diag b
        where    b.dg_emp = a.dg_emp
            and  b.dg_plan = a.dg_plan 
            and  b.dg_eje = a.dg_eje
            and  b.dg_per = a.dg_per
            and  substr(b.dg_cg,6,2) = '04'
            --and  b.dg_cg  not in ( '572010101001', '572010101007','572010101009')   -- Sin bancos.
    )
order by dg_plan, dg_eje, dg_asi, dg_apu;    


-- Quita registros de ASTO basura
delete from asto
where as_emp = 70 and as_plan = 'A' and as_eje = 18 and not exists (
select 1
from diag
where dg_emp = as_emp
    and dg_plan = as_plan
    and dg_eje = as_eje
    and dg_per = as_per 
    and dg_asi = as_asi
)    
;


--- Bancos..
insert into diag    
select 70, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where   dg_emp = 60
    and dg_plan = 'A'
    and dg_eje = 18
    and dg_per = :per
    and dg_asi in (
        select unique b.dg_asi
        from diag b
        where    b.dg_emp = a.dg_emp
            and  b.dg_plan = a.dg_plan 
            and  b.dg_eje = a.dg_eje
            and  b.dg_per = a.dg_per
            and  b.dg_cg  in ('572010101007')
            --and  b.dg_cg  in ( '572010101001')
            and  not exists (
                select 1 
                from diag c
                where   c.dg_emp = 70
                    and c.dg_plan = b.dg_plan
                    and c.dg_eje = b.dg_eje
                    and c.dg_per = b.dg_per
                    and c.dg_asi = b.dg_asi
            )
    )
order by dg_plan, dg_eje, dg_asi, dg_apu;    


select dg_emp, dg_per, sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh, 'H',dg_imp,0)) H
from diag
where dg_emp in (60,70) and dg_plan = 'A' and dg_eje = 18 and dg_per = :per and dg_cg like '572010101001'
group by dg_emp, dg_per
order by dg_emp, dg_per
;



--  ASTO inserta apuntes faltantes... 
insert into asto
select 70, as_plan, as_eje, as_per, as_asi, as_fcon, as_bd, as_usua, as_ofi, as_fetip, as_tipol 
from asto a
where as_emp = 60 
    and exists (
        select 1
        from diag
        where   dg_emp = 70
            and dg_plan = a.as_plan
            and dg_eje = a.as_eje
            and dg_per = a.as_per
            and dg_asi = a.as_asi
            and not exists (
                select 1
                from asto b
                where b.as_emp = 70
                    and b.as_plan = dg_plan
                    and b.as_eje = dg_eje
                    and b.as_per = dg_per
                    and b.as_asi = dg_asi
            )
    )  
;


COMMIT;

SELECT sum(decode(dg_dh,'D', dg_imp*-1, dg_imp))
FROM DIAG
WHERE dg_emp = 60 AND dg_plan = 'A' AND dg_eje = 18 AND dg_per = 8 AND dg_cg = '572010101007'
ORDER BY dg_asi;


-- clean period

delete from diag where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_per between 1 and 1 and dg_asi < 10000

delete from asto where as_emp = 70 and as_plan = 'A' and as_eje = 18 and as_per between 1 and 1 and as_asi < 10000


-- verify account

select *
from diag a
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_per = :per and
    dg_asi in (
        select dg_asi
        from diag b
        where   b.dg_emp = a.dg_emp
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_cg = :cuenta
    ) 
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi


-- Quita apuntes del banco que no tienen en el substr(6,2)   04
delete from diag a
where   dg_emp = 70 
    and dg_plan = 'A'
    and dg_eje = 18
    and dg_per between 1 and 5
    and dg_asi in 
    (
        select dg_asi
        from diag b
        where   b.dg_emp = a.dg_emp
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_asi in 
            (
                select unique c.dg_asi
                from diag c
                where   c.dg_emp = b.dg_emp
                    and c.dg_plan = b.dg_plan
                    and c.dg_eje = b.dg_eje
                    and c.dg_per = b.dg_per
                    and c.dg_cg = :cuenta
            )
        group by dg_asi, substr(dg_cg,6,2)
        having substr(dg_cg,6,2) != '04'     
    )
    
    

select *
from diag a
where dg_emp = :emp and dg_plan = 'A' and dg_eje = 18 and dg_per= :per and dg_asi in 
(
    select unique dg_asi
    from diag b
    where   b.dg_emp = a.dg_emp
        and b.dg_plan = a.dg_plan
        and b.dg_eje = a.dg_eje
        and b.dg_per = a.dg_per
        and b.dg_cg = :cuenta 
)
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_apu
   




select dg_emp, dg_per, dg_cg, sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh, 'H',dg_imp,0)) H
from diag
where dg_emp in (60,70) and dg_plan = 'A' and dg_eje = 18 and dg_per =1 and dg_cg = :cuenta
group by dg_emp, dg_per, dg_cg
order by dg_per













select t.*, t.rowid 
from numeros t
where nm_emp = 70
order by nm_eje, nm_per

select *
from cuentas
where ct_emp = 70 and ct_eje = 17 
order by ct_cg, ct_nivel


select max(cc_per)
from ccmaes
where cc_emp = 70 and cc_eje = 18 -- and cc_per = 10

select *
from diag a where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_per = 1 and dg_asi < 10000 and not exists ( select 1 from diag b where b.dg_emp = a.dg_emp and b.dg_plan = a.dg_plan and b.dg_eje = a.dg_eje and b.dg_per = a.dg_per and b.dg_asi = a.dg_asi and b.dg_apu = a.dg_apu)

--delete from ccmaes where cc_emp = 70 and cc_plan = 'A' and cc_eje = 18 and cc_per = 2 and cc_asi < 10000



























select * from diag;


travProduction_emp70;

select *
from cuentas
where ct_emp = 60 and ct_eje = 17 and ct_nivel = 3 
order by ct_nivel;


select substr(ch_acc_inv, 6,2), count(*)
from rscharter
where ch_utl = 'SUD'
group by substr(ch_acc_inv, 6,2)


select cc_eje
from ccmaes 
where cc_emp = 70;


-- Limpia movimientos de CCMAES para empresa destino.
delete from ccmaes where cc_emp = :empresaDestino;

delete from diag where dg_emp = :empresaDestino;

delete from asto where as_emp = :empresaDestino;

delete from numeros where nm_emp = :empresaDestino and nm_eje = 17;


-- Inserta en CCMAES
insert into ccmaes
select :empresaDestino, cc_plan, cc_eje, cc_per, cc_cuenta, cc_factura, cc_fecmov, cc_feccon, cc_fecven, cc_tipo, cc_asi, cc_apu, cc_tmov, cc_banco, cc_banrec, cc_numero, cc_pago, cc_importe, cc_saldo, cc_impext, cc_salext, cc_moneda, cc_cambio, cc_rooming, cc_servicio, cc_consec, cc_quien, cc_impaga, cc_clicod
from ccmaes a 
where cc_emp = :empresaOrigen 
    and substr(cc_cuenta, 6,2) = '04'
    and exists (
        select 1
        from ccmaes b 
        where   b.cc_emp = a.cc_emp
            and b.cc_plan = a.cc_plan
            and b.cc_eje = a.cc_eje
            and b.cc_per = a.cc_per
            and b.cc_asi = a.cc_asi
    )
    ;

create table diag20171018 as select * from diag;
    
-- Inserta en DIAG    
insert into diag
select :empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where exists (
    select 2 --:empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
    from diag b
    where    b.dg_emp = :empresaOrigen
        and b.dg_plan = 'A'
        and b.dg_eje = 17
        and b.dg_per = 5 
        and substr(b.dg_cg,6,2) = '04'
        and  a.dg_emp = b.dg_emp
        and  a.dg_plan = b.dg_plan
        and  a.dg_eje = b.dg_eje
        and  a.dg_per = b.dg_per
        and  a.dg_asi = b.dg_asi
)
order by dg_emp, dg_plan, dg_eje, dg_asi, dg_apu;    

select * from diag where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per = 5 order by dg_asi desc;

-- Bancos 
insert into diag    
select :empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where exists (
    select 1 --:empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
    from diag b
    where    b.dg_emp = :empresaOrigen 
        and  b.dg_cg = '572010101009'
        and  b.dg_emp = a.dg_emp
        and  b.dg_plan = a.dg_plan
        and  b.dg_eje = a.dg_eje
        and  b.dg_per = a.dg_per
        and  b.dg_asi = a.dg_asi
)
order by dg_emp, dg_plan, dg_eje, dg_asi, dg_apu;    


-- Complementa ASTO
insert into asto
select :empresaDestino, as_plan, as_eje, as_per, as_asi, as_fcon, as_bd, as_usua, as_ofi, as_fetip, as_tipol 
from asto a
where as_emp = :empresaOrigen 
    and exists (
        select 1
        from diag
        where   dg_emp = :empresaDestino
            and dg_plan = a.as_plan
            and dg_eje = a.as_eje
            and dg_per = a.as_per
            and dg_asi = a.as_asi
            and not exists (
                select 1
                from asto b
                where b.as_emp = :empresaDestino
                    and b.as_plan = dg_plan
                    and b.as_eje = dg_eje
                    and b.as_per = dg_per
                    and b.as_asi = dg_asi
            )
    )  


-- Contadores
insert into numeros
select :empresaDestino, nm_plan, nm_eje, nm_per, nm_cg
from numeros
where nm_emp = :empresaOrigen and nm_eje = 17;


-- Actualizacion de Cuentas
insert into cuentas
select :empresaDestino, ct_plan, ct_eje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas a
where ct_emp = :empresaOrigen and ct_plan = 'A' and ct_eje = 17 and ct_nivel >= 3 and substr(ct_cg,6,2) = '04' 
    and not exists 
    (
        select 1
        from cuentas b
        where b.ct_emp = :empresaDestino and b.ct_plan = a.ct_plan and b.ct_eje = a.ct_eje and b.ct_cg = a.ct_cg 
    )

 

select * from diag
where dg_cg = '572010101009'


select *
from diag a
where dg_emp = 70 and dg_plan = 'A' and dg_eje < 17 and not exists 
(
    select 1 
    from diag b
    where 
)

select dg_emp, dg_plan, dg_eje, dg_per, dg_asi
from diag
where dg_emp = 60 and dg_cg = '572010101007'
group by dg_emp, dg_plan, dg_eje, dg_per, dg_asi
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi



select * from diag where dg_emp =60 and dg_plan = 'A' and dg_eje = 17 and dg_per = 5 and dg_asi = 8222

select t.*, t.rowid from asto t where as_emp = 80 and as_plan = 'A' and as_eje = 17 and as_per = 10 and as_asi = 2

delete from diag where dg_emp = :empresaDestino and dg_eje < 17;

delete from diag where dg_emp = :empresaDestino and dg_per < 6;


-- Pasar apunte de 572010101007 con saldo inicial de 50,0000 pedido por tarazona.  
insert into diag    
select :empresaDestino, dg_plan, dg_eje, 6, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where exists (
    select 1 
    from diag b
    where    b.dg_emp = :empresaOrigen 
        and  b.dg_plan = 'A'
        and  b.dg_eje = 17
        and  b.dg_per = 5
        and  b.dg_asi = 8222
        and  a.dg_emp = b.dg_emp
        and  a.dg_plan = b.dg_plan
        and  a.dg_eje = b.dg_eje
        and  A.dg_per = b.dg_per
        and  a.dg_asi = b.dg_asi
   )


-- Duplicate Row and copy it to company 70, per 6 keeping asi the same
select t.*, t.rowid
from asto t
where as_emp = 60 and as_plan = 'A' and as_eje= 17 and as_per = 5 and as_asi = 8222;


select *
from balancen
where ban_emp = 70;


select count(*) 
from ccmaes
where cc_emp = 70 and cc_tipo in (1,6) and cc_saldo < 0
order by cc_emp, cc_plan, cc_eje, cc_per, cc_asi 

select * 
from diag
where dg_emp = 70 and dg_cg like '400010101002%';
        
select t.*, t.rowid  from diag t where dg_emp = '70' and dg_plan = 'A' and dg_eje = 17 and dg_per = :per and dg_asi in (2327,2328,2329,2330,2331,2332,2333,2334,2335) 
order by dg_asi;

select t.*, t.rowid  from diag t where dg_emp = '70' and dg_plan = 'A' and dg_eje = 17 and dg_per = :per and dg_asi in (3641,3642) 
order by dg_asi;




select t.*, t.rowid
from diag t
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_asi = 7262;




select t.*, t.rowid
from diag t
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per = 5 and  dg_asi = 8222;


select * from asto 
where as_emp =  70 and as_plan = 'A' and as_eje = 17 and as_per = 10 and as_asi = 1762



insert into diag
select :empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec 
from diag c
where exists 
(
select 1
from diag a
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_cg = '572010101007' 
    and not exists (
        select 1 
        from diag b
        where   b.dg_emp = 70
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_asi = a.dg_asi 
    )
    and c.dg_emp = a.dg_emp
    and c.dg_plan = a.dg_plan
    and c.dg_eje = a.dg_eje
    and c.dg_per = a.dg_per
    and c.dg_asi = a.dg_asi
)
order by dg_eje, dg_per, dg_asi


delete from diag a
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and exists
(
    select 1
    from diag b 
    where b.dg_emp = a.dg_emp
        and b.dg_plan = a.dg_plan
        and b.dg_eje = a.dg_eje
        and b.dg_per = a.dg_per
        and b.dg_asi = a.dg_asi
        and b.dg_cg = '572010101007'
)



delete from diag a
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and exists
(
    select 1
    from diag b 
    where b.dg_emp = a.dg_emp
        and b.dg_plan = a.dg_plan
        and b.dg_eje = a.dg_eje
        and b.dg_per = a.dg_per
        and b.dg_asi = a.dg_asi
        and b.dg_cg = '572010101003'
)




-- Copiar Bancos
insert into diag
select :empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec 
from diag c
where exists 
(
select 1
from diag a
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 18 and dg_per = 10 and dg_cg = '572010101007' 
    and not exists (
        select 1 
        from diag b
        where   b.dg_emp = 70
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_asi = a.dg_asi 
    )
    and c.dg_emp = a.dg_emp
    and c.dg_plan = a.dg_plan
    and c.dg_eje = a.dg_eje
    and c.dg_per = a.dg_per
    and c.dg_asi = a.dg_asi
)
order by dg_eje, dg_per, dg_asi







--select a.*, a.rowid
select count(*) 
from diag a 
where exists 
(
    select 1
    from diag b
    where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per between 2 and 5 and dg_cg = '572010101001'
        and a.dg_emp = b.dg_emp
        and a.dg_plan = b.dg_plan
        and a.dg_eje = b.dg_eje
        and a.dg_per = b.dg_per
        and a.dg_asi = b.dg_asi 
)
order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi



--select a.*, a.rowid 
update diag a
set dg_dh = decode(dg_dh,'D','H','D') 
where exists 
(
    select 1
    from diag b
    where dg_emp = 70 and dg_plan = 'A' and dg_cg = '572010101009'
        and a.dg_emp = b.dg_emp
        and a.dg_plan = b.dg_plan
        and a.dg_eje = b.dg_eje
        and a.dg_per = b.dg_per
        and a.dg_asi = b.dg_asi 
)
--order by dg_emp, dg_plan, dg_eje, dg_per, dg_asi





select * 
from conta.diag
WHERE dg_cg = '572010101009'
;




insert into diag
select :empresaDestino, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec 
from diag c
where exists 
(
select 1
from diag a
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_per = 0 and substr(dg_cg,6,2) = '04'  --and dg_cg like '7000204%' --substr(dg_cg,6,2) = '04' --dg_cg like '7000104%' 
    and not exists (
        select 1 
        from diag b
        where   b.dg_emp = 70
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_asi = a.dg_asi 
    )
    and c.dg_emp = a.dg_emp
    and c.dg_plan = a.dg_plan
    and c.dg_eje = a.dg_eje
    and c.dg_per = a.dg_per
    and c.dg_asi = a.dg_asi
)
order by dg_eje, dg_per, dg_asi








select dg_per, sum(decode(dg_dh,'D',dg_imp,0)) D, sum(decode(dg_dh, 'H',dg_imp,0)) H
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_per >= 2 and dg_cg like '7000204%'
group by dg_per
order by dg_per


delete from balancen where ban_emp = 70 and ban_plan = 'A' and ban_eje = 18 and ban_per between 0 and 1

select * from balancen where ban_emp = 70 and ban_plan = 'A' and ban_eje = 18 and ban_per between 0 and 1

select * from balancen where ban_emp in (60,70) and ban_plan = 'A' and ban_eje = 18 and ban_per = 1 and ban_cg = '572010101007'



select max(dg_asi)
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_per = 9;


select t.*, t.rowid
from numeros t
where nm_emp = 70 and nm_plan = 'A' and nm_eje = 17



select *
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per = 3
order by dg_asi, dg_apu;


-- Quita registros de ASTO basura
delete from asto
where as_emp = 70 and as_plan = 'A' and as_eje = 18 and not exists (
select 1
from diag
where dg_emp = as_emp
    and dg_plan = as_plan
    and dg_eje = as_eje
    and dg_per = as_per 
    and dg_asi = as_asi
)  ;  



commit;



select *
from diag t
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and not exists (
select 1
from asto
where as_emp = dg_emp
and as_plan = dg_plan
and as_eje = dg_eje
and as_per = dg_per
and as_asi = dg_asi
)
    

select *
from diag  a
where exists ( 
	select 1
	from diag b
	where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_per = 8 AND dg_cg = '572010101007'
	    and a.dg_emp = b.dg_emp
	    and a.dg_plan = b.dg_plan
	    and a.dg_eje = b.dg_eje
	    and a.dg_per = b.dg_per
	    and a.dg_asi = b.dg_asi
)
order by dg_per, dg_asi, dg_apu






select * from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 17 and dg_per = 6
order by dg_asi, dg_apu


--select *
delete from diag c
where exists (
    select 1 
    from diag b
    where dg_cg not like '572%' and substr(dg_cg,6,2) != '04' and exists 
    (
        select 1
        from diag a
        where   dg_emp = 70
            and dg_eje = 17
            and dg_cg = '572010101001'
            and dg_per > 0
            and b.dg_emp = a.dg_emp
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_asi = a.dg_asi
    )
    and c.dg_emp = b.dg_emp
    and c.dg_plan = b.dg_plan
    and c.dg_eje = b.dg_eje
    and c.dg_per = b.dg_per
    and c.dg_asi = b.dg_asi
)
--order by dg_per, dg_asi, dg_apu


select * from diag c
--delete from diag c
where exists (
    select 1 
    from diag b
    where dg_cg not like '572%' and substr(dg_cg,6,2) != '04' and exists 
    (
        select 1
        from diag a
        where   dg_emp = 70
            and dg_eje = 17
            and dg_cg = '572010101003'
            and dg_per > 0
            and b.dg_emp = a.dg_emp
            and b.dg_plan = a.dg_plan
            and b.dg_eje = a.dg_eje
            and b.dg_per = a.dg_per
            and b.dg_asi = a.dg_asi
    )
    and c.dg_emp = b.dg_emp
    and c.dg_plan = b.dg_plan
    and c.dg_eje = b.dg_eje
    and c.dg_per = b.dg_per
    and c.dg_asi = b.dg_asi
)
--order by dg_per, dg_asi, dg_apu
        



select * 
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_per = 0
order by dg_asi, dg_apu


select * from rscharter 
order by ch_hotel, ch_charter;




select *
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and dg_asi >= 10000
order by dg_per, dg_asi, dg_apu
;



select dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where   dg_emp = 60
    and dg_plan = 'A'
    and dg_eje = 18
    and dg_per = :per
    and dg_asi in (
        select unique b.dg_asi
        from diag b
        where    b.dg_emp = a.dg_emp
            and  b.dg_plan = a.dg_plan 
            and  b.dg_eje = a.dg_eje
            and  b.dg_per = a.dg_per
            and  substr(b.dg_cg,6,2) = '04'
    )
minus
select dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
from diag a
where   dg_emp = 70
    and dg_plan = 'A'
    and dg_eje = 18
    and dg_per = :per
    and dg_asi in (
        select unique b.dg_asi
        from diag b
        where    b.dg_emp = a.dg_emp
            and  b.dg_plan = a.dg_plan 
            and  b.dg_eje = a.dg_eje
            and  b.dg_per = a.dg_per
            and  substr(b.dg_cg,6,2) = '04'
    )
order by dg_plan, dg_eje, dg_asi, dg_apu;    

commit;


/**
 * Listar apuntes de completos para una cuenta contable determinada. 
 IMPORTANTE: COPIAR CUENTAS FALTANTES... 
 */
INSERT INTO DIAG
select :empresaDestino dg_emp, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec 
from diag  a
where exists ( 
	select 1
	from diag b
	where b.dg_emp = 60 and b.dg_plan = 'A' and b.dg_eje = 18 and b.dg_per = :per AND b.dg_cg = '572010101007'
	    and a.dg_emp = b.dg_emp
	    and a.dg_plan = b.dg_plan
	    and a.dg_eje = b.dg_eje
	    and a.dg_per = b.dg_per
	    and a.dg_asi = b.dg_asi
	    and not exists (
                select 1
                from asto c
                where c.as_emp = 70
                    and c.as_plan = dg_plan
                    and c.as_eje = dg_eje
                    and c.as_per = dg_per
                    and c.as_asi = dg_asi
       )
)
order by dg_per, dg_asi, dg_apu




/**
    IMPORTANTE:  COPIAR CUENTAS FALTANTES..
**/
insert into asto
select 70, as_plan, as_eje, as_per, as_asi, as_fcon, as_bd, as_usua, as_ofi, as_fetip, as_tipol 
from asto a
where as_emp = 60 
    and exists (
        select 1
        from diag
        where   dg_emp = 70
            and dg_plan = a.as_plan
            and dg_eje = a.as_eje
            and dg_per = a.as_per
            and dg_asi = a.as_asi
            and not exists (
                select 1
                from asto b
                where b.as_emp = 70
                    and b.as_plan = dg_plan
                    and b.as_eje = dg_eje
                    and b.as_per = dg_per
                    and b.as_asi = dg_asi
            )
    )  
;





/**
 * Movimientos faltantes de pasar de la 60 a la 70.
   IMPORTANTE: COPIAR CUENTAS FALTANTES...
 */
INSERT INTO diag
SELECT 70, dg_plan, dg_eje, dg_per, dg_asi, dg_apu, dg_cg, dg_dh, dg_imp, dg_tmov, dg_desc, dg_fdoc, dg_doc, dg_tdia, dg_int, dg_cgcon, dg_cec
FROM DIAG a
WHERE EXISTS (
	SELECT 1
	FROM diag b
	WHERE dg_emp = 60 
		AND dg_plan = 'A' 
		AND dg_eje = 18 
		AND dg_per = :per
		AND substr(b.dg_cg,6,2) = '04'
		AND a.dg_emp = b.DG_EMP
		AND a.dg_plan = b.DG_PLAN
		AND a.dg_eje = b.DG_EJE
		AND a.dg_per = b.DG_PER
		AND a.dg_asi = b.dg_asi
		AND NOT EXISTS (
			SELECT 1
			FROM diag c
			WHERE c.dg_emp = 70
				AND c.dg_plan = b.DG_PLAN
				AND c.dg_eje = b.DG_EJE
				AND c.dg_per = b.DG_PER
				AND c.dg_asi = b.dg_asi
	)
)
ORDER BY dg_per, dg_asi, dg_apu
;


/**
    IMPORTANTE.. COPIAR LAS CUENTAS FALTANTES A LA 70 DE LA 60... 
    IMPORTANTE...
    IMPORTANTE... 
**/
--insert into cuentas
select 70, ct_plan, ct_eje, ct_cg, ct_desc, ct_sub, ct_tcg, ct_nivel, ct_otcec, ct_fecha, ct_ctady, ct_usua, ct_operator
from cuentas 
where ct_emp = 60 and ct_plan = 'A' and ct_eje = 18 and ct_cg in 
(
select unique dg_cg
from diag
where dg_emp = 70 and dg_plan = 'A' and dg_eje = 18 and not exists (
select 1
from cuentas
where ct_emp = dg_emp
    and ct_plan = dg_plan
    and ct_eje = dg_eje
    and ct_cg = dg_cg
    )
)
;



SELECT t.*, t.rowid
FROM diag t
WHERE EXISTS (
	SELECT 1
	FROM diag a
	WHERE a.dg_emp = 70 AND a.dg_plan = 'A' AND a.dg_eje = 18 AND a.dg_cg = '437010102088'
		AND t.dg_emp = a.dg_emp
		AND t.dg_plan = a.dg_plan
		AND t.dg_eje = a.dg_eje
		AND t.dg_per = a.dg_per
		AND t.dg_asi = a.dg_asi
)
ORDER BY dg_emp, dg_plan, dg_eje, dg_per, dg_asi
;

SELECT * FROM cuentas WHERE ct_cg = '437010401014'



