


execute genVacationExpress_xls('10-feb-18','17-feb-18')

execute genVacationExpress_xls


select *
from rsoperator
where op_name like 'TRAVEL%';


create directory EXPRESS as  '/logs/express';

grant all on direcotory express to public;

grant write on directory express to public; 

grant all on directory express to public;

execute genVacationExpress_xls