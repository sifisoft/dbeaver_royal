

delete from rsmaes a
where exists ( select 1 from rsmaes@production b where a.ma_hotel = b.ma_hotel and a.ma_reserv = b.ma_reserv and (trunc(ma_can_d) >= trunc(sysdate-1) or trunc(ma_mod_d) >= trunc(sysdate-1) or trunc(ma_inp_d) >= trunc(sysdate-1))  )
/
commit
/
delete from rsmanames a
where exists (  select 1 from rsmaes@production b where a.mn_hotel = b.ma_hotel and a.mn_reserv = b.ma_reserv and (trunc(ma_can_d) >= trunc(sysdate-1) or trunc(ma_mod_d) >= trunc(sysdate-1) or trunc(ma_inp_d) >= trunc(sysdate-1)) )
/
commit
/
insert into rsmaes
select *
from rsmaes@production 
where trunc(ma_can_d) = trunc(sysdate-1) or trunc(ma_mod_d) = trunc(sysdate-1) or trunc(ma_inp_d) = trunc(sysdate-1)
/
commit
/
insert into rsmanames
select * 
from rsmanames@production a
where exists 
(
select 1 
from rsmaes@production b
where  where a.mn_hotel = b.ma_hotel and a.mn_reserv = b.ma_reserv and (trunc(ma_can_d) >= trunc(sysdate-1) or trunc(ma_mod_d) >= trunc(sysdate-1) or trunc(ma_inp_d) >= trunc(sysdate-1))
)
/
commit
/