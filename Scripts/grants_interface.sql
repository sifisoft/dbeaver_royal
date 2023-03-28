
select *
from rstrans_info


alter table rstrans_info add trans_table varchar2(40)

select t.*, t.rowid
from rstrans_info t

select * from rstrans_sens


/*
    SENS
*/
create public synonym rstrans_sens for rstrans@cun_sens

select * from rstrans@cun_sens

create public synonym rstrans_sens for rstrans@cun_sens

select * from rstrans_sens