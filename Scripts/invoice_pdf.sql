select distinct in_inv_num                  q0_invnum,
                      trunc(decode(nvl(inv_byArrival,'Y'),'N', in_arrival, in_depart),'MONTH')                      q0_period,
                      ho_hotel                       q0_hotelcode,
                      ch_charter                    q0_charter,
          to_char(in_inv_date,'MONTH DD , YYYY') q0_invdate,
                      upper(ho_desc) ||' ('||ho_hotel||' )' q0_invhotel,
          ch_charter||', '||ch_charter||' Serial '||in_serial   q0_invchar,
          upper(op_name)        q0_invname,
          upper(op_address_1)     q0_invadd1,
          upper(op_address_2)     q0_invadd2,
          upper(op_address_3)     q0_invadd3,
          upper(op_taxid)     q0_taxid,
                      upper(nvl(op_inv_currency,'USD')) q0_invCurrency,
                      decode(in_group, null ,' ', 'GROUP CODE: '|| in_group) q0_group,
                      nvl(advertising_discount,0) advertising_discount
from rinvoice, rshotel, rscharter, rsopecharter, rsoperator
where
          (    
               (:hotelparam <> 'ALL'  and in_hotel = :hotelparam) or (:hotelparam = 'ALL' and  in_hotel <> :hotelparam )
          )  
   and in_hotel = ho_hotel
   and ch_hotel = in_hotel
   and ch_charter = in_wholes
   and in_inv_num  =  to_char(:invoiceparamf) 
   and oc_charter = in_wholes
   and op_id = oc_operator