


select op_market, op_contract_country, op_country, op_id, op_name, decode(inv_method,'AUT','Y',null) inv_automatic,  decode(op_proforma,'Y','Y',null) proforma, decode(inv_byarrival,'Y','Y',null) Inv_byArrival
from rsoperator
where nvl(op_market,'X') in ('MEX')
order by op_market, op_country, op_name

