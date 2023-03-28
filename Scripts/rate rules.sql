
execute executeRateRule(:rule,'test')

executeRateRule

executePendingRules

rscontract_pckg


select * from rsrates where  rt_public_id=6072 and rt_rule_id=267391;

select t.*, t.rowid from rspublicRates t where pr_id = :rateID 

select t.*, t.rowid from rsRateRules t where rr_public_id = :rateDI --and rr_id = :rule  
order by rr_id 

select * from rsRates

select * from rsRates where rt_rule_id = :rule;



-- New User

select t.*, t.rowid from Rsrateuser t;
 

select t.*, t.rowid from rsRateRules t



select t.*, t.rowid from rsRateUser_options t
where ro_user = 'demo'

insert into rsRateUser_options
select 'gcastillo',ro_option
from rsRateUser_options
where ro_user = 'demo'



select t.*, t.rowid
from rsRateMenu t


select * 
from rsroom

insert into rsroom
select '99',ro_room, ro_desc, ro_roth, ro_avail, ro_block, ro_order, ro_default, ro_cont_def, ro_cont_des, ro_cost, ro_grand
from rsroom
where ro_hotel = '02'



hbsi