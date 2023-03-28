


execute genTravelBrands_xls('10-feb-18','17-feb-18')

execute genTravelBrands_xls
        


select *
from rsoperator
where op_name like 'TRAVEL%';


create directory TRAVELBRANDS as  '/logs/travelBrands';

grant all on directory TRAVELBRANDS to public;

