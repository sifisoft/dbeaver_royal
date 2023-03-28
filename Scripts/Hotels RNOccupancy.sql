


select * from cat where table_name like '%HOTEL%' and table_type = 'TABLE' ORDER BY 1;

SELECT t.*, t.rowid 
FROM rshotel_report t
where hr_nombre like 'COMPLEJO%';

select *
from rshotel
where ho_hotel in ('05','06','13');


select dg_per Month, to_char(sum(dg_imp),'999,999,999.09') total
from diag
where dg_emp in ('50','40') and dg_eje = 22 and (dg_cg like '70005%' or dg_cg like '70013%' or dg_cg like '70009%')  and dg_dh = 'H'
group by dg_per
order by dg_per


select *
from diag
where dg_emp in ('50','40') and dg_eje = 22 and (dg_cg like '70005%' or dg_cg like '70013%' or dg_cg like '70009%')  and dg_dh = 'H'
order by dg_emp, dg_per, dg_asi



select in_mayorista, count(*)
from rinvoice
where in_inv_num is not null and in_inv_num != '0000000' and in_arrival between '01-oct-22' and '31-oct-22'
    and not exists (
        select 1
        from rsmaes
        where ma_reserv = in_reserv
            and ma_rem_sys = 'NO SHOW'
    )
group by in_mayorista
order by 1;


select *
from rinvoice
where in_inv_num is null
order by in_arrival, in_hotel, in_wholes