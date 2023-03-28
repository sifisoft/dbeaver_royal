

select OP_ID, OP_NAME, OP_ADDRESS_1, OP_ADDRESS_2, OP_COUNTRY, co_desc, OP_LOGO, OP_PASSWORD, INV_FAX, INV_EMAIL, INV_PRINTER, INV_METHOD, INV_BYARRIVAL, INV_DAYSAFTER, INVMEDIA_ID, MARKTSEG_ID, ADVERTISING_DISCOUNT, PROMPTPAYMENT_DISCOUNT, INVOICE_BELLMAID, OP_CREDITCARD, OP_CREDITCARD_NUMBER, OP_CREDITCARD_HOLDER, OP_CREDITCARD_EXPMONTH, OP_CREDITCARD_EXPYEAR, OP_GUARANTEE, OP_REVENUE_GROUP, OP_MARKET, OP_CONTRACT_EMAIL, OP_CONTRACT_METHOD, OP_BASED_CODE, OP_CONTRACT_CONTACT, OP_ADEMDUM_CONTACT, OP_ADEMDUM_EMAIL, OP_ADVERTISING_ACCOUNT, OP_ISCATALOG, OP_PHONE, OP_FAX, OP_GLOBALIA_REP, OP_REQUIRE_VOUCHER, OP_SEARCH_ONLY, OP_ID_NAVISION, OP_SHORT_NAME, OP_TAXID, OP_ADDRESS_3, OP_INV_CURRENCY, OP_RES_CURRENCY, OP_RAZON_SOCIAL, OP_PROFORMA, OP_ACCOUNT_BASE, OP_ADDRESS_4, OP_ID_BASE, OP_BLOCKED, OP_RATESINTERFACE_START, OP_RATE_INTERFACE, OP_RATE_INTERFACE_CODE, OP_SELL_TYPE, OP_HBSI, OP_CHARGE_CC, OP_CONTRACT_COUNTRY, OP_COMPANY, OP_DIRECT_CHANNEL, OP_MOD_U, OP_MOD_D, OP_INV_PERBOOKING, ch_charter, ch_hotel, ch_utl, ch_market, ch_allinc, ch_inp_user, ch_inp_date 
from rsoperator, rsopecharter, rscharter, rscountry, rsciudad
where   op_id = oc_operator
    and oc_charter = ch_charter
    and exists (
        select 1
        from rsmaes
        where ma_arrival >= '01-jan-20'
            and ma_hotel = ch_hotel
            and ma_charter = ch_charter
    )
    and co_country (+) = op_country
    and ci_country (+) = op_country
    and ci_city (+) = op_city
order by op_id, ch_charter, ch_hotel;    




select *
from rscountry;

select *
from rsciudad;

select * from cat where table_name like '%CIT%';