


-- Import data into  CCOVERPAYMENTS exception column oc_asi;
execute processOverpayments;


select t.*, t.rowid from ccoverpayments t where co_asi is null;

select t.*, t.rowid from ccoverpayments t where co_eje = 22 and co_per = 7 order by co_empresa

select t.*, t.rowid from ccoverpayments t where co_asi is null;

select t.*, t.rowid from ccmaes t where cc_tipo = 7 and cc_numero = :numero


select t.*, t.rowid from diag t where dg_emp = :company and dg_plan = 'A' and dg_eje = 22 and dg_per = :per and dg_asi = :asi



-- Se identifica la cuenta
select * from cuentas where upper(ct_desc) like '%GALAXI%' and ct_cg like '437%' and ct_eje > 19;

-- 1.   Se identifican los apuntes en CCMAES y se deja saldo 0
select t.*, t.rowid from ccmaes t where --cc_emp = :company and   
                                        cc_numero = :numero;

select t.*, t.rowid from ccmaes t where cc_emp = :company and cc_numero = :numero;

-- 2.   Se identifica un apunte con 791  y se duplica para modificarlo y dejar el prepago en cero.
select t.*, t.rowid from ccmaes t where cc_emp = :company and cc_plan = 'A' and cc_eje = 21 and cc_asi >= '500000' order by cc_asi;

-- 3.   Se agrega apunte a DIAG
select t.*, t.rowid from diag t where dg_emp = :company and dg_plan = 'A' and dg_eje = 21  and dg_asi >= '400000' order by dg_eje, dg_per, dg_asi;

-- 4.   Se agrega apunte en ASTO
select t.*, t.rowid from asto t where as_emp = :company and as_plan = 'A' and as_eje = 21 and as_asi >= '400000' order by as_eje, as_per, as_asi;



select t.*, t.rowid from ccmaes t where cc_importe = 43468.94;






-- Se dejan los prepagos con saldo 0
select t.*, t.rowid from ccmaes t where cc_emp = 40 and cc_cuenta = '437010301127' and cc_saldo > 0 ;

-- Se duplica los apuntes en el DIAG y se actualizan los datos.
select t.*, t.rowid from diag t where dg_emp = '40' and dg_plan = 'A' and dg_eje = 20 and dg_per = 6 and dg_asi = 400009;

select t.*, t.rowid from asto t where as_emp = 50 and as_plan = 'A' and as_eje = 20 and as_per = 6 and as_asi >= 500001;

select t.*, t.rowid from diag t where dg_emp = 50 and dg_plan = 'A' and dg_eje = 20 and dg_per = 6 and dg_asi > 500000;

select t.*, t.rowid from diag t where  dg_plan = 'A' and dg_eje = 20 and dg_imp = 8240;





select * from diag where dg_emp = 40 and dg_plan = 'A' and dg_eje = 20 and dg_per = 6 and dg_asi = '400001';

select cc_emp, cc_numero, sum(cc_saldo) from ccmaes where  cc_cuenta = '437010301127' and cc_saldo > 0 group by cc_emp, cc_numero;

select *
from diag
where dg_emp = 50 and dg_eje = 20 and dg_cg like '791%';



select * from diag where dg_emp = 50 and dg_plan = 'A' and dg_eje = 20 and dg_per = 5 and dg_asi = 500001;



select t.*, t.rowid from ccmaes t where cc_emp = :company and cc_numero = :numero



select *
from cuentas
where 7ct_emp = :company and ct_cg = :cuenta;