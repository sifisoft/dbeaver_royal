
CREATE OR REPLACE package HOTEL.OasisInterface is
    procedure readHotel(pHost in varchar2);
end;
/

CREATE OR REPLACE package body HOTEL.OasisInterface is

    type vRefCursor is ref cursor;

    function getTravHotel(pCancunHotel in varchar2) return varchar2 is
    cursor c1(xCancunHotel varchar2) is
    select *
    from rshotel
    where to_number(ho_hotel_cancun) = to_number(xCancunHotel);
    vc1     c1%rowtype; 
    begin
        open c1(pCancunHotel);
        fetch c1 into vc1;
        close c1;
        
        return vc1.ho_hotel;
    end;



    function getCancunHotel(pTravHotel in varchar2) return varchar2 is
    cursor c1(xTravHotel varchar2) is 
    select *
    from rshotel
    where to_number(ho_hotel) = to_number(xTravHotel);
    vc1     c1%rowtype;
    begin
        open c1(pTravHotel);
        fetch c1 into vc1;
        close c1;
        
        return vc1.ho_hotel_cancun;
    end;


    function fillRsmaes(pOldRsmaes in rsmaes%rowtype, pMares Mares%rowtype) return Rsmaes%rowtype is
    vRsmaes     rsmaes%rowtype; 
    begin
        vRsmaes.ma_hotel := getTravHotel(pMares.mr_hotel);
        vRsmaes.ma_charter := pMares.mr_agencia;
        vRsmaes.ma_subchar := pMares.mr_agencia;
        vRsmaes.ma_rate := '01';
        vRsmaes.ma_vip := pMares.mr_vip;
        vRsmaes.ma_reserv := pMares.mr_reserva;
        vRsmaes.ma_country := pMares.mr_pais;
        vRsmaes.ma_room_num := substr(pMares.mr_habi,1,4);
        vRsmaes.ma_arrival := pMares.mr_llegada;
        vRsmaes.ma_depart := pMares.mr_salida;
        vRsmaes.ma_nites := pMares.mr_noches;
        vRsmaes.ma_adult := pMares.mr_adulto;
        vRsmaes.ma_child := pMares.mr_menor;
        vRsmaes.ma_infant := pMares.mr_bebe;
        vRsmaes.ma_room := pMares.mr_tipo_hab;
        vRsmaes.ma_plan_1 := pMares.mr_plan_1;
        vRsmaes.ma_plan_2 := pMares.mr_plan_2;
        vRsmaes.ma_package := pMares.mr_paquete;
        vRsmaes.ma_due_tot := pMares.mr_importe;
        vRsmaes.ma_divisa := pMares.mr_moneda;
        vRsmaes.ma_rem_user := pMares.mr_notas;
        vRsmaes.ma_group := pMares.mr_grupo;
        vRsmaes.ma_voucher := nvl(pOldRsmaes.ma_voucher, pMares.mr_voucher);
        vRsmaes.ma_source := pMares.mr_source;
        vRsmaes.ma_inp_d := nvl(nvl(pOldRsmaes.ma_inp_d, pMares.mr_cap_f), trunc(sysdate));
        vRsmaes.ma_inp_t := to_char(sysdate,'HH24MI');
        vRsmaes.ma_inp_u := nvl(pOldRsmaes.ma_inp_u, 'OASIS');
        vRsmaes.ma_mod_u := 'OASIS';
        vRsmaes.ma_mod_d := trunc(sysdate);
        vRsmaes.ma_mod_t := to_char(sysdate,'HH24MI');
        vRsmaes.ma_junior := pMares.mr_junior;

        return vRsmaes;
    end ;

    function getTotal (pRsmaes in rsmaes%rowtype, pReserv in varchar2) return number is
    cursor cpromo (pHotel varchar2,pCharter varchar2, pArrival date, pNights number,pInpDate date) is
    select nvl(pr_promo,0) promo
    from hotel.rspromo_new
    where pr_hotel   = photel
        and pr_charter = pcharter
        and pArrival between pr_start_trav and pr_end_trav
        and nvl(pInpDate,trunc(sysdate)) between pr_start and pr_end
        and pr_nites  <= pNights;
        
    OutIniDate     date;
    OutIndividual1 rsmaes.ma_ind1%type;
    OutDoble1      rsmaes.ma_dob1%type;
    OutTriple1     rsmaes.ma_tri1%type;
    OutQuad1       rsmaes.ma_qua1%type;
    OutAdit1       rsmaes.ma_adition1%type;
    OutEndDate1    date;
    OutIndividual2 rsmaes.ma_ind2%type;
    OutDoble2      rsmaes.ma_dob2%type;
    OutTriple2     rsmaes.ma_tri2%type;
    OutQuad2       rsmaes.ma_qua2%type;
    OutAdit2       rsmaes.ma_adition2%type;
    OutEndDate2    date;
    OutIndividual3 rsmaes.ma_ind3%type;
    OutDoble3      rsmaes.ma_dob3%type;
    OutTriple3     rsmaes.ma_tri3%type;
    OutQuad3       rsmaes.ma_qua3%type;
    OutAdit3       rsmaes.ma_adition3%type;
    OutEndDate3    date;    
    
    vTotal          number := 0;
    vPromotion  number := 0;
    begin
        open cpromo(pRsmaes.ma_hotel, pRsmaes.ma_charter, pRsmaes.ma_arrival, pRsmaes.ma_nites, null);
        fetch cpromo into vPromotion;
        close cpromo;
        vPromotion := nvl(vPromotion,0);
        pckg_new_gettotal.NewMRFuncTotDue
                                (
                                   pRsmaes.ma_hotel,
                                   pRsmaes.ma_charter,
                                   pRsmaes.ma_charter,
                                   pRsmaes.ma_arrival,
                                   pRsmaes.ma_depart - vPromotion,
                                   '01',
                                   'ROH',
                                   null, -- pMares.mr_plan_1,
                                   pRsmaes.ma_plan_2,
                                   pRsmaes.ma_adult,
                                   pRsmaes.ma_child,
                                   pRsmaes.ma_infant,
                                   pRsmaes.ma_package,
                                   'CM',
                                   pReserv,
                                   vTotal,
                                   OutIniDate,
                                   OutIndividual1,
                                   OutDoble1,
                                   OutTriple1,
                                   OutQuad1,
                                   OutEndDate1,
                                   OutIndividual2,
                                   OutDoble2,
                                   OutTriple2,
                                   OutQuad2,
                                   OutEndDate2,
                                   OutIndividual3,
                                   OutDoble3,
                                   OutTriple3,
                                   OutQuad3,
                                   OutEndDate3,
                                   OutAdit1,
                                   OutAdit2,
                                   OutAdit3,
                                   TRUE) ;
    return nvl(vTotal,0);
    end;

    
    -- Procesa CXL de mercados de travamerica... 
    procedure   processCXL(pOldRsmaes in rsmaes%rowtype, pMares in mares%rowtype, pTravMarket in boolean) is
    vma_rem_sys         rsmaes.ma_rem_sys%type; 
    vma_can_c             rsmaes.ma_can_c%type;
    begin
    
        vma_rem_sys := 'HOTEL CANCELATION';
        vma_can_c := 'CM';
        if trunc(pOldRsmaes.ma_arrival) = trunc(pMares.mr_can_f) and ptravMarket then
                vma_rem_sys := 'NO SHOW';
        end if;
        
        -- Only keep record of changes when is our market.... 
        if pTravMarket then
            vma_can_c := 'AU';
            if trunc(pOldRsmaes.ma_arrival) = trunc(pMares.mr_can_f) then
                    insert into hotel.rsmaesmo
                    (mm_hotel, mm_reserv, mm_date, mm_time, mm_user, mm_field, mm_before, mm_new,mm_process, mm_reason)
                    values(pOldRsmaes.ma_hotel, pOldRsmaes.ma_reserv, trunc(nvl(pMares.mr_can_f,sysdate)), to_char(nvl(pMares.mr_can_f,sysdate), 'HH24MI'), 'OASIS',90,'','No Show','S', 'No_Show ... ' );    
            else
                insert into hotel.rsmaesmo
                (mm_hotel, mm_reserv, mm_date, mm_time, mm_user, mm_field, mm_before, mm_new,mm_process, mm_reason)
                values(pOldRsmaes.ma_hotel, pOldRsmaes.ma_reserv, trunc(nvl(pMares.mr_can_f,sysdate) ), to_char(nvl(pMares.mr_can_f,sysdate), 'HH24MI'), 'OASIS',3,'','Hotel Cancelation','S', 'Hotel Cancelation ' );
            end if;

            insert into hotel.rsmaesmo
            (mm_hotel, mm_reserv, mm_date, mm_time, mm_user, mm_field, mm_before, mm_new,mm_process, mm_reason)
            values(pOldRsmaes.ma_hotel, pOldRsmaes.ma_reserv, trunc(nvl(pMares.mr_can_f,sysdate)), to_char(nvl(pMares.mr_can_f,sysdate), 'HH24MI'), 'OASIS',90,'','No Show','S', 'No_Show ... ' );    
        end if;
        
        update hotel.rsmaes
        set ma_can_u = 'OASIS',
              ma_can_d = trunc(pMares.mr_can_f),
              ma_can_t  = trim(to_char(sysdate,'HH24MI')),
              ma_can_c = vma_can_c,
              ma_rem_sys = vma_rem_sys
         where ma_hotel = pOldRsmaes.ma_hotel 
            and ma_reserv = pOldRsmaes.ma_reserv;
            
    end;



    procedure  processNewBooking(pRsmaes in rsmaes%rowtype, travMarket in boolean) is 
    begin
           insert into hotel.rsmaes
                 (ma_hotel,ma_reserv,ma_charter,ma_subchar,ma_group,ma_country,
                 ma_city,ma_guest,ma_vip,ma_arrival,ma_nites,ma_depart,ma_adult,
                 ma_child,ma_infant,ma_room,ma_plan_1,ma_plan_2,
                 ma_package,ma_rem_sys,ma_inp_u,ma_inp_d,ma_inp_t,ma_rate,ma_voucher,ma_room_num,
                 ma_due_tot,ma_source,ma_reserv_nav, ma_divisa, ma_junior)
           values
                (pRsmaes.ma_hotel,pRsmaes.ma_reserv,pRsmaes.ma_charter,pRsmaes.ma_subchar,pRsmaes.ma_group,pRsmaes.ma_country,
                 null,pRsmaes.ma_guest,pRsmaes.ma_vip, pRsmaes.ma_arrival,pRsmaes.ma_nites,pRsmaes.ma_depart,pRsmaes.ma_adult,
                 pRsmaes.ma_child,pRsmaes.ma_infant,pRsmaes.ma_room,pRsmaes.ma_plan_1,pRsmaes.ma_plan_2,
                 pRsmaes.ma_package,'ADDED BY AUDIT','OASIS',pRsmaes.ma_inp_d,to_char(sysdate,'HH24MI'),pRsmaes.ma_rate,pRsmaes.ma_voucher,pRsmaes.ma_room_num,
                 pRsmaes.ma_due_tot,pRsmaes.ma_source,null, pRsmaes.ma_divisa, pRsmaes.ma_junior);    
    end; 


   procedure processUpdateMaesmo(pOldRsmaes in rsmaes%rowtype, pMares in mares%rowtype) is
   begin
                    if upper(nvl(ltrim(rtrim(pOldRsmaes.MA_REM_USER)),'X')) != upper(nvl(ltrim(rtrim(pMares.mr_notas)),'X'))
                    then
                       insert into hotel.rsmaesmo
                       (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                        mm_new,mm_process,mm_reason)
                       values
                           (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                           16,substr(pOldRsmaes.ma_rem_user,1,20),substr(pMares.mr_notas,1,20),'S','Audit Update...');
                    end if;

                    if nvl(pOldRsmaes.ma_room_num,'0000') != nvl(pMares.mr_habi,'0000')
                    then
                       insert into hotel.rsmaesmo
                       (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,
                        mm_before,mm_new,mm_process,mm_reason)
                       values
                           (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                           17,pOldRsmaes.ma_room_num,pMares.mr_habi,'S','Audit Update...');
                    end if;
                    
                    if pOldRsmaes.ma_arrival != pMares.mr_llegada
                    then
                       insert into hotel.rsmaesmo
                       (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,
                        mm_before,mm_new,mm_process,mm_reason)
                       values
                            (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                            2,pOldRsmaes.ma_arrival,pMares.mr_llegada, 'S','Audit Update...');
                    end if;
               --
               --  Change on number of nights
                   if pOldRsmaes.ma_nites != pMares.mr_noches
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                       mm_new,mm_process,mm_reason)
                      values
                          (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                          3,pOldRsmaes.ma_depart,pMares.mr_salida,'S','Audit Update...');
                   end if;

                   if pOldRsmaes.ma_adult != pMares.mr_adulto
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,
                       mm_before,mm_new,mm_process,mm_reason)
                      values
                            (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                            6,pOldRsmaes.ma_adult,pMares.mr_adulto,'S','Audit Update...');
                   end if;

                   if pOldRsmaes.ma_child != pMares.mr_menor
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,
                       mm_before,mm_new,mm_process,mm_reason)
                      values
                              (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                              7,pOldRsmaes.ma_child,pMares.mr_menor,'S','Audit Update...');
                   end if;


                   if pOldRsmaes.ma_room != nvl(pMares.mr_tipo_hab,'ROH')
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,
                       mm_before,mm_new,mm_process,mm_reason)
                      values
                            (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                            4, pOldRsmaes.ma_room,pMares.mr_tipo_hab,'S','Audit Update...');
                   end if;

                   if nvl(pOldRsmaes.ma_plan_1,'NON') != nvl(pMares.mr_plan_1,'NON')
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                       mm_new,mm_process,mm_reason)
                      values
                            (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                            9,pOldRsmaes.ma_plan_1,pMares.mr_plan_1,'S','Audit Update...');
                   end if;
                   
                   if nvl(pOldRsmaes.ma_plan_2,'NON') != nvl(pMares.mr_plan_2,'NON')
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                       mm_new,mm_process,mm_reason)
                      values
                          (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                          10, pOldRsmaes.ma_plan_2,pMares.mr_plan_2,'S','Audit Update...');
                   end if;

                   if nvl(pOldRsmaes.ma_package,'NONE') != nvl(pMares.mr_paquete,'NONE')
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                       mm_new,mm_process,mm_reason)
                      values
                            (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                            11,pOldRsmaes.ma_package,pMares.mr_paquete,'S','Audit Update...');
                   end if;
                   
                   if nvl(pOldRsmaes.ma_divisa,'XXX') != nvl(pMares.mr_moneda,'YYY')
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                       mm_new,mm_process,mm_reason)
                      values
                            (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                            99,pOldRsmaes.ma_divisa,pMares.mr_moneda,'S','Audit Update...');
                   end if;
                   

                   if pOldRsmaes.ma_voucher is null and ltrim(rtrim(pMares.mr_voucher)) is not null
                   then
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,mm_before,
                       mm_new,mm_process,mm_reason)
                      values
                          (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                          15, pOldRsmaes.ma_voucher,ltrim(rtrim(pMares.mr_voucher)),'S','Audit Update...');
                   end if;
   end;


    procedure processUpdateBooking(pOldRsmaes in rsmaes%rowtype, pNewRsmaes in rsmaes%rowtype, pMares in mares%rowtype,  travMarket in boolean) is
    cursor c1(xhotel in varchar2, xreserv in varchar2) is 
    select * from rsmaes where ma_hotel = xhotel and ma_reserv = xreserv;
    vReason             HOTEL.RSMAESMO.MM_REASON%type;
    vma_rem_sys     rsmaes.ma_rem_sys%type;
    vc1             c1%rowtype;
    begin

            -- Reactivation valida.. pues hubo una primer validacion al inicio del doit.
            if pMares.mr_status not in ('C','N') and pOldRsmaes.ma_can_d is not null then
                vma_rem_sys := 'Audit Reactivation';
                if travMarket then
                      vReason := 'Audit Reactivation...';
                      if upper(pOldRsmaes.ma_rem_sys) like 'NO SHOW%' then
                        vReason := 'Audit Reactivation, No Show';
                        vma_rem_sys := 'Audit ReactivationNS';
                      end if;
                              
                      insert into hotel.rsmaesmo
                      (mm_hotel,mm_reserv,mm_date,mm_time,mm_user,mm_field,
                      mm_before,mm_new,mm_process,mm_reason)
                      values
                      (pOldRsmaes.ma_hotel,pOldRsmaes.ma_reserv,trunc(sysdate),to_char(sysdate,'HH24MI'),'OASIS',
                      99,pOldRsmaes.ma_can_d,null,'S',vReason);
                end if;                            
                    
                update rsmaes
                set ma_cancel = null,
                      ma_can_d = null,
                      ma_can_u = null,
                      ma_can_t = null,
                      ma_can_c = null,
                      ma_rem_sys = vma_rem_sys
                where  ma_hotel = pOldRsmaes.ma_hotel 
                    and ma_reserv = pOldrsmaes.ma_reserv;
                            
            end if;

            -- llena maesmo
            if  travMarket then
                    processUpdateMaesmo(pOldRsmaes, pMares);                
            end if;
            
            update hotel.rsmaes
            set ma_charter      = pNewRsmaes.ma_charter,
                 ma_subchar     = pNewRsmaes.ma_subchar,
                 --ma_vip            = pNewRsmaes.ma_vip,
                 ma_country     = pNewRsmaes.ma_country,
                 ma_room_num   = pNewRsmaes.ma_room_num,
                 ma_arrival     = pNewRsmaes.ma_arrival,
                 ma_depart    = pNewRsmaes.ma_depart,
                 ma_nites      = pNewRsmaes.ma_nites,
                 ma_adult     = pNewRsmaes.ma_adult,
                 ma_child     = pNewRsmaes.ma_child,
                 ma_room    = pNewRsmaes.ma_room,
                 ma_plan_1     = pNewRsmaes.ma_plan_1,
                 ma_plan_2     = pNewRsmaes.ma_plan_2,
                 ma_package    = pNewRsmaes.ma_package,
                 ma_due_tot    = pNewRsmaes.ma_due_tot,
                 ma_mod_u      = pNewRsmaes.ma_mod_u,
                 ma_mod_t      = pNewRsmaes.ma_mod_t,
                 ma_mod_d      = pNewRsmaes.ma_mod_d,
                 ma_divisa     = pNewRsmaes.ma_divisa,
                 ma_junior      = pNewRsmaes.ma_junior
          where ma_hotel  = pOldRsmaes.ma_hotel
            and ma_reserv = ltrim(rtrim(upper(pOldRsmaes.ma_reserv)));
            
          -- Si hay movimientos entre fases entonces hay que cancelar la original
          -- y eso se distingue cuando el hotel original es diferente al rv_hotel
          --
          /*
          if (to_number(pMares.mr_hotel) != to_number(nvl(pMares.mr_hotel_orig,0)) ) then
            open c1( getTravHotel(pMares.mr_hotel_orig), pMares.mr_reserva);
            fetch c1 into vc1;
            close c1;
            
            -- encontrao el registro entonces hay que cancelaro..
            if vc1.ma_hotel is not null and vc1.ma_can_d is null then
                update rsmaes
                set ma_can_d = trunc(sysdate),
                    ma_can_u = 'OASIS',
                    ma_can_t = to_char(sysdate,'HH24MI'),
                    ma_rem_sys = 'Bumping to '||pMares.mr_hotel||' '||pMares.mr_reserva
                where   ma_hotel = pMares.mr_hotel_orig
                    and ma_reserv = pMares.mr_reserva;                    
            end if;
            
          end if;
          */  
    end; 
    
    procedure processAgency(pMares in mares%rowtype) is
    cursor c1(xhotel in varchar2, xcharter in varchar2) is 
    select 1 conteo
    from rscharter
    where  ch_hotel = xhotel 
        and ch_charter = xcharter;
        
    vrscharter  rscharter%rowtype;
    vc1     c1%rowtype;
    begin
            open c1(getTravHotel(pMares.mr_hotel), pMares.mr_agencia);
            fetch c1 into vc1;
            if c1%notfound then
                vrscharter.ch_hotel := getTravHotel(pMares.mr_hotel);
                vrscharter.ch_charter := pMares.mr_agencia;
                vrscharter.ch_name := pMares.mr_agencia;
                vrscharter.ch_adress_1 := pMares.mr_pais;
                vrscharter.ch_adress_2 := pMares.mr_pais;
                vrscharter.ch_country := pMares.mr_pais;
                vrscharter.ch_city := pMares.mr_pais;
                vrscharter.ch_contact := 'CANCUN';
                vrscharter.ch_roth := 'Y';
                vrscharter.ch_guaran := 0;
                vrscharter.ch_iva := 0;
                vrscharter.ch_tip := 0;
                vrscharter.ch_pri_inv := 'N';
                vrscharter.ch_utl :=  pMares.mr_mayorista;
                vrscharter.ch_market := 'MEX';
                case pMares.mr_mayorista 
                    when 'AME' then vrscharter.ch_market := 'NAM';
                    when 'EUR' then vrscharter.ch_market := 'EUR';
                    when 'SUD' then vrscharter.ch_market := 'SUD';
                    else vrscharter.ch_market := 'MEX';    
                end case;
                vrscharter.ch_allinc := 'Y';
                
                insert into rscharter
                (ch_hotel, ch_charter, ch_name, ch_adress_1, ch_adress_2, ch_country, ch_city, ch_contact, ch_roth, ch_guaran, ch_iva, ch_tip, ch_pri_inv, ch_utl, ch_market)
                values (vrscharter.ch_hotel, vrscharter.ch_charter, vrscharter.ch_name, vrscharter.ch_adress_1, vrscharter.ch_adress_2, vrscharter.ch_country, vrscharter.ch_city, vrscharter.ch_contact, vrscharter.ch_roth, vrscharter.ch_guaran,
                           vrscharter.ch_iva, vrscharter.ch_tip, vrscharter.ch_pri_inv, vrscharter.ch_utl, vrscharter.ch_market);
                
            end if; 
            close c1;    
    end;


    procedure processCunMarkets (pMares in mares%rowtype, pError out varchar2, pRem out varchar2) is
    cursor c1(xHotel varchar2, xReserv varchar2) is
    select * from rsmaes where ma_hotel = xHotel and ma_reserv = xReserv;
    
    vOldRsmaes     rsmaes%rowtype;
    vNewRsmaes    rsmaes%rowtype;
    isTravMarket        boolean := false;       -- Mercado Cancun
    InsNames        boolean := true;    
    begin
            open c1(getTravHotel(pMares.mr_hotel), pMares.mr_reserva);
            fetch c1 into vOldRsmaes;
            close c1;
            vNewRsmaes := fillRsmaes(vOldRsmaes, pMares);
            
            if vNewRsmaes.ma_hotel is null then
                pError := 'Unable to process Hotel NULL';
                return;
            end if;

            if pMares.mr_status in ('C') then
                    processCXL(vOldRsmaes, pMares, isTravMarket);
                    return;
            end if;
            
            -- Is a new booking ?
            if vOldRsmaes.ma_hotel is null then
                processNewBooking(vNewRsmaes, isTravMarket);
                processAgency(pMares);
            else
                processUpdateBooking(vOldRsmaes, vNewRsmaes, pMares, isTravMarket);
            end if;            

          InsNames := FuncValRSMANAMES(vNewRsmaes.ma_hotel,pMares.mr_reserva,nvl(pMares.mr_apellido_1,'TBA'),
                nvl(pMares.mr_nombre_1,'TBA'),pMares.mr_apellido_2,pMares.mr_nombre_2,pMares.mr_apellido_3,
                pMares.mr_nombre_3, pMares.mr_apellido_4,pMares.mr_nombre_4, trunc(sysdate),
                to_char(sysdate,'HH24MI'),'HOTEL','S','HOTEL INTERFACE', TRUE);
    
    end;





    /* 
    Procesa los mercados que maneja Trav.
    */
    procedure processTravMarkets (pMares in mares%rowtype, pError out varchar2, pRem out varchar2) is
    cursor c1(xHotel varchar2, xReserv varchar2) is
    select * from rsmaes where ma_hotel = xHotel and ma_reserv = xReserv;
    
    cursor c2(xCharter varchar2) is 
    select 1 from rsopecharter where oc_charter = xCharter and oc_operator in ('FRTUIAI','PGSAI', 'REDSEAI'); 
    
    cursor c3(xHotel varchar2, xGroup varchar2) is 
    select gr_rate 
    from hotel.rsgroups
    where gr_group = xGroup   and gr_hotel = xHotel;
    
    cursor c4 (pHotel varchar2,pCharter varchar2) is
        select nvl(min(cg_type),'CM') cg_type              --  gets guest Type
        from hotel.rschagues
        where cg_charter = pCharter
        and cg_hotel     = pHotel;
        
    cursor c5(xcharter varchar2) is
        select op_inv_currency
        from rsoperator, rsopecharter
        where oc_charter = xcharter
        and oc_operator = op_id;        
       
    vOldRsmaes     rsmaes%rowtype;
    vNewRsmaes    rsmaes%rowtype;
    vTravHotel      rshotel.ho_hotel%type;
    vRecalculate     boolean := false;
    vTotal              rsmaes.ma_due_tot%type;
    vc2                 c2%rowtype;
    vc3                 c3%rowtype;
    vc4                 c4%rowtype;
    isTravMarket   boolean := true;
    InsNames        boolean := true;
    vOp_inv_currency    rsoperator.op_inv_currency%type;
    begin
            vTravHotel := getTravHotel(pMares.mr_hotel);
            open c1(vTravHotel, pMares.mr_reserva);
            fetch c1 into vOldRsmaes;
            close c1;
            vNewRsmaes := fillRsmaes(vOldRsmaes, pMares);
            
            if vOldRsmaes.ma_reserv is not null then   -- Update to a booking already in RSMAES then validate and get new total  
                if pMares.mr_mayorista != 'SUD' and trunc(sysdate) not between vOldRsmaes.ma_arrival and vOldRsmaes.ma_depart then
                    pError := 'Cancun cannot update outside the arrival and departure window for TravMarkets,  nothing done. '||vTravHotel||'-'||pMares.mr_reserva||' '||pMares.mr_mayorista||' '||pMares.mr_agencia;
                    return;
                end if;
                -- is a CXL and CXL recived send error... 
                if pMares.mr_status in ('C') and vOldRsmaes.ma_can_d is not null then
                    pError := 'Trying to CXL a booking already cancelled, nothing done date='||vTravhotel||'-'||pMares.mr_reserva||' '||pMares.mr_mayorista||' '||pMares.mr_agencia;
                    return;
                end if;
                -- is a CXL in the window date (see above) then do it and do nothing else...
                if pMares.mr_status in ('C') then
                    processCXL(vOldRsmaes, pMares, isTravMarket);
                    return;
                end if;
                if pMares.mr_status not in ('C') and vOldRsmaes.ma_can_d is not null then
                     -- No reactivar si esta cancelada por Accounting... 
                    if vOldRsmaes.ma_can_u = 'INV' then
                        pError := 'Trying to reactivate a booking which is CXL by accounting in RSMAES (Hotel bumping and we did not receive the movement?), nothing done hotel='||vTravHotel||'-'||pMares.mr_reserva||' '||pMares.mr_mayorista||' '||pMares.mr_agencia;
                        return;
                    end if;
                end if;
                
                if vOldRsmaes.ma_charter != vNewRsmaes.ma_charter then
                    pError := 'Cancun cannot update charter for TravMarkets, nothing done oldcharter='||vOldRsmaes.ma_charter||' newCharter='||vNewRsmaes.ma_charter;
                    return;
                end if;
                -- Calculate new total when change the dates or adults
                if vOldRsmaes.ma_arrival != vNewRsmaes.ma_arrival or vOldRsmaes.ma_depart != vNewRsmaes.ma_depart or vOldRsmaes.ma_adult != vNewRsmaes.ma_adult then
                    vRecalculate := true;
                end if;
            else   -- El hotel esta ingresando reservas de los mercados de  TravAmerica
                -- mandan a cancelar una reserva que no tenemos ????
                if pMares.mr_status in ('C') then
                     pError := 'Trying to cancel a booking which does not exists in RSMAES (Hotel bumping and we did not receive the movement?), nothing done '||vTravHotel||'-'||pMares.mr_reserva||' '||pMares.mr_mayorista||' '||pMares.mr_agencia;
                    return;
                end if;
                
                -- Calculate the new total for bookings that handle TravAmerica and not exists in RSMAES at this time.
                vRecalculate := true;
            end if;
            
            -- Check rate type;
            vNewRsmaes.ma_rate := '01';
            open c3(vTravHotel, pMares.mr_grupo);
            fetch c3 into vc3;
            close c3;
            vNewRsmaes.ma_rate := nvl(vc3.gr_rate,'01');
            
            -- Check Tipo Huesped
            vnewRsmaes.ma_guest := 'CM';
            open c4 (vNewRsmaes.ma_hotel, vNewRsmaes.ma_charter);
            fetch c4 into vc4;
            close c4;
            vnewRsmaes.ma_guest := nvl(vc4.cg_type,'CM');
            
            -- Exception when FRTUIAI, PGSAI, REDSEAI we must take what the hotel is returing since they are doing the invoicing.. only for 03  and 10
            if vNewRsmaes.ma_hotel in ('03','10')  then
                open c2(vNewRsmaes.ma_charter);
                fetch c2 into vc2;
                if  c2%found then
                    vRecalculate := false; 
                end if;
                close c2;
            end if;
            
            vNewRsmaes.ma_due_tot := vOldRsmaes.ma_due_tot;
            vNewRsmaes.ma_divisa := vOldRsmaes.ma_divisa;
            if vRecalculate then
                open c5 (vNewRsmaes.ma_charter);
                fetch c5 into vOp_inv_currency;
                close c5;
                
                vNewRsmaes.ma_due_tot := nvl(getTotal(vNewRsmaes, vOldRsmaes.ma_reserv),0);
                vNewRsmaes.ma_divisa := nvl(vOp_inv_currency,'USD');
            end if;           

            -- Is a new booking ?
            if vOldRsmaes.ma_hotel is null then
                vNewRsmaes.ma_inp_d := trunc(sysdate); -- para mercados Trav la fecha de modificacion es la del sistema para no peder rastro de las modificaciones hechas por el hotel..
                processNewBooking(vNewRsmaes, isTravMarket);
            else
                vNewRsmaes.ma_mod_d := trunc(sysdate);      -- para mercados Trav la fecha de modificacion es la del sistema para no peder rastro de las modificaciones hechas por el hotel..
                processUpdateBooking(vOldRsmaes, vNewRsmaes, pMares, isTravMarket);
            end if;            

          InsNames := FuncValRSMANAMES(vNewRsmaes.ma_hotel,pMares.mr_reserva,nvl(pMares.mr_apellido_1,'TBA'),
                nvl(pMares.mr_nombre_1,'TBA'),pMares.mr_apellido_2,pMares.mr_nombre_2,pMares.mr_apellido_3,
                pMares.mr_nombre_3, pMares.mr_apellido_4,pMares.mr_nombre_4, trunc(sysdate),
                to_char(sysdate,'HH24MI'),'HOTEL','S','HOTEL INTERFACE', TRUE);
            
    end;


    procedure dumpMares(pMares  mares%rowtype) is 
    begin
        dbms_output.put_line('mr_hotel= '||pMares.mr_hotel);
        dbms_output.put_line('mr_reserva= '||pMares.mr_reserva);
        dbms_output.put_line('mr_mayorista= '||pMares.mr_mayorista);
        dbms_output.put_line('mr_agencia= '||pMares.mr_agencia);
        dbms_output.put_line('mr_grupo= '||pMares.mr_grupo);
        dbms_output.put_line('mr_pais= '||pMares.mr_pais);
        dbms_output.put_line('mr_codpos= '||pMares.mr_codpos);
        dbms_output.put_line('mr_tipo_huesped= '||pMares.mr_tipo_huesped);
        dbms_output.put_line('mr_vip= '||pMares.mr_vip);
        dbms_output.put_line('mr_llegada= '||pMares.mr_llegada);
        dbms_output.put_line('mr_salida= '||pMares.mr_salida);
        dbms_output.put_line('mr_noches= '||pMares.mr_noches);
        dbms_output.put_line('mr_llegada_h= '||pMares.mr_llegada_h);
        dbms_output.put_line('mr_vuelo= '||pMares.mr_vuelo);
        dbms_output.put_line('mr_linea= '||pMares.mr_linea);
        dbms_output.put_line('mr_tipo_hab= '||pMares.mr_tipo_hab);
        dbms_output.put_line('mr_adulto= '||pMares.mr_adulto);
        dbms_output.put_line('mr_menor= '||pMares.mr_menor);
        dbms_output.put_line('mr_bebe= '||pMares.mr_bebe);
        dbms_output.put_line('mr_plan_1= '||pMares.mr_plan_1);
        dbms_output.put_line('mr_plan_2= '||pMares.mr_plan_2);
        dbms_output.put_line('mr_paquete= '||pMares.mr_paquete);
        dbms_output.put_line('mr_servicio= '||pMares.mr_servicio);
        dbms_output.put_line('mr_notas= '||pMares.mr_notas);
        dbms_output.put_line('mr_tarifa= '||pMares.mr_tarifa);
        dbms_output.put_line('mr_importe= '||pMares.mr_importe);
        dbms_output.put_line('mr_deposito= '||pMares.mr_deposito);
        dbms_output.put_line('mr_apellido_1= '||pMares.mr_apellido_1);
        dbms_output.put_line('mr_nombre_1= '||pMares.mr_nombre_1);
        dbms_output.put_line('mr_apellido_2= '||pMares.mr_apellido_2);
        dbms_output.put_line('mr_nombre_2= '||pMares.mr_nombre_2);
        dbms_output.put_line('mr_apellido_3= '||pMares.mr_apellido_3);
        dbms_output.put_line('mr_nombre_3= '||pMares.mr_nombre_3);
        dbms_output.put_line('mr_apellido_4= '||pMares.mr_apellido_4);
        dbms_output.put_line('mr_nombre_4= '||pMares.mr_nombre_4);
        dbms_output.put_line('mr_mayorista_cun= '||pMares.mr_mayorista_cun);
        dbms_output.put_line('mr_habi= '||pMares.mr_habi);
        dbms_output.put_line('mr_voucher= '||pMares.mr_voucher);
        dbms_output.put_line('mr_reserva_p= '||pMares.mr_reserva_p);
        dbms_output.put_line('mr_hotel_orig= '||pMares.mr_hotel_orig);
        dbms_output.put_line('mr_cap_f= '||pMares.mr_cap_f);
        dbms_output.put_line('mr_can_f= '||pMares.mr_can_f);
        dbms_output.put_line('mr_mod_f= '||pMares.mr_mod_f);
        dbms_output.put_line('mr_semaforo= '||pMares.mr_semaforo);
        dbms_output.put_line('mr_notas_hotel= '||pMares.mr_notas_hotel);
        dbms_output.put_line('mr_notas_central= '||pMares.mr_notas_central);
        dbms_output.put_line('mr_source= '||pMares.mr_source);
        dbms_output.put_line('mr_agency_conf= '||pMares.mr_agency_conf);
        dbms_output.put_line('mr_moneda= '||pMares.mr_moneda);                        
                                                
        
    end;

    /*
        Write hotel... 
    */
    procedure sendBookingHotel(pHotel in varchar2, pReserv in varchar2, pRstrans in rstrans%rowtype) is 

    cursor c0 (xHotel varchar2, xReserv varchar2) is
    select * from rsmaes
    where ma_hotel = xHotel
        and ma_reserv = xReserv;

    cursor c1(xhotel varchar2, xcharter varchar2) is
    select ch_allinc, ch_utl, ch_country, ch_nav_room
    from rscharter
    where   ch_hotel = xhotel
         and ch_charter = xcharter;

    cursor c2 (xhotel varchar2, xreserv varchar2) is
    select *
    from rsmanames
    where   mn_hotel = xhotel
          and mn_reserv = xreserv
    order by mn_sequence;


    cursor c3(xhotel varchar2, xcharter varchar2) is
    select nvl(ch_allinc, 'N') ch_allinc
    from rscharter
    where  ch_hotel = xhotel
        and ch_charter = xcharter;

    cursor cFitOtamex (pCharter varchar2) is
    select oc_operator,oc_charter,nvl(ota_mex,'N') ota_mex
    from hotel.rsopecharter,hotel.rsfitotamex
    where oc_charter = pCharter
        and oc_operator = ota_operator
        and nvl(ota_active,'N') = 'Y';


    cursor IsRedSeal (pHotel varchar2, pCharter varchar2) is
    select * from rscharter , rsopecharter
    where ch_hotel = pHotel 
        and ch_charter = pCharter 
        and ch_charter = oc_charter 
        and oc_operator in ('FRTUIAI','PGSAI','REDSEAI') ;

    cursor InMares (pHotel varchar2,pReserv varchar2) is
    select *
    from oasis.mares
    where mr_hotel = pHotel
        and mr_reserva = pReserv;

    cursor c4 (xHotel varchar2) is 
    select *
    from rshotel
    where ho_hotel = xHotel;
    
    cursor IsGroup (vCharter varchar2) is
    select * from rsopecharter 
    where oc_charter = vCharter
    and     oc_operator in ('GROUPS','SNOWSTD');
    
    vIsGroup      IsGroup%rowtype;
    GroupName   varchar2(8);
    vCharter       rsmaes.ma_charter%type;
    

    v0                  c0%rowtype;
    vc1                 c1%rowtype;
    vc2                 c2%rowtype;
    vc4                 c4%rowtype;
    vdummy          varchar2(2);
    vFitOtamex       cFitOtamex%rowtype;                                 -- 40
    vRedSeal          IsRedSeal%rowtype;
    EsExpidia           number(2)    := 0;
    EsFIT               number(2)    := 0;
    oldTotalFIT       number(10,2) := 0;
    newTotalFIT     number(10,2) := 0;
    FITDivisa          varchar(4)   := null;
    EsOTAMEX       number(2):= 0;
    v1                   mares%rowtype;
    vold                mares%rowtype;
    vInMares         InMares%rowtype;
    ErrorCode       number;
    ErrorMsg        varchar2(200) := null;
    vAction           varchar2(1) := null;
    vrows              number := 0;

    vError              varchar2(200);
    vRem              varchar2(200);
    vDone               varchar2(1);
    vEntroProceso        boolean := false;
    
    begin
       open c0(pHotel,pReserv) ;
       fetch c0 into v0;
       close c0;

       -- Status
       vAction := 'R';
       if v0.ma_can_d is not null then
          vAction := 'C';
       end if;

       -- NEW UTL and COUNTRY
       open c1(v0.ma_hotel, v0.ma_charter);
       fetch c1 into vc1;
       close c1;

       v1.mr_mayorista := nvl(vc1.ch_utl,'AME');
       
       -- Otamex
       open cFitOtamex(v0.ma_charter);
       fetch cFitOtamex into vFitOtamex;
       if cFitOtamex%found then
           newTotalFIT := v0.ma_due_tot;
          if vFitOtamex.oc_operator in ('BKINGAI','DEDIRAI','WBCOCV','SUDTRAVG','SUDAEREA') then
             v1.mr_mayorista := 'DIR';
             EsOTAMEX := 1;
          else
              if vFitOtamex.oc_operator = 'FIT' then
                 v1.mr_mayorista := 'DIR';
              else
                 v1.mr_mayorista := 'MEX';
              end if;
          end if;
       else                                                        -- 80
          newTotalFIT := null;
          EsOTAMEX := 0;
       end if;
       close cFitOtamex;

       if v0.ma_hotel in ('03','10') then
          open IsRedSeal (v0.ma_hotel, v0.ma_charter);
          fetch IsRedSeal into vRedSeal;
          if IsRedSeal%found then
             v1.mr_mayorista := 'GAR';
             newTotalFIT := v0.ma_due_tot;
          end if;
          close IsRedSeal;
       end if;


        if (EsOTAMEX = 0 and not isTravMarket(vc1.ch_utl) ) then
            --vc1.ch_nav_room       := nvl(v0.ma_room,'ROH');
            newTotalFIT           := v0.ma_due_tot;
        end if;
        
        if (vc1.ch_utl = 'SUD') then
            newTotalFIT := v0.ma_due_tot;
        end if;


        for vc2 in c2(v0.ma_hotel, v0.ma_reserv) loop
                if c2%rowcount = 1 then
                   v1.mr_nombre_1   := substr(vc2.mn_first_n,1,20);
                   v1.mr_apellido_1 := substr(vc2.mn_last_n,1,20);
               elsif c2%rowcount = 2 then
                   v1.mr_nombre_2   := substr(vc2.mn_first_n,1,20);
                   v1.mr_apellido_2 := substr(vc2.mn_last_n,1,20);
               elsif c2%rowcount = 3 then
                   v1.mr_nombre_3   := substr(vc2.mn_first_n,1,20);                          -- 100
                   v1.mr_apellido_3 := substr(vc2.mn_last_n,1,20);
               elsif c2%rowcount = 4 then
                   v1.mr_nombre_4   := substr(vc2.mn_first_n,1,20);
                   v1.mr_apellido_4 := substr(vc2.mn_last_n,1,20);
               end if;
       end loop;

       open c3(v0.ma_hotel, v0.ma_charter);
       fetch c3 into vdummy;
       close c3;
       v1.mr_plan_1 := 'EP';
       if vdummy = 'Y' then
          v1.mr_plan_1 := 'AI';
       end if;
       
       -- Get Cancun hotel number.
       open c4(v0.ma_hotel);
       fetch c4 into vc4;
       close c4;
       v0.ma_hotel := vc4.ho_hotel_cancun;
       

       -- Por default asigna el tipo de cuarto de  ch_nav_room
       v1.mr_tipo_hab        := nvl(vc1.ch_nav_room, 'ROH');
       -- para mercados que no son AME 
       if not isTravMarket (vc1.ch_utl)  or v1.mr_tipo_hab = 'ROH' then
            v1.mr_tipo_hab        := v0.ma_room;              
       end if; 

       GroupName  := v0.ma_group;
       vCharter      := v0.ma_charter;
       open IsGroup(v0.ma_charter);
       fetch IsGroup   into vIsGroup;
       if IsGroup%found then
          vCharter := 'GROUPSAI';
          GroupName:= substr(v0.ma_charter,1,6);
       end if;
       close IsGroup;
       
       v1.mr_hotel           := getCancunHotel(pHotel);
       v1.mr_reserva         := v0.ma_reserv;
       v1.mr_agencia         := vCharter;
       v1.mr_grupo           := GroupName;                                      -- 120
       v1.mr_pais            := nvl(vc1.ch_country,'US');
       v1.mr_codpos          := null;
       v1.mr_tipo_huesped    :=nvl( v0.ma_guest,'CM');
       v1.mr_vip             := v0.ma_vip;
       v1.mr_llegada         := v0.ma_arrival;
       v1.mr_salida          := v0.ma_depart;
       v1.mr_noches          := v0.ma_nites;
       v1.mr_llegada_h       := null;
       v1.mr_vuelo           := ltrim(rtrim(substr(ltrim(rtrim(v0.ma_flight)),1,4)));
       v1.mr_linea           := v0.ma_line ;
       v1.mr_adulto          := v0.ma_adult;
       v1.mr_menor           := v0.ma_child;
       v1.mr_bebe            := v0.ma_infant;
       v1.mr_plan_2          := v0.ma_plan_2;
       v1.mr_paquete         := v0.ma_package;
       v1.mr_servicio        := v0.ma_first;
       v1.mr_notas           := ltrim(rtrim(substr(v0.ma_rem_user,1,100)));
       v1.mr_status          := vAction;                                           -- 140
       v1.mr_tarifa          := v0.ma_rate;
       v1.mr_importe         := nvl(newTotalFIT,0);
       v1.mr_deposito        := v0.ma_dep_rec;
       v1.mr_mayorista_cun   := '';
       v1.mr_habi            := v0.ma_room_num;
       v1.mr_voucher         := ltrim(rtrim(substr(nvl(v0.ma_voucher,v0.ma_agcy_cnf),1,16)));
       v1.mr_reserva_p       := v0.ma_prev_reserv;
       v1.mr_hotel_orig      := v0.ma_prev_hotel;
       v1.mr_cap_f           := v0.ma_inp_d;
       v1.mr_can_f           := v0.ma_can_d;
       v1.mr_mod_f           := v0.ma_mod_d;
       v1.mr_semaforo        := '1';
       v1.mr_notas_hotel     := null;
       v1.mr_notas_central   := v0.ma_rem_sys;
       v1.mr_source          := v0.ma_source;
       v1.mr_agency_conf     := v0.ma_agcy_cnf;
       v1.mr_moneda          :=  v0.ma_divisa;
       v1.mr_junior              := v0.ma_junior;


       begin

          vold := null;                                                          -- 160
        --  dumpMARES(v1);
          
          
          -- Hace la llamada al procedimiento de Juan Antonio para
          -- ingresar el registro al hotel...
          -- Oasis Sens
          if pHotel = '04' then
          --  dumpMARES(v1);
            vError := interface_reservaciones_sens(v1);
            vEntroProceso := true;
          -- Oasis Tulum
          elsif pHotel in ('03','10') then
            vError := interface_reservaciones_ot(v1);
            vEntroProceso := true;            
          -- Oasis Palm
          elsif pHotel in ('09','12') then
            vError := interface_reservaciones_op(v1);
            vEntroProceso := true;
          -- Oasis Viva
          --elsif pHotel in ('07','11') then
          --  vError := interface_reservaciones_ov(v1);
           -- vEntroProceso := true;
          end if;

            if vEntroProceso then
                vDone := 'Y';
                if vError is not null then
                    vDone := 'E';
                end if;
             
                update rstrans
                set  tr_done = vDone,
                     tr_error = vError,
                     tr_rem = vRem||' done at '||to_char(sysdate,'dd/mon hh24mi')
                where  tr_stamp = pRstrans.tr_stamp
                    and tr_hotel = pRstrans.tr_hotel
                    and tr_reserv = pRstrans.tr_reserv;
            end if;             
            
          -- commit para cada registro enviado.... 
          commit;


       exception
        when others then  
            update rstrans
            set tr_error = dbms_utility.format_error_backtrace 
            where  tr_stamp = pRstrans.tr_stamp
               and tr_hotel = pRstrans.tr_hotel
                and tr_reserv = pRstrans.tr_reserv;
            commit;
       end;
    end;

    procedure writeHotel (pHost in varchar2) is
        cursor c1 (xHotel1 varchar2, xHotel2 varchar2) is 
        select *
        from rstrans
        where   nvl(tr_done,'N') = 'N'
            and tr_hotel in (xHotel1, xHotel2)
        order by tr_stamp asc;
        
        cursor c2(xhotel varchar2, xreserv varchar2) is 
        select *
        from mares_view
        where  ho_hotel = xhotel
            and mr_reserva = xreserv;
            
    vc1             c1%rowtype;
    vMares_view        c2%rowtype;
    vError          RSTRANS.TR_ERROR%type;
    vRem          RSTRANS.TR_REM%type;
    countH          number := 0;
    countT          number := 0;
    vHotel1         rshotel.ho_hotel%type;
    vHotel2         rshotel.ho_hotel%type;
    begin
        
        if pHost = '04' then    
            vHotel1 := '04';
            vhotel2 := '04';
        elsif pHost = '09' then
            vHotel1 := '09';
            vHotel2 := '12';
        elsif pHost = '07' then
            vHotel1 := '07';
            vHotel2 := '11';
        elsif pHost = '01' then
            vHotel1 := '01';
            vHotel2 := '02';
        elsif pHost = '03' then
            vHotel1 := '03';
            vHotel2 := '10';
        end if;
    
        -- Procesa los movimientos del hotel para TRavamerica pendientes en RSTRANS done = N, source = H
        for vc1 in c1(vHotel1, vHotel2) loop
              -- Movimientos generados por el hotel entonces actualiza rsmaes
               if vc1.tr_source = 'T' then         
               -- Movimientos generados en Travamerica entonces actualiza mares
                    sendBookingHotel (vc1.tr_hotel, vc1.tr_reserv, vc1);
                    countT := countT + 1;            
               end if;
        end loop;
        dbms_output.put_line('Rows updated, from TravAmerica= '||countT);
    end writeHotel;
    
    
    
    
    /*
        Read the hotel movements and update Travamerica RSMAES.
    */
    procedure readHotel(pHost in varchar2) is
    cursor c1(xHost varchar2) is
    select * from rstrans_info where trans_host = xHost and rownum < 101;
    
    vc1         c1%rowtype;
    vQuery      varchar2(600);
    vQuery2     varchar2(600);
    cRstrans    vRefCursor;
    cMares      vRefCursor;
    vRstrans    rstrans%rowtype;
    vError      RSTRANS.TR_ERROR%type;
    vRem        RSTRANS.TR_REM%type;
    vMares      mares%rowtype;
    vCount      number := 0;
    begin
        open c1(pHost);
        fetch c1 into vc1;
        if c1%notfound then return; end if;
        close c1;
        
        -- Obtiene los movimientos pendientes de envio a travamerica...        
        vQuery := 'Select tr_stamp, tr_hotel, tr_reserv, tr_source, tr_action, tr_done, tr_error, tr_rem from '|| vc1.trans_table ||' where nvl(tr_done,''N'')= ''N'' and rownum < 301 order by tr_stamp';
        --insert into kk4 values (vQuery);
        --commit;
        open cRstrans for vQuery;
        loop
            fetch cRstrans into vRstrans;
            exit when cRstrans%notfound;
            
            -- Obtiene el registro a enviar a travamerica en formato MARES.
            vQuery2 := 'Select  * from '|| vc1.trans_reservations||' where rv_reserva = '''||vRstrans.tr_reserv||'''';
            --insert into kk4 values (vQuery2);
            --commit;
            
            open cMares for vQuery2;
            fetch cMares into vMares;
            close cMares;
            
            -- procesa registro
            if vMares.mr_agencia != 'AMEAI' and isTravMarket(vMares.mr_mayorista) and vError is null then
                processTravMarkets(vMares, vError, vRem);    
            elsif vError is null then
                processCunMarkets(vMares, vError, vRem); 
            end if;        
            
            -- set procesado = Y
            vQuery2 := 'update '||vc1.trans_table || 
                        ' set tr_done = ''Y'','||
                        ' tr_error = '''||vError||''','||
                        ' tr_rem = '''||vRem||' done at '||to_char(sysdate,'dd/mon hh24mi')||''''||
                        ' where  to_char(tr_stamp,''dd/mm/yy hh24mi:ss'') ='''|| to_char(vRstrans.tr_stamp,'dd/mm/yy hh24mi:ss')||''''||
                                ' and tr_hotel = '''||vRstrans.tr_hotel||''''||
                                ' and tr_reserv = '''||vRstrans.tr_reserv||'''';


            execute immediate vQuery2; 
            --insert into kk4 values (vQuery2);

            vError := null;
            vRem := null;  
            vCount := vCount +1;
            commit;
        end loop;
        close cRstrans;
        
        DBMS_OUTPUT.PUT_LINE('Rows updated, from Cancun ='||vCount);
    end;
    
    
end;
/


oasisInterfaceOC


execute oasisInterface.readHotel('04')

select t.*, t.rowid from rstrans_info t


select * from kk4

delete from kk4

insert into mares

Select  * from FRESERVA_TRAVAMERICA_SENS where rv_reserva = '002183'

select * from freserva 