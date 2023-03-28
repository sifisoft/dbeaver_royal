/* Compares Balancen vs. DIAG */



select to_char(ban_d,'999,999,999.09'), to_char(ban_h,'999,999,999.09'), ban_h-ban_d
from balancen
where ban_emp = 60 and ban_plan = 'A' and ban_eje = 16 and ban_per = 11 and ban_cg = '572010101001'
;

select sum(decode(dg_dh,'D',dg_imp,0)) D,
       sum(decode(dg_dh,'H',dg_imp,0)) H
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 16 and dg_per = 11 and dg_cg = '572010101001'