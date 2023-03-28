CREATE OR REPLACE procedure HOTEL.refreshRSAVAILABLE_SUM_TRG_Avalon (pIniDate date, pEndDate date) is
vPivote   date;
vDays     number;
i         number := 1;
vMarket1  varchar2(20) := 'NAM';
vMarket2  varchar2(20) := 'NAM';
err_msg   varchar2(1024);
vIniDate  date;
begin
        vIniDate := pIniDate;
        if vIniDate < to_date('7-sep-22','dd-mon-yy') then
            vIniDate := to_date('7-sep-22','dd-mon-yy');
        end if;
        
        insert into rsmaes_avalon_temp
        (MA_HOTEL, MA_RESERV, MA_LINE, MA_CHARTER, MA_SUBCHAR, MA_GROUP, MA_COUNTRY, MA_CITY, MA_ADRESS1, MA_ADRESS2, MA_GUEST, MA_VIP, MA_SOURCE, MA_CONT_N, MA_CONT_T, MA_ARRIVAL, MA_DEPART, MA_NITES, MA_ARR_TIME, MA_FLIGHT, MA_CARRIER, MA_ROOM, MA_RATE, MA_ADULT, MA_CHILD, MA_INFANT, MA_PLAN_1, MA_PLAN_2, MA_PACKAGE, MA_FIRST, MA_REM_USER, MA_REM_SYS, MA_INP_U, MA_INP_D, MA_INP_T, MA_CAN_D, MA_CAN_U, MA_CAN_T, MA_CAN_C, MA_MOD_U, MA_MOD_D, MA_MOD_T, MA_TRANS, MA_ROOMING, MA_VOUCHER, MA_DUE_TOT, MA_DEP_REC, MA_DEP_TOT, MA_AGCY_CNF, MA_SPECIAL, MA_A_RATE, MA_ROOM_NUM, MA_PREV_HOTEL, MA_PREV_RESERV, MA_CRS, MA_PEN_AGEN, MA_DIVISA, MA_MAYORISTA, MA_LAST_N, MA_FIRST_N)
        select MA_HOTEL, MA_RESERV, MA_LINE, MA_CHARTER, MA_SUBCHAR, MA_GROUP, MA_COUNTRY, MA_CITY, MA_ADRESS1, MA_ADRESS2, MA_GUEST, MA_VIP, MA_SOURCE, MA_CONT_N, MA_CONT_T, MA_ARRIVAL, MA_DEPART, MA_NITES, MA_ARR_TIME, MA_FLIGHT, MA_CARRIER, MA_ROOM, MA_RATE, MA_ADULT, MA_CHILD, MA_INFANT, MA_PLAN_1, MA_PLAN_2, MA_PACKAGE, MA_FIRST, MA_REM_USER, MA_REM_SYS, MA_INP_U, MA_INP_D, MA_INP_T, MA_CAN_D, MA_CAN_U, MA_CAN_T, MA_CAN_C, MA_MOD_U, MA_MOD_D, MA_MOD_T, MA_TRANS, MA_ROOMING, MA_VOUCHER, MA_DUE_TOT, MA_DEP_REC, MA_DEP_TOT, MA_AGCY_CNF, MA_SPECIAL, MA_A_RATE, MA_ROOM_NUM, MA_PREV_HOTEL, MA_PREV_RESERV, MA_CRS, MA_PEN_AGEN, MA_DIVISA, MA_MAYORISTA, MA_LAST_N, MA_FIRST_N
        from rsmaes_avalon
        where   ma_can_d is null
            and trunc(ma_depart-1) >= vIniDate
            and trunc(ma_arrival)  <= pEndDate;
        
        
        delete from rsavailable_sum_trg_avalon
        where av_date between vIniDate and pEndDate;
            
        vPivote := trunc(vIniDate);
        vDays   := trunc(pEndDate) - trunc(vIniDate);
        --insert into kkk values ('iniDate= '|| pIniDate ||' endDate='||pEndDate||' vDays='||vDays);
        for i in 0..vDays loop
            begin
                --insert into kkk values('i: ' || vDays || ' pivote: '||vPivote);
                insert into rsavailable_sum_trg_avalon
                (av_hotel, av_date, av_charter, av_market, av_res, av_allotment, av_total, av_at_dt, av_at_ay, av_adult, av_child, av_arrivals, av_departures, av_total_account_cur, av_market_rn)
                select unique ma_hotel av_hotel,
                        vPivote av_date,
                         ma_charter av_charter,
                         ma_mayorista,
                         sum(1) av_res,
                         99  av_allotment,
                         round(sum((convertToUSD(ma_inp_d, nvl(ma_divisa,'USD'), ma_due_tot) /(decode(ma_nites,null,1,0,1,ma_nites)))),2) av_total,
                         0 av_at_dt,
                         0 av_at_ay,
                         sum(nvl(ma_adult,0)) av_adult,
                         sum(nvl(ma_child,0)) av_child,
                         0,
                         0,
                         0 av_total_account_cur,
                         ma_mayorista 
                from rsmaes_avalon_temp 
                where ma_can_d is null
                    and vPivote between ma_arrival and ma_depart-1
                group by
                    ma_hotel,
                    vPivote,
                    ma_charter,
                    ma_mayorista
                order by ma_hotel, ma_charter;
                
            exception when others then raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
            end;
           vPivote := vPivote + 1;
        end loop;
        --insert into kkk values ('finalDate= '|| (vPivote-1));
end;
/