
execute travProduction;

rscancelled_usd

rscxl_statistics

select * from freserva_hoteles where rv_mayorista = 'DIR';


select *
from contamenu
--where parent_id = 2003
order by optionid, parent_id;

insert into contamenu
values (200320,2003, 'http://crs.travamerica.com/win/oas/InvoicingUser.main?usr=','Billers production',null);



select sum(decode(dg_dh,'D',dg_imp,0)) - sum(decode(dg_dh,'H',dg_imp,0))
from diag
where dg_emp = 60 and dg_plan = 'A' and dg_eje = 17 and dg_per = 0;



select *
from TravMenu;


select *
from contauser;

insert into contauser
values ('JACORONADO','oasroyal71;','Juan Antonio Coronado', 'A',null);

commit;

