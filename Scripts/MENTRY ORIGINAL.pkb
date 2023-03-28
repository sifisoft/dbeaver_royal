CREATE OR REPLACE package body HOTEL.mentry  is
path		varchar2 (100) := '/win/oas/mentry.';
MAXROOMPAGE	number := 10;
--MAXROOMPAGE	number := 2;
MAXADULTS	number := 4;
MAXCHILD	number := 3;
MAXINFANT	number := 3;
TYPE rn_sequenceType IS TABLE OF rsrlname.rn_sequence%type INDEX BY BINARY_INTEGER;
TYPE rn_last_nType   IS TABLE OF rsrlname.rn_last_n%type INDEX BY BINARY_INTEGER;
TYPE rn_first_nType  IS TABLE OF rsrlname.rn_first_n%type INDEX BY BINARY_INTEGER;
TYPE ListErrorType   IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE RecLineType IS RECORD
	(
	rd_hotel	rsrldet.rd_hotel%type,
	rd_number	rsrldet.rd_number%type,
	rd_line		rsrldet.rd_line%type,
	rd_room		rsrldet.rd_room%type,
	rd_rate		rsrldet.rd_room%type,
	rd_guest	rsrldet.rd_guest%type,
	rd_vip		rsrldet.rd_vip%type,
	rd_adult	rsrldet.rd_adult%type,
	rd_child	rsrldet.rd_child%type,
	rd_infant	rsrldet.rd_infant%type,
	rd_plan_1	rsrldet.rd_plan_1%type,
	rd_plan_2	rsrldet.rd_plan_2%type,
	rd_package	rsrldet.rd_package%type,
	rd_first	rsrldet.rd_first%type,
	rd_rem		rsrldet.rd_rem%type,
	rd_arr_time	rsrldet.rd_arr_time%type,
	rd_flight	rsrldet.rd_flight%type,
	rd_carrier	rsrldet.rd_carrier%type,
	rd_inp_u	rsrldet.rd_inp_u%type,
	rd_inp_d	rsrldet.rd_inp_d%type,
	rd_inp_t	rsrldet.rd_inp_t%type,
	rd_reserv	rsrldet.rd_reserv%type,
	rd_agcy_cnf	rsrldet.rd_agcy_cnf%type,
	rd_special	rsrldet.rd_special%type,
	rd_trans	rsrldet.rd_trans%type,
	rd_dep_tot	rsrldet.rd_dep_tot%type,
	rd_dep_rec	rsrldet.rd_dep_rec%type,
	rd_due_tot	rsrldet.rd_due_tot%type,
	rn_sequence     rn_sequenceType,
	rn_last_n      	rn_last_nType,
	rn_first_n     	rn_first_nType
	);
RecLine  	RecLineType;
ListError	ListErrorType;
TYPE RecLineRates IS RECORD
(
 ma_start_d     rsmaes.ma_start_d%type,
 ma_ind1        rsmaes.ma_ind1%type,
 ma_dob1        rsmaes.ma_dob1%type,
 ma_tri1        rsmaes.ma_tri1%type,
 ma_qua1        rsmaes.ma_qua1%type,
 ma_adition1    rsmaes.ma_adition1%type,
 ma_end_d1      rsmaes.ma_end_d1%type,
 ma_ind2        rsmaes.ma_ind2%type,
 ma_dob2        rsmaes.ma_dob2%type,
 ma_tri2        rsmaes.ma_tri2%type,
 ma_qua2        rsmaes.ma_qua2%type,
 ma_adition2    rsmaes.ma_adition2%type,
 ma_end_d2      rsmaes.ma_end_d2%type,
 ma_ind3        rsmaes.ma_ind3%type,
 ma_dob3        rsmaes.ma_dob3%type,
 ma_tri3        rsmaes.ma_tri3%type,
 ma_qua3        rsmaes.ma_qua3%type,
 ma_adition3    rsmaes.ma_adition3%type,
 ma_end_d3      rsmaes.ma_end_d3%type,
 ma_divisa        rsmaes.ma_divisa%type
);
RecRates        RecLineRates;
--***********************************************************
function getDuetot(total 	out number,
		   farrival 	in date,
		   fdeparture 	in date,
		   fnites 	in number,
		   fcharter 	in varchar2) return number is
           
cursor c (XHOTEL varchar2, XPACKAGE varchar2) is
select *
from rspackage
where   pk_hotel = XHOTEL
	and pk_pack  = XPACKAGE
	and nvl(pk_activ,'N') = 'Y';
    
cursor c2(xhotel varchar2, xguest varchar2) is
select gu_comp
from rsguest
where gu_hotel = xhotel and
      gu_guest = xguest;
      
complementary 	rsguest.gu_comp%type;
pdate 		date;
i		number;
vrspackage	rspackage%rowtype;
vcd_single	rscondet.cd_single%type;
vcd_doble	rscondet.cd_doble%type;
vcd_adition	rscondet.cd_adition%type;
vcd_des_chi	rscondet.cd_des_chi%type;
vcd_des_bay	rscondet.cd_des_bay%type;
vcd_tip_hou	rscondet.cd_tip_hou%type;
vcd_tip_bel	rscondet.cd_tip_bel%type;
vcd_triple	rscondet.cd_triple%type;
vcd_quad 	rscondet.cd_quad%type;
vcp_adult	rscoplan.cp_adult%type;
vcp_child	rscoplan.cp_chil%type;
vcp_infant 	rscoplan.cp_infant%type;
vpa_type	rsplanes.pa_type%type;
vho_iva		rshotel.ho_iva%type;
vch_prepay	rscharter.ch_prepay%type;
vch_tip		rscharter.ch_tip%type;
vch_iva		rscharter.ch_iva%type;
roomrate	number(16,2) := 0;
belboy_rate	number(15,2) := 0;
plan1_rate	number(15,2) := 0;
plan2_rate	number(15,2) := 0;
package_rate	number(15,2) := 0;
tax_rate	number(15,2) := 0;
house_rate	number(15,2) := 0;
childrate	number(15,2) := 0;
infantrate	number(15,2) := 0;
type stepType is table of varchar2(30) index by BINARY_INTEGER;
stepDesc	stepType;
pstep		number 	:= 0;
begin
	stepDesc(1) := 'Rate Contract not found';
	stepDesc(2) := 'Meal Plan 1 Contract not found';
	stepDesc(3) := 'Meal Plan 2 Contract not found';
	stepDesc(4) := 'Tax not found';
	stepDesc(5) := '';
	open c2(Recline.rd_hotel, Recline.rd_guest);
	fetch c2 into complementary;
	close c2;
	--select gu_comp
	--into complementary
	--from rsguest
	--where gu_hotel = Recline.rd_hotel and
	      --gu_guest = Recline.rd_guest;
	-- **** GET THE ROOM RATE
	pdate 	:= farrival;
	pstep 	:= 1;
	for i in 1..fnites  loop
		select  cd_single,cd_doble,cd_adition,nvl(cd_des_chi,0),nvl(cd_des_bay,0),
			nvl(cd_tip_hou,0),nvl(cd_tip_bel,0),cd_triple,cd_quad
		into    vcd_single,vcd_doble,vcd_adition,vcd_des_chi,vcd_des_bay,
			vcd_tip_hou,vcd_tip_bel,vcd_triple,vcd_quad
		from 	rscondet,rsconhed
		where
			ch_charter = cd_charter and
			ch_hotel = cd_hotel and
			ch_type	= cd_type and
			ch_end_sea = cd_end_sea and
			ch_hotel = Recline.rd_hotel and
			ch_charter = fcharter and
			ch_type = RecLine.rd_rate and
			cd_room = Recline.rd_room and
			ch_activ = 'Y' and
			pdate between ch_sta_sea and ch_end_sea;
		if complementary != 'Y' then
			if RecLine.rd_adult = 1 then
				roomrate := roomrate + vcd_single;
			elsif (RecLIne.rd_adult = 2) then
				roomrate := roomrate + vcd_doble;
			elsif (RecLIne.rd_adult = 3) then
				roomrate := roomrate + vcd_triple;
			elsif (RecLIne.rd_adult = 4) then
				roomrate := roomrate + vcd_quad;
			elsif (RecLIne.rd_adult > 4) then
				roomrate := roomrate + vcd_quad;
				roomrate := roomrate+(Recline.rd_adult-4)*vcd_adition;
			end if;
			if RecLine.rd_child > 0 then
				ChildRate := (vcd_adition-
					     (vcd_adition*vcd_des_chi)/100)
					     *RecLine.rd_child;
				roomrate := roomrate + ChildRate;
			end if;
			if RecLine.rd_infant > 0 then
				InfantRate := (vcd_adition-
					     (vcd_adition*vcd_des_bay)/100)
					     *RecLine.rd_infant;
				roomrate := roomrate + InfantRate;
			end if;
		end if;
		pdate := pdate + 1;
	end loop;
	--************** Meal Plan 1
	pdate := farrival;
	pstep 	:= 2;
	if nvl(ltrim(RecLine.rd_plan_1),'X') != 'X' then
		for i in 1..fnites loop
			select cp_adult,cp_chil,cp_infant,pa_type
			into   vcp_adult,vcp_child,vcp_infant,vpa_type
			from   rscoplan,rsplanes
			where  	cp_hotel = pa_hotel and
			       	cp_plan = pa_plan and
				cp_hotel = RecLine.rd_hotel and
				cp_charter = fcharter and
				cp_plan = Recline.rd_plan_1 and
				cp_act_date is not null and
				pdate between cp_sta_sea and cp_end_sea;
			if vpa_type = 'D' then
				plan1_rate := plan1_rate +
					(RecLine.rd_adult*vcp_adult +
					 RecLine.rd_child*vcp_child +
					 RecLine.rd_infant*vcp_infant);
			else
				plan1_rate := plan1_rate +
					(RecLine.rd_adult*vcp_adult +
					 RecLine.rd_child*vcp_child +
					 RecLine.rd_infant*vcp_infant);
				exit;
			end if;
		pdate := pdate + 1;
		end loop;
	end if; -- End Plan 1;
	--************** Meal Plan 2
	pstep 	:= 3;
	if nvl(ltrim(RecLine.rd_plan_2),'X') != 'X' then
		for i in 1..fnites loop
			select cp_adult,cp_chil,cp_infant,pa_type
			into   vcp_adult,vcp_child,vcp_infant,vpa_type
			from   rscoplan,rsplanes
			where  	cp_hotel = pa_hotel and
			       	cp_plan = pa_plan and
				cp_hotel = RecLine.rd_hotel and
				cp_charter = fcharter and
				cp_plan = Recline.rd_plan_2 and
				cp_act_date is not null and
				pdate between cp_sta_sea and cp_end_sea;
			if vpa_type = 'D' then
				plan2_rate := plan2_rate +
					(RecLine.rd_adult*vcp_adult +
					 RecLine.rd_child*vcp_child +
					 RecLine.rd_infant*vcp_infant);
			else
				plan2_rate := plan2_rate +
					(RecLine.rd_adult*vcp_adult +
					 RecLine.rd_child*vcp_child +
					 RecLine.rd_infant*vcp_infant);
				exit;
			end if;
		pdate := pdate + 1;
		end loop;
	end if; -- End Plan 2;
	--************  PACKAGE
	pstep 	:= 4;
	if nvl(RecLine.rd_package,'X') <> 'X' then
		open c(RecLine.rd_Hotel, RecLine.rd_package);
		fetch c into vrspackage;
		close c;
		if RecLine.rd_adult <= 1 then
			package_rate := nvl(vrspackage.pk_pr_sin,0);
		else
			package_rate := nvl(vrspackage.pk_pr_dob,0);
		end if;
		if RecLine.rd_adult > 2 then
			package_rate := package_rate +
				((RecLine.rd_adult-2) * nvl(vrspackage.pk_pr_adi,0));
		end if;
		if RecLine.rd_child <> 0 then
			package_rate := package_rate +
				(RecLine.rd_child * nvl(vrspackage.pk_pr_chi,0));
		end if;
	end if;
	-- Tax,bellboy rate, house rate
	belboy_rate := nvl(vcd_tip_bel,0) * RecLine.rd_adult;
	pstep 	:= 5;
	select 	ch_prepay,nvl(ch_tip,'R'),nvl(ch_iva,'N')
	into  	vch_prepay,vch_tip,vch_iva
	from 	rscharter
	where 	ch_hotel = RecLine.rd_hotel and
		ch_charter = fcharter;
	-- TAX
	if vch_iva = 'N' then
		select nvl(ho_iva,0)
		into vho_iva
		from rshotel
		where ho_hotel = RecLine.rd_hotel;
		vho_iva := (roomrate + plan1_rate) * (vho_iva/100);
	end if;
	-- TIPS
	if vch_tip = 'P' then
		house_rate := vcd_tip_hou * RecLine.rd_adult * fnites;
	else
		house_rate := vcd_tip_hou * fnites;
	end if;
	roomrate	:= roomrate+plan1_rate+plan2_rate+package_rate+
				   house_rate+belboy_rate+tax_rate;
	total 		:= roomrate;
        pckg_new_gettotal_test03.search_period_test
        (
        RecLine.rd_hotel, fcharter, farrival, fdeparture, RecLine.rd_rate, Recline.rd_room,
        RecRates.ma_start_d, RecRates.ma_ind1, RecRates.ma_dob1, RecRates.ma_tri1, RecRates.ma_qua1, RecRates.ma_end_d1,
        RecRates.ma_ind2, RecRates.ma_dob2, RecRates.ma_tri2, RecRates.ma_qua2, RecRates.ma_end_d2,
        RecRates.ma_ind3, RecRates.ma_dob3, RecRates.ma_tri3, RecRates.ma_qua3, RecRates.ma_end_d3,
        RecRates.ma_adition1, RecRates.ma_adition2, RecRates.ma_adition3
        );
	return (0);
exception
when no_data_found then
	rollback;
	utl.panic('Error [GetDuetot]: ',stepDesc(pstep));
	htp.p(' Hotel=#'||Recline.rd_hotel||'#'||
		  ' Charter=#'||fcharter||'#'||
		  ' Line=#'||RecLine.rd_rate||'#'||
		  ' Room=#'||Recline.rd_room||'#'||
		  ' Plan1=#'||Recline.rd_plan_1||'#'||
		  ' Plan2=#'||Recline.rd_plan_2||'#'||
		  ' Date=#'||pdate||'#');
	return(-1);
when others then
	rollback;
	utl.panic('Error DueTotal Function   step->'||pstep,sqlerrm);
	return(-1);
end;
-- #
-- #
function getDuetotRedSealDisc (total     out number,
           farrival     in date,
           fdeparture     in date,
           fnites     in number,
           fcharter     in varchar2) return number is

cursor c (XHOTEL varchar2, XPACKAGE varchar2) is
select * from rspackage
where   pk_hotel = XHOTEL
    and pk_pack  = XPACKAGE
    and nvl(pk_activ,'N') = 'Y';

cursor c2(xhotel varchar2, xguest varchar2) is
select gu_comp
from rsguest
where gu_hotel = xhotel and
      gu_guest = xguest;

complementary     rsguest.gu_comp%type;
pdate         date;
i        number;
vrspackage    rspackage%rowtype;
vcd_single    rscondet.cd_single%type;
vcd_doble    rscondet.cd_doble%type;
vcd_adition    rscondet.cd_adition%type;
vcd_des_chi    rscondet.cd_des_chi%type;
vcd_des_bay    rscondet.cd_des_bay%type;
vcd_tip_hou    rscondet.cd_tip_hou%type;
vcd_tip_bel    rscondet.cd_tip_bel%type;
vcd_triple    rscondet.cd_triple%type;
vcd_quad     rscondet.cd_quad%type;
vcp_adult    rscoplan.cp_adult%type;
vcp_child    rscoplan.cp_chil%type;
vcp_infant     rscoplan.cp_infant%type;
vpa_type    rsplanes.pa_type%type;
vho_iva        rshotel.ho_iva%type;
vch_prepay    rscharter.ch_prepay%type;
vch_tip        rscharter.ch_tip%type;
vch_iva        rscharter.ch_iva%type;
roomrate    number(16,2) := 0;
belboy_rate    number(15,2) := 0;
plan1_rate    number(15,2) := 0;
plan2_rate    number(15,2) := 0;
package_rate    number(15,2) := 0;
tax_rate    number(15,2) := 0;
house_rate    number(15,2) := 0;
childrate    number(15,2) := 0;
infantrate    number(15,2) := 0;
type stepType is table of varchar2(30) index by BINARY_INTEGER;
stepDesc    stepType;
pstep        number     := 0;
cursor c4 (pHotel varchar2,pCharter varchar2,pRate varchar2, pDate date ) is
        select  *
        from     up_rscondet
                where
            up_hotel = pHotel and
            up_ope_desc = pCharter and
            up_category = pRate and
            pDate <= up_end_date and rownum < 4;
v4     c4%rowtype;
periodo number(2) := 0;
begin
    stepDesc(1) := 'Rate Contract not found';
    stepDesc(2) := 'Meal Plan 1 Contract not found';
    stepDesc(3) := 'Meal Plan 2 Contract not found';
    stepDesc(4) := 'Tax not found';
    stepDesc(5) := '';
    open c2(Recline.rd_hotel, Recline.rd_guest);
    fetch c2 into complementary;
    close c2;
    --select gu_comp
    --into complementary
    --from rsguest
    --where gu_hotel = Recline.rd_hotel and
          --gu_guest = Recline.rd_guest;
    -- **** GET THE ROOM RATE
    pdate     := farrival;
    pstep     := 1;
    for i in 1..fnites  loop
        select  up_single,up_double,up_ext_per,nvl(up_desc_child,0),nvl(up_desc_bb,0),
            up_triple,up_cuad
        into    vcd_single,vcd_doble,vcd_adition,vcd_des_chi,vcd_des_bay,vcd_triple,vcd_quad
        from     up_rscondet
        where
            up_hotel = Recline.rd_hotel and
            up_ope_desc = fcharter and
            up_category = RecLine.rd_rate and
            pdate between up_ini_date and up_end_date;

            if RecLine.rd_adult = 1 then
                roomrate := roomrate + vcd_single;
            elsif (RecLIne.rd_adult = 2) then
                roomrate := roomrate + vcd_doble;
            elsif (RecLIne.rd_adult = 3) then
                roomrate := roomrate + vcd_triple;
            elsif (RecLIne.rd_adult = 4) then
                roomrate := roomrate + vcd_quad;
            elsif (RecLIne.rd_adult > 4) then
                roomrate := roomrate + vcd_quad;
                roomrate := roomrate+(Recline.rd_adult-4)*vcd_adition;
            end if;

            if RecLine.rd_child > 0 then
                ChildRate := (vcd_adition-
                         (vcd_adition*vcd_des_chi)/100)
                         *RecLine.rd_child;
                roomrate := roomrate + ChildRate;
            end if;
                        if RecLine.rd_infant > 0 then
                InfantRate := (vcd_adition-
                         (vcd_adition*vcd_des_bay)/100)
                         *RecLine.rd_infant;
                roomrate := roomrate + InfantRate;
            end if;

        pdate := pdate + 1;
    end loop;

    total         := roomrate;

begin
    open c4 (RecLine.rd_hotel, fcharter, RecLine.rd_rate, farrival);
    loop
      fetch c4 into v4;
      exit when c4%notfound;

       if periodo = 0 then
          if farrival between v4.up_ini_date and v4.up_end_date then
             RecRates.ma_start_d   := v4.up_ini_date;
             RecRates.ma_ind1       := v4.up_single;
             RecRates.ma_dob1      := v4.up_double;
             RecRates.ma_tri1        := v4.up_triple;
             RecRates.ma_qua1      := v4.up_cuad;
             RecRates.ma_adition1  := v4.UP_EXT_PER -(v4.UP_EXT_PER*v4.UP_DESC_CHILD)/100;
             RecRates.ma_end_d1  := v4.up_end_date;
          else
             RecRates.ma_start_d  := '01-JAN-01';
             RecRates.ma_ind1 := -100;
          end if;
       elsif periodo = 1 then
             RecRates.ma_ind2       := v4.up_single;
             RecRates.ma_dob2      := v4.up_double;
             RecRates.ma_tri2        := v4.up_triple;
             RecRates.ma_qua2      := v4.up_cuad;
             RecRates.ma_adition2  := v4.UP_EXT_PER -(v4.UP_EXT_PER*v4.UP_DESC_CHILD)/100;
             RecRates.ma_end_d2  := v4.up_end_date;
       else
             RecRates.ma_ind3       := v4.up_single;
             RecRates.ma_dob3      := v4.up_double;
             RecRates.ma_tri3        := v4.up_triple;
             RecRates.ma_qua3      := v4.up_cuad;
             RecRates.ma_adition3  := v4.UP_EXT_PER -(v4.UP_EXT_PER*v4.UP_DESC_CHILD)/100;
             RecRates.ma_end_d3  := v4.up_end_date;
       end if;
       periodo := periodo + 1;
    end loop;
    close c4;
    exception
        when others then
             close c4;
             RecRates.ma_start_d   := '01-JAN-01';
             RecRates.ma_ind1       := -100;
             RecRates.ma_dob1      := -100;
             RecRates.ma_tri1        := -100;
             RecRates.ma_qua1      := -100;
             RecRates.ma_adition1  := -100;
             RecRates.ma_end_d1  := '01-JAN-01';
             RecRates.ma_ind2       := -100;
             RecRates.ma_dob2      := -100;
             RecRates.ma_tri2        := -100;
             RecRates.ma_qua2      := -100;
             RecRates.ma_adition2  := -100;
             RecRates.ma_end_d2  := '01-JAN-01';
             RecRates.ma_ind3       := -100;
             RecRates.ma_dob3      := -100;
             RecRates.ma_tri3        := -100;
             RecRates.ma_qua3      := -100;
             RecRates.ma_adition3  := -100;
             RecRates.ma_end_d3  :=  '01-JAN-01';
end ;

    return (0);

exception
when no_data_found then
    rollback;
    utl.panic('Error [GetDuetot]: ',stepDesc(pstep));
    htp.p(' Hotel=#'||Recline.rd_hotel||'#'||
          ' Charter=#'||fcharter||'#'||
          ' Line=#'||RecLine.rd_rate||'#'||
          ' Room=#'||Recline.rd_room||'#'||
          ' Plan1=#'||Recline.rd_plan_1||'#'||
          ' Plan2=#'||Recline.rd_plan_2||'#'||
          ' Date=#'||pdate||'#');
    return(-1);
when others then
    rollback;
    utl.panic('Error DueTotal Function RED  step->'||pstep,sqlerrm);
    return(-1);
end;
-- End GetDuetotRedSealDisc
--********************************************************************
--********************************************************************
--	Check  the Names
function CheckNames(	fpage 		in varchar2,
			fname		in owa_util.ident_longarr,
			fadults		in owa_util.ident_longarr,
			fChild		in owa_util.ident_longarr,
			fInfants	in owa_util.ident_longarr,
			xline		out number,
			fagencyNmbr in owa_util.ident_longarr) return number is
line		number := 1;
Rc		number := 0;
ErrorFounded	exception;
begin
	loop
	-- NULL Line
	if nvl(fchild(line),0) = 0 and
	   nvl(finfants(line),0) = 0 and
	   nvl(fname(line),'X') = 'X' then
		line := line + 1;
	else
		if ltrim(fname(line)) is null then
			Rc := 1;
			raise ErrorFounded;
		end if;
		-- Fill Names
		Rc := splitName(line,fadults(line),fChild(line),fInfants(line),
			      fname(line));
		if Rc > 0 then
			xline := line;
			raise ErrorFounded;
		end if;
		-- Save Information
		line := line + 1;
	end if;
	end loop;
	return(0);
exception
when no_data_found then
	return(0);
when ErrorFounded then
	rollback;
	return(Rc);
when others then
	rollback;
	utl.panic('Error CheckNames ',sqlerrm || '  Line '||line);
	return(-1);
end;
--*********************************************************************
-- Split the name text box into each Last Name and First Name
-- Example:  SMIT/JONH\r\n
--	     CURIER/EMMA\r\n
function splitName (	line 		in number,
						adults 		in number,
						child 		in number,
		  				infants 	in number,
						completename in varchar2
					) return number is
slength		number;
c		varchar2(1);
i		number := 1; -- Pointer Char
contNames 	number := 1;
padult		number; -- Pointer Adult Number
names		varchar2(250);
LName		varchar2(40);
FName		varchar2(40);
begin
names 	:= replace(ltrim(rtrim(completename)),chr(13),null); -- Replace the CR
names 	:= replace(ltrim(rtrim(names)),chr(10),null); -- Replace the CR
slength	:= nvl(length(names),0);
-- Error NO NAMES
if slength <= 0 then
	return(1);
end if;
contNames := adults + child + infants;
for padult in 1..contNames loop
	LName := '';
	FName := '';
	c := substr(names,i,1);
	-- LAST NAME
	if c = '/' then
		-- ERROR NO LAST NAME
		return(2);
	end if;
	--while i <= slength and c <> chr(10) and c <> '/' loop
	while i <= slength and c <> ',' and c <> '/' loop
		LName 	:= LName || c;
		i 	:= i + 1;
		c 	:= substr(names,i,1);
	end loop;
	if nvl(length(ltrim(rtrim(LName))),0) = 0 then
		-- Error NO LAST NAME
		return (2);
	end if;
	-- FIRST NAME
	--if c = chr(10) then
	if c = ',' then
		-- Error NO FIRST NAME
		return(3);
	end if;
	i := i + 1;
	c := substr(names,i,1);
	while i <= slength and c <> ',' loop
		FName 	:= FName || c;
		i 	:= i + 1;
		c 	:= substr(names,i,1);
	end loop;
	if nvl(length(ltrim(rtrim(FName))),0) = 0 then
		-- Error NO FIRST NAME
		return(3);
	end if;
	i := i + 1;
		-- Skip "\n"
		--while i < slength and c = ',' loop
		--i := i + 1;
		--c := substr(names,i,1);
		--end loop;
	-- Fill The Record Line
	RecLine.rn_sequence(padult) := padult;
	RecLine.rn_last_n(padult) 	:= upper(ltrim(rtrim(LName)));
	RecLine.rn_first_n(padult) 	:= upper(ltrim(rtrim(FName)));
end loop;
if i-1 < slength then
	-- So many names
	return(4);
end if;
return (0);
--exception
--when others then
	--rollback;
	--utl.panic('Error splitName Function ',sqlerrm);
	--return(-1);
end splitName;
--***********************************************************
function InsertInformation(	fpage in number,
			   	fhotel in varchar2,
			   	frooming in varchar2,
				fsource in varchar2,
				fcontact in varchar2,
				ftel in varchar2,
				farrival in date,
				fdeparture in date,
				fnites in number,
				fline in number)
			return number is
line	number;
dummy	number := 0;
begin
	delete from rsrldet
	where 	rd_hotel =  RecLine.rd_hotel
		and rd_number =  RecLine.rd_number
		and rd_line = (fline + (nvl(fpage-1,0) * MAXROOMPAGE));
	-- Check if the reservation has been previously inserted
	if ltrim(rtrim(RecLine.rd_agcy_cnf)) is not null then
		select count(*)
		into dummy
		from rsmaes
		where 	MA_AGCY_CNF = RecLine.rd_agcy_cnf
			and ma_hotel = RecLine.rd_hotel
			and ma_can_d is null
			and ma_can_u is null;
	end if;
	if (dummy = 0 and ltrim(rtrim(recline.rd_agcy_cnf)) is not null) or ltrim(rtrim(recline.rd_agcy_cnf)) is null   then
		insert into rsrldet
		(rd_hotel,
		rd_number,
		rd_line,
		rd_room,
		rd_rate,
		rd_guest,
		rd_vip,
		rd_adult,
		rd_child,
		rd_infant,
		rd_plan_1,
		rd_plan_2,
		rd_package,
		rd_first,
		rd_rem,
		rd_arr_time,
		rd_flight,
		rd_carrier,
		rd_inp_u,
		rd_inp_d,
		rd_inp_t,
		rd_reserv,
		rd_agcy_cnf,
		rd_special,
		rd_trans,
		rd_dep_tot,
		rd_dep_rec,
		rd_due_tot,
                rd_start_d,
                rd_ind1,
                rd_dob1,
                rd_tri1,
                rd_qua1,
                rd_adi1,
                rd_end_d1,
                rd_ind2,
                rd_dob2,
                rd_tri2,
                rd_qua2,
                rd_adi2,
                rd_end_d2,
                rd_ind3,
                rd_dob3,
                rd_tri3,
                rd_qua3,
                rd_adi3,
                rd_end_d3, 
                rd_divisa
                )
		values
			(RecLine.rd_hotel,
			RecLine.rd_number,
			(fline + (nvl(fpage-1,0) * MAXROOMPAGE)),
			--RecLine.rd_line,
			RecLine.rd_room,
			RecLine.rd_rate,
			RecLine.rd_guest,
			RecLine.rd_vip,
			RecLine.rd_adult,
			RecLine.rd_child,
			RecLine.rd_infant,
			RecLine.rd_plan_1,
			RecLine.rd_plan_2,
			RecLine.rd_package,
			RecLine.rd_first,
			RecLine.rd_rem,
			RecLine.rd_arr_time,
			RecLine.rd_flight,
			RecLine.rd_carrier,
			RecLine.rd_inp_u,
			RecLine.rd_inp_d,
			RecLine.rd_inp_t,
			RecLine.rd_reserv,
			RecLine.rd_agcy_cnf,
			RecLine.rd_special,
			RecLine.rd_trans,
			RecLine.rd_dep_tot,
			RecLine.rd_dep_rec,
			RecLine.rd_due_tot,
                        RecRates.ma_start_d,
                        RecRates.ma_ind1,
                        RecRates.ma_dob1,
                        RecRates.ma_tri1,
                        RecRates.ma_qua1,
                        RecRates.ma_adition1,
                        RecRates.ma_end_d1,
                        RecRates.ma_ind2,
                        RecRates.ma_dob2,
                        RecRates.ma_tri2,
                        RecRates.ma_qua2,
                        RecRates.ma_adition2,
                        RecRates.ma_end_d2,
                        RecRates.ma_ind3,
                        RecRates.ma_dob3,
                        RecRates.ma_tri3,
                        RecRates.ma_qua3,
                        RecRates.ma_adition3,
                        RecRates.ma_end_d3,
                        RecRates.ma_divisa
                       );
		for i in 1..(RecLine.rd_adult+RecLine.rd_child+RecLine.rd_infant) loop
			delete from rsrlname
			where 	rn_hotel = RecLine.rd_hotel
				and rn_number = RecLine.rd_number
				and rn_line = (fline + (nvl(fpage-1,0) * MAXROOMPAGE))
				and rn_sequence = i;
			insert into rsrlname
			(rn_hotel,
			rn_number,
			rn_line,
			rn_sequence,
			rn_last_n,
			rn_first_n)  values
				(RecLine.rd_hotel,
				RecLine.rd_number,
				(fline + (nvl(fpage-1,0) * MAXROOMPAGE)),
				i,
				RecLine.rn_last_n(i),
				RecLine.rn_first_n(i)
			);
		end loop;
	elsif dummy > 0 and ltrim(rtrim(RecLine.rd_agcy_cnf)) is not null then
		--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		--***** Line 999 for duplicate intent.
		--***************************************************
		update rsmaes
		set ma_rooming = frooming,
			ma_line  = 999
		where   MA_AGCY_CNF = RecLine.rd_agcy_cnf
				and ma_hotel = RecLine.rd_hotel;
	end if;
	commit;
	return(0);
exception
when others then
utl.panic('Error InsertInformation Function ',sqlerrm);
return (-1);
end;
--***************************************************
--	Save Information into the Record.
function SaveRL(
			fusr		in varchar2,
			fpage		in number,
			fhotel 		in varchar2,
			frooming 	in varchar2,
			fsource 	in varchar2,
			fcontact 	in varchar2,
			ftel 		in varchar2,
			fmonth 		in number,
			fday 		in number,
			fyear 		in number,
			fnites 		in number,
			fline		in owa_util.ident_longarr,
			fagencyNmbr	in owa_util.ident_longarr,
			fname		in owa_util.ident_longarr,
			froomtype	in owa_util.ident_longarr,
			fmeal1		in owa_util.ident_longarr,
			fmeal2		in owa_util.ident_longarr,
			fpackage	in owa_util.ident_longarr,
			ffs		in owa_util.ident_longarr,
			fadults		in owa_util.ident_longarr,
			fChild		in owa_util.ident_longarr,
			fInfants	in owa_util.ident_longarr,
			farrtimehh	in owa_util.ident_longarr,
			farrtimemi	in owa_util.ident_longarr,
			fcarrier	in owa_util.ident_longarr,
			fflight		in owa_util.ident_longarr,
			fremarks	in owa_util.ident_longarr,
			fcharter	in varchar2,
			duetot		in out number,
			fratetype	in varchar2,
            fdivisa      in varchar2) return number is
line		number := 1;
Rc			number := 0;
farrival 	date;
fdeparture	date;
total 		number(15,2) := 0;
varrtime	varchar2(5) := null;
ErrorFounded	exception;
OraError	exception;

cursor cpromo (pHotel varchar2,pCharter varchar2, pArrival date, pNights number,pInpDate date) is
  select nvl(pr_promo,0) promo
    from rspromo_new
   where pr_hotel   = photel
     and pr_charter = pcharter
     and pArrival between pr_start_trav and pr_end_trav
     and nvl(pInpDate,trunc(sysdate)) between pr_start and pr_end
     and pr_nites  <= pNights;

  Departur_Aux   date;
  promotion    number(2) := 0;
  
    cursor RedSealDisc (pHotel varchar2,pCharter varchar2) is
  select oc_charter from  rsopecharter, rscharter
  where
      oc_charter = pCharter
  and oc_operator= 'REDSEAI'
  and ch_hotel   = pHotel
  and ch_charter = oc_charter
  and ch_hotel in ('01','09');

  vRSeal       RedSealDisc%rowtype;
  IsRSealDisc  boolean := FALSE;

  
  /* */
  cursor cpromomex (pHotel varchar2,pCharter varchar2, pArrival date, pRoom varchar2 ,pInpDate date,pDivisa varchar2) is
  select * from rspromomex, rsopecharter, rscharter 
  where 
        hotel = pHotel
 and oc_operator = agencia
 and oc_charter   = pCharter
 and nvl(pInpDate,trunc(sysdate))  between uso_ini and uso_fin
 and pArrival between venta_ini and venta_fin
 and tarifa = pRoom
 and pDivisa = moneda
 and oc_operator != 'REDSEAI'
 and ch_hotel = hotel
 and ch_charter = oc_charter
 and ch_market  in ('MEX','SUD')
 and rownum < 2;
 
 vpmex    cpromomex%rowtype;
/*  */
cursor cdisc(pHotel varchar2,pCharter varchar2,pArrival date, pInpDate date) is
  select di_discount,di_disc_type
  from rsdiscount
  where
      di_hotel   = pHotel
  and di_charter = pCharter
  and nvl(pInpDate,trunc(sysdate)) between di_start_wb and di_end_wb
  and pArrival between di_start_wt and di_end_wt;
--  and pArrival = pInpDate + di_days_barr;

  vdisc     cdisc%rowtype;
  xDisc     number(7,2) := 0;
  
begin
	farrival 	:= to_date(fday||'-'||fmonth||'-'||fyear,'DD-MM-YYYY');
	fdeparture 	:= farrival + fnites;
	if (nvl(fpage,0) = 1 ) then -- Insert Header.
		delete from rsrlhead
		where 	rh_hotel = fhotel
			and rh_number = frooming;
		insert into rsrlhead
		(rh_hotel,rh_number,rh_charter,rh_subchar,rh_group,rh_arrival,
		 rh_depart,rh_nites,rh_source,rh_cont_n,rh_cont_t,rh_cancel,
		 rh_dep_tot, rh_dep_rec,rh_due_tot)
		values
		(fhotel,frooming,fcharter,fcharter,null,farrival,
		 fdeparture,fnites,fsource,null,null,null,null,null,null);
	end if;
	loop
	-- NULL Line
	if nvl(fchild(line),0) = 0 and
	   nvl(finfants(line),0) = 0 and
	   nvl(fname(line),'X') = 'X' then
		line := line + 1;
	else
		varrtime 			:= farrtimehh(line)||farrtimemi(line);
		-- Fill the Header
		RecLine.rd_hotel 	:= fhotel;
		RecLine.rd_number 	:= frooming;
		RecLine.rd_line 	:= line;
		RecLine.rd_room		:= froomtype(line);
		RecLine.rd_rate		:= fratetype;
		RecLine.rd_guest	:= 'CM';
		RecLine.rd_vip		:= 0;
		RecLine.rd_adult	:= fadults(line);
		RecLine.rd_child	:= fChild(line);
		RecLine.rd_infant	:= fInfants(line);
		RecLine.rd_plan_1	:= ltrim(rtrim(fmeal1(line)));
		RecLine.rd_plan_2	:= ltrim(rtrim(fmeal2(line)));
		RecLine.rd_package	:= ltrim(rtrim(fpackage(line)));
		RecLine.rd_First	:= ltrim(rtrim(ffs(line)));
		RecLine.rd_rem		:= replace(replace(ltrim(rtrim(upper(fremarks(line)))),chr(10),null),chr(13),' ');
		RecLine.rd_arr_time	:= varrtime;
		RecLine.rd_flight	:= upper(fflight(line));
		RecLine.rd_carrier	:= ltrim(rtrim(upper(fcarrier(line))));
		RecLine.rd_inp_u	:= fusr;
		RecLine.rd_inp_d	:= to_char(sysdate);
		RecLine.rd_inp_t	:= to_char(sysdate,'HH24MI');
		RecLine.rd_reserv	:= null;
		RecLine.rd_agcy_cnf	:= ltrim(rtrim(upper(fAgencyNmbr(line))));
		RecLine.rd_special	:= null;
		RecLine.rd_trans	:= null;
		RecLine.rd_dep_tot	:= 0;
		RecLine.rd_dep_rec	:= 0;
        RecRates.ma_start_d     := '01-JAN-01';
        RecRates.ma_ind1        := -100;
        RecRates.ma_dob1        := -100;
        RecRates.ma_tri1        := -100;
        RecRates.ma_qua1        := -100;
        RecRates.ma_adition1    := -100;
        RecRates.ma_end_d1      := '01-JAN-01';
        RecRates.ma_ind2        := -100;
        RecRates.ma_dob2        := -100;
        RecRates.ma_tri2        := -100;
        RecRates.ma_qua2        := -100;
        RecRates.ma_adition2    := -100;
        RecRates.ma_end_d2      := '01-JAN-01';
        RecRates.ma_ind3        := -100;
        RecRates.ma_dob3        := -100;
        RecRates.ma_tri3        := -100;
        RecRates.ma_qua3        := -100;
        RecRates.ma_adition3    := -100;
        RecRates.ma_end_d3      := '01-JAN-01';
        RecRates.ma_divisa        := fdivisa;
				
				
		open cpromo(fhotel,fcharter,farrival,fnites,null);
		fetch cpromo into promotion;
		if cpromo%notfound then
		   promotion := 0;
		end if;
		close cpromo;
/*
        open cpromomex (fHotel ,fcharter , farrival , froomtype ,null,fdivisa);
        fetch cpromomex into vpmex;
        close cpromomex;
  */      
--		Rc := getDuetot(total,farrival,fdeparture,fnites,fcharter); original. RAE03SEpP2 

/* Resulto que Manuelito dijo que la gente de Facturacion se podia confndir entonces metio tarifas con otros codigos para este tipo de descuento por lo que quedo como estaba anteriormente.
    No borro el codigo solo por si las dudas.
    
          open RedSealDisc (fHotel,fcharter);
          fetch RedSealDisc into vRSeal;
          if (RedSealDisc%found) and ((farrival - trunc(sysdate)) <= 7) then
                 IsRSealDisc := TRUE;
          else
                 IsRSealDisc := FALSE;
          end if;
          close RedSealDisc;

          if IsRSealDisc then
               Rc := getDuetotRedSealDisc (total, farrival,fdeparture,fnites,fcharter);
          else
               Rc := getDuetot(total,farrival,fdeparture,(fnites-promotion),fcharter);
          end if;
*/
		
         Rc := getDuetot(total,farrival,fdeparture,(fnites-promotion),fcharter);
		if Rc = -1 then
			Raise OraError;
		end if;
		
		/* Reactived .RAE 14NOV122  */ 
		open cdisc(fhotel,fcharter,farrival,null);
		fetch cdisc into vdisc;
		if cdisc%found then
		   if vdisc.di_disc_type = 1 then
		      total := total - vdisc.di_discount;
		   else
		           total := total*(1 - (vdisc.di_discount/100));
			     --  RecLine.rd_vip		:= 'E';  Early Biird 
		   end if;
		end if;
		close cdisc;
		
		
		RecLine.rd_due_tot	:= total;
		duetot 			:= nvl(duetot,0) + total;
		-- Previously check the names.
		Rc := 	splitName(line,fadults(line),fChild(line),fInfants(line),
			fname(line));
		Rc := InsertInformation(fpage,fhotel,frooming,fsource,fcontact,
				ftel,farrival,fdeparture,fnites,line);
		if Rc = -1 then
			raise OraError;
		end if;
		-- Save Information
		line := line + 1;
	end if;  -- NULL line?
	end loop;
	return(0);
exception
when no_data_found then
	return(0);
when oraError then
	rollback;
	return(-1);
when others then
	rollback;
	utl.panic('Error SaveRL ',sqlerrm||' line '|| to_char(nvl(line,0))||
	       ' hotel='||fhotel||' rooming #'||frooming||'#');
	return(-1);
end;
--********************    STAY
-- {
Procedure Stay(usr in varchar2) is
cursor listHotel is
select ho_hotel,initcap(ho_desc)
from rshotel
where upper(ho_desc) not like 'CALINDA%'
order by upper(ho_desc);
cursor crsource is
select * from rsource
order by so_desc;
cursor coperator is
select * from rsoperator
order by upper(op_name);
vho_hotel 	rshotel.ho_hotel%type;
vho_desc  	rshotel.ho_desc%type;
vrsource  	rsource%rowtype;
vrsoperator	rsoperator%rowtype;
nday 	number;
nmonth	number;
nyear 	number;
smonth  varchar2(20);
i 	number;
begin
	utl.prolog( 'Reservations','$win/reservations/CRS/mentry.stay',
			null,usr);
	htp.p('<script language="JavaScript">');
	htp.p('var mWindow=window;');
	--///////////////////////////////////////////
	htp.p('function cleanRate(){');
	htp.p('document.forms[0].fcharter.value="";');
	htp.p('};');
	--//////////////////////////////////////////
	htp.p('function LOVrates(){');
	htp.p('		frm = document.forms[0];');
	htp.p('		var url="/win/oas/pckgCRSRates.search?hotel=";');
	htp.p('		var imonth, iday, iyear, ihotel, ioperator;');
	htp.p('		imonth = document.forms[0].fmonth.selectedIndex;');
	htp.p('		iday   = document.forms[0].fday.selectedIndex;');
	htp.p('		iyear  = document.forms[0].fyear.selectedIndex;');
	htp.p('		ihotel = document.forms[0].fhotel.selectedIndex;');
	htp.p('		ioperator = document.forms[0].foperator.selectedIndex;');
	htp.p('		if (document.forms[0].fhotel.options[ihotel].lenght == 0) {');
	htp.p('			alert(''Please Select a Hotel'');');
	htp.p('			return false;');
	htp.p('		}');
	htp.p(' 	url = url + document.forms[0].fhotel.options[ihotel].value;');
	htp.p('		url = url + "&operator=" + document.forms[0].foperator.options[ioperator].value');
	htp.p('		url = url + "&Arrival=" + document.forms[0].fday.options[iday].value + "-"; ');
	htp.p('		url = url + document.forms[0].fmonth.options[imonth].value + "-"; ');
	htp.p('		url = url + document.forms[0].fyear.options[iyear].value; ');
	htp.p('		if(frm.fratetype.value!='''') {');
	htp.p('			url = url + "&fratetype=" + frm.fratetype.value;  } ');
	htp.p('		window.name="mWindow";');
	htp.p('		lwin=window.open(url,''lwin'',''scrollbars=yes,resizable=yes,status=yes,toolbar=no,width=750,height=550,top=100,left=100'');');
	htp.p('		return true;');
	htp.p('}');
	htp.p('	function goValidate()');
	htp.p('	{');
	htp.p('  var fecha=new Date();');
    htp.p('  var diames=fecha.getDate();');
    htp.p('  var diasemana=fecha.getDay();');
    htp.p('  var mes=fecha.getMonth() +1 ;');
    htp.p('  var ano=fecha.getFullYear();');
	htp.p('  var fechaa = ano+"/"+mes+"/"+diames;');
	htp.p('	with(document.forms[0]) ');
	htp.p('		{');
	htp.p('     var xfechas = fyear.value+"/"+fmonth.value+"/"+fday.value;');
	htp.p('     var f1 = new Date(fechaa);');
    htp.p('     var f2 = new Date(xfechas);');
	htp.p('     if (f2 < f1){alert(''Invalid Date''); return;}');
	htp.p('		if(fratetype.value=='''') {alert(''Error.\n\nPlease provide the Rate Type and then click Submit.''); return;}');
	htp.p('		submit();');
	htp.p('	 ');
	htp.p('		}');
	htp.p('	}');
	htp.p('</script>');
	htp.formOpen(path||'GetRL');
	htp.formHidden ('fusr',usr);
	htp.p('<center>');
	--utl.BorderTableOpen('S T A Y');
	htp.p('<TABLE  width=600 cellspacing=0 cellpadding=5 border=0 class="tableoutline" ID="shadow" align="center">');
	htp.tableRowOpen(cattributes=>'class="trblueNotop"');
      htp.tableData('S T A Y','center',ccolspan=>'100%',cattributes=>'class="txtboldcap"');
	htp.tableRowClose;
	--************* TOUR OPERATOR
	htp.tableRowOpen(cattributes=>'bgcolor="#EEEDF0"');
		htp.tableData('Tour Operator:','right',cattributes=>'width="220"');
		htp.p('<td>');
			htp.formSelectOpen('foperator');
			htp.formSelectOption(null);
			for vrsoperator in coperator loop
				htp.formSelectOption(initCap(vrsoperator.op_name),null,
					'value='||vrsoperator.op_id);
			end loop;
			htp.formSelectClose;
	htp.tableRowClose;
	--************* HOTEL
	htp.tableRowOpen;
		htp.tableData('Hotel:','right');
		htp.p('<td>');
			htp.p('<select name="fhotel" onChange=''cleanRate()''>');
			htp.formSelectOption(null);
			open listHotel;
			loop
				fetch listHotel into vho_hotel,vho_desc;
				exit when listHotel%NOTFOUND;
				htp.formSelectOption(ltrim(rtrim(vho_desc)),null,'value='||vho_hotel);
			end loop;
			htp.formSelectClose;
		htp.p('</td>');
		htp.tableRowClose;
	htp.tableRowOpen;
	--************* ARRIVAL
    htp.tableRowOpen(cattributes=>'bgcolor="#EEEDF0"');
			-- <<< Arrival
			nday 	:= to_number(to_char(sysdate+1,'dd'));
			nmonth 	:= to_number(to_char(sysdate+1,'mm'));
			nyear 	:= to_number(to_char(sysdate,'yyyy'));
			htp.tableData('Arrival:','right');
			htp.p('<td>');
				-- Month
				htp.formSelectOpen('fmonth');
				for i in 1..12 loop
					smonth:=to_char(to_date('01-'||i||'-1997','dd-mm-yyyy'),'Mon');
					if i = nmonth then
						htp.formSelectOption(smonth,'Selected','value='||i);
					else
						htp.formSelectOption(smonth,null,'value='||i);
					end if;
				end loop;
				htp.formSelectClose;
				-- Day
				htp.formSelectOpen('fday');
				for i in 1..31 loop
					if i = nday then
						htp.formSelectOption(i,'Selected','value='||i);
					else
						htp.formSelectOption(i,null,'value='||i);
					end if;
				end loop;
				htp.formSelectClose;
				htp.formSelectOpen('fyear');
				for i in 0..5 loop
					if i+nyear = nyear then
						htp.formSelectOption(i+nyear,'Selected',
					    	'value='||nyear);
					else
						htp.formSelectOption(i+nyear,null,'value='||
							to_char(nyear + i) );
					end if;
				end loop;
				htp.formSelectClose;
			htp.p('</td>');
	htp.tableRowClose;
	--************* NIGHTS
	htp.tableRowOpen;
		htp.tableData('Nights:','right');
			htp.p('<td>');
				htp.formSelectOpen('fnites');
				for i in 1..40 loop
					htp.formSelectOption(i);
				end loop;
				htp.formSelectClose;
			htp.p('</td>');
	htp.tableRowClose;
	--************   RATE OPERATOR
	htp.tableRowOpen(cattributes=>'bgcolor="#EEEDF0"');
		htp.tableData('Rate Op: ','right');
		htp.p('<td>');
			htp.formText('fcharter',9,8);
			htp.p('<a href="#main" class="bluelink" onClick=''LOVrates()''>');
			htp.bold('Search');
			htp.p('</a>');
		htp.p('</td>');
	htp.tableRowClose;
	--************   RATE TYPE
	htp.tableRowOpen;
	    htp.tableData('Rate Type: ','right');
		htp.tableData(htf.formtext('fratetype',8,2));
	htp.tableRowClose;
	--************  CONTACT NAME
	htp.formHidden('fcontact',null);
	htp.tableRowOpen(cattributes=>'bgcolor="#EEEDF0"');
	htp.p('<td align="center" colspan="100%">');
		htp.p('<input type=button value="Execute Query" class="button1" onClick="goValidate()">');
		htp.br;
	htp.p('</td>');
	htp.tableRowClose;
	htp.tableClose;
	--utl.BorderTableClose;
	htp.formHidden('fsource',null);
	htp.formHidden('ftel',null);
	htp.formHidden('frooming',null);
	htp.formHidden('fline','0');
	htp.formHidden('fagencyNmbr',null);
	htp.formHidden('fname',null);
	htp.formHidden('froomtype',null);
	htp.formHidden('fmeal1',null);
	htp.formHidden('fmeal2',null);
	htp.formHidden('fpackage',null);
	htp.formHidden('ffs',null);
	htp.formHidden('fadults','0');
	htp.formHidden('fChild','0');
	htp.formHidden('fInfants','0');
	htp.formHidden('fArrtimehh',null);
	htp.formHidden('fArrtimemi',null);
	htp.formHidden('fcarrier',null);
	htp.formHidden('fflight',null);
	htp.formHidden('fremarks',null);
	htp.formHidden('fpage','0');
	htp.formHidden('fdue_tot','0');
	htp.formHidden('faction','Begin');
	htp.formClose;
	htp.p('<center>');
	htp.bodyClose;
	htp.htmlClose;
end stay;
--*****************************************************************
-- Transfer the Rooming List from the Temporary Tables to the real
-- Rooming List Tables.
function TransferTMPrl (fhotel in varchar2, frooming in varchar2) return number is
begin
	-- RSRLHEAD
	insert into rsrlhead
		(RH_HOTEL, RH_NUMBER, RH_CHARTER, RH_SUBCHAR, RH_GROUP, RH_ARRIVAL,
		 RH_DEPART, RH_NITES, RH_SOURCE, RH_CONT_N, RH_CONT_T, RH_CANCEL,
		 RH_DEP_TOT, RH_DEP_REC, RH_DUE_TOT)
	(
		select RH_HOTEL, RH_NUMBER, RH_CHARTER, RH_SUBCHAR, RH_GROUP, RH_ARRIVAL,
		 RH_DEPART, RH_NITES, RH_SOURCE, RH_CONT_N, RH_CONT_T, RH_CANCEL,
		 RH_DEP_TOT, RH_DEP_REC, RH_DUE_TOT
		from rsrlhead_tmp
		where 	rh_hotel = fhotel
			and rh_number = frooming
	);
	-- RSRLDET
	Insert into rsrldet
	(RD_HOTEL, RD_NUMBER, RD_LINE, RD_ROOM, RD_RATE, RD_GUEST, RD_VIP, RD_ADULT,
	 RD_CHILD, RD_INFANT, RD_PLAN_1, RD_PLAN_2, RD_PACKAGE, RD_FIRST, RD_REM,
	 RD_ARR_TIME, RD_FLIGHT, RD_CARRIER, RD_INP_U, RD_INP_D, RD_INP_T, RD_RESERV,
	 RD_AGCY_CNF, RD_SPECIAL, RD_TRANS, RD_DEP_TOT, RD_DEP_REC, RD_DUE_TOT)
	 (
		select RD_HOTEL, RD_NUMBER, RD_LINE, RD_ROOM, RD_RATE, RD_GUEST, RD_VIP,
			 RD_ADULT, RD_CHILD, RD_INFANT, RD_PLAN_1, RD_PLAN_2, RD_PACKAGE,
			 RD_FIRST, RD_REM, RD_ARR_TIME, RD_FLIGHT, RD_CARRIER, RD_INP_U,
			 RD_INP_D, RD_INP_T, RD_RESERV, RD_AGCY_CNF, RD_SPECIAL, RD_TRANS,
			 RD_DEP_TOT, RD_DEP_REC, RD_DUE_TOT
		from rsrldet_tmp
		where 	rd_hotel = fhotel
			and rd_number = frooming
	);
	-- RSRLNAME
	Insert into rsrlname
	(RN_HOTEL, RN_NUMBER, RN_LINE, RN_SEQUENCE, RN_LAST_N, RN_FIRST_N)
	(
		select RN_HOTEL, RN_NUMBER, RN_LINE, RN_SEQUENCE, RN_LAST_N, RN_FIRST_N
		from rsrlname_tmp
		where 	rn_hotel = fhotel
			and rn_number = frooming
	);
	delete from rsrlname_tmp where rn_hotel = fhotel and rn_number = frooming;
	delete from rsrldet_tmp where rd_hotel = fhotel and rd_number = frooming;
	delete from rsrlhead_tmp where rh_hotel = fhotel and rh_number = frooming;
	return (0);
end TransferTMPrl;
--*****************************************************************
function CheckAvailability(fhotel in varchar2 ,fcharter in varchar2,
	frooming in varchar2, farrival in varchar2, fdeparture in varchar2)
return number is
xC 		number := 0;
xrooms	number := 0;
begin
select count(*)
into xrooms
from rsrldet
where 	rd_hotel = fhotel
and 	rd_number = frooming;
if xrooms > 0 then
		xC := -1;
		select count(*)
		into xC
		from rsavailable
		where 	av_hotel = fhotel
			and	av_charter = fcharter
			and av_date between farrival and fdeparture
			and (av_allotment-av_res) < xrooms
			and av_room in (
				select unique rd_room
				from rsrldet
				where 	rd_hotel = fhotel
					and rd_number = frooming
			);
		if xC <> 0 then
			return (1);
		end if;
end if;
return (0);
exception
when others then
utl.panic('CheckAvailability Error ',sqlerrm);
return(-1);
end CheckAvailability;
--*************************************************************
--
function TransferRL (fhotel in varchar2, frooming in varchar2) return number is
--
cursor c1 (XHOTEL varchar2, XROOMING in varchar2) is
select rd_hotel, rd_number, rd_line, rd_room
  from rsrldet
 where rd_hotel  = XHOTEL
   and rd_number = XROOMING
   and nvl(rd_trans,'N') != 'Y'
 order by rd_line;
--
VC1 	c1%rowtype;
xho_res	rshotel.ho_res%type;
dummy	number;
begin
--
  	open c1(fhotel,frooming);
   	loop
	  fetch c1 into VC1;
	  exit when c1%notfound;
		LOCK TABLE RSHOTEL IN SHARE UPDATE MODE;
        update rshotel
        	set ho_res = LPAD(TO_CHAR(NVL(TO_NUMBER(ho_res),0)+1),6,'0')
                where ho_hotel = fhotel;
		commit;
		select ho_res
		into xho_res
		from rshotel
		where ho_hotel = fhotel;
        
        
			/*    Insert Reservations RSMANAMES  */
        insert into rsmanames
        (mn_hotel,mn_reserv,mn_sequence,mn_last_n,mn_first_n)
        select rn_hotel,LPAD(ho_res,6,'0'),
        	rn_sequence,nvl(rn_last_n,'**TBA**'),
        	nvl(rn_first_n,'**TBA')
       	from rsrlname, rshotel
        where rn_hotel  = fhotel
       		and rn_number = frooming
            and rn_line   = VC1.rd_line
            and ho_hotel  = rn_hotel;
			commit;
          		/* Inserts Names  */
                
	      insert into rsmaes
          ( ma_hotel, ma_reserv, ma_charter, ma_subchar, ma_group,
            ma_guest, ma_vip, ma_source, ma_cont_n, ma_cont_t,
            ma_arrival, ma_depart, ma_nites, ma_arr_time, ma_flight,
            ma_carrier, ma_room, ma_rate, ma_adult, ma_child, ma_infant,
            ma_plan_1, ma_plan_2, ma_package, ma_first, ma_rem_user,
            ma_rem_sys, ma_cancel, ma_inp_u, ma_inp_d, ma_inp_t,
            ma_rooming, ma_line, ma_due_tot, ma_dep_rec, ma_dep_tot,
            ma_agcy_cnf, ma_special,ma_voucher,
            ma_start_d,
            ma_ind1,
            ma_dob1,
            ma_tri1,
            ma_qua1,
            ma_adition1,
            ma_end_d1,
            ma_ind2,
            ma_dob2,
            ma_tri2,
            ma_qua2,
            ma_adition2,
            ma_end_d2,
            ma_ind3,
            ma_dob3,
            ma_tri3,
            ma_qua3,
            ma_adition3,
            ma_end_d3,
            ma_divisa
            )
            select rh_hotel, LPAD(ho_res,6,'0'),
                rh_charter, rh_subchar, rh_group, rd_guest, rd_vip,
                rh_source, rh_cont_n, rh_cont_t, rh_arrival, rh_depart,
                rh_nites, rd_arr_time, rd_flight, rd_carrier, rd_room,
                rd_rate, rd_adult, rd_child, rd_infant, rd_plan_1,
                rd_plan_2, rd_package, rd_first, rd_rem, '', rh_cancel,
                rd_inp_u, to_char(sysdate), to_char(sysdate,'HH24MI'),
		rd_number, rd_line, rd_due_tot, rd_dep_rec, rd_dep_tot,
		rd_agcy_cnf, rd_special,rd_agcy_cnf,
                rd_start_d,
                rd_ind1,
                rd_dob1,
                rd_tri1,
                rd_qua1,
                rd_adi1,
                rd_end_d1,
                rd_ind2,
                rd_dob2,
                rd_tri2,
                rd_qua2,
                rd_adi2,
                rd_end_d2,
                rd_ind3,
                rd_dob3,
                rd_tri3,
                rd_qua3,
                rd_adi3,
                rd_end_d3,
                rd_divisa
			from rsrldet, rsrlhead, rshotel
            where rd_hotel  	= fhotel
            	and rd_number 	= frooming
                and rd_line   	= vc1.rd_line
                and rh_hotel  	= rd_hotel
                and rh_number 	= rd_number
                and ho_hotel  	= rh_hotel;
              --
		update rsrldet
        set rd_trans  = 'Y',
       		rd_reserv =
            ( select LPAD(ho_res,6,'0')
              from rshotel
			  where ho_hotel = fhotel
			)
        where rd_hotel 	= fhotel
        	and rd_number 	= frooming
        	and rd_line   	= VC1.rd_line;
		commit;
	end loop;
    close c1;
	return 0;
-- exception
-- when others then
--	utl.panic('TransferRL hotel= '|| fhotel||' Rooming= '||frooming ||' reservation= '||xho_res||' Error',sqlerrm);
	-- return (-1);
end TransferRL;
--***************************************************************************
--*********
procedure ReservPWD (fusr in varchar2, fhotel in varchar2, frooming in varchar2,
			fpassword in varchar2, faction in varchar2 default 'SUBMIT') is
cursor c1  is
select *
from rspassword
where pa_dep = 'R';
vrspassword		rspassword%rowtype;
Rc				number;
OraError		exception;
begin
	if faction = 'GetPassword' then
		utl.prolog('Reservations Manager', '$win/reservations/mentry.ReservPWD',
					null, fusr);
		htp.p('<table width=100%>');
		htp.tableRowOpen;
		htp.p('<td align="center" bgcolor="#FF9900">');
			utl.textb(2,'OUT OF ALLOTMENT','FFFFFF');
		htp.p('</td>');
		htp.tableRowClose;
		htp.tableClose;
		roominglist.pInfo(fhotel,frooming);
		htp.br;
		htp.formOpen('mentry.ReservPWD');
		htp.formHidden('fusr',fusr);
		htp.formHidden('fhotel',fhotel);
		htp.formHidden('frooming',frooming);
		utl.centerOn;
		htp.tableOpen;
		htp.p('<td>');
			utl.textb(2,'Reservation Manager Password');
		htp.p('</td>');
		htp.p('<td>');
			htp.formPassword('fpassword',9,9);
		htp.p('</td>');
		htp.tableClose;
		htp.br;
		htp.br;
		htp.formSubmit('faction','Check Password');
		htp.formClose;
		utl.centerOff;
		utl.epilog;
	elsif faction = 'Check Password' then
		open c1;
		fetch c1 into vrspassword;
		close c1;
		if ltrim(rtrim(upper(fpassword))) <>
		   ltrim(rtrim(upper(vrspassword.pa_pass))) then
			mentry.ReservPWD (fusr, fhotel, frooming, fpassword, 'GetPassword');
			return;
		end if;
		Rc := TransferRL (fhotel, frooming);
		if Rc <> 0 then
			raise OraError;
		end if;
		-- REPORT ROOMING LIST
		--<><><> Showing the final rooming list
		RoomingList.report(fusr,fhotel,frooming,null);
		utl.fontOpen(2);
		htp.formOpen('mentry.stay');
		htp.formHidden('usr',fusr);
		htp.formSubmit(null,'New Rooming List');
		htp.formClose;
		utl.fontClose;
	else
		htp.header(2,'Nada');
	end if;
exception
when  oraError then
	null;
end;
--******************************************************************
-- Get Rooming List Names
-- {
procedure GetRL(
	fusr		in varchar2,
	foperator	in varchar2,
	fhotel 		in varchar2,
	fmonth 		in number,
	fday 		in number,
	fyear 		in number,
	fnites 		in number,
	fcharter	in varchar2,
	fcontact 	in varchar2,
	fsource 	in varchar2,
	ftel 		in varchar2,
	frooming	in varchar2,
	fline		in owa_util.ident_longarr,
	fagencyNmbr	in owa_util.ident_longarr,
	fname		in owa_util.ident_longarr,
	froomtype	in owa_util.ident_longarr,
	fmeal1		in owa_util.ident_longarr,
	fmeal2		in owa_util.ident_longarr,
	fpackage	in owa_util.ident_longarr,
	ffs			in owa_util.ident_longarr,
	fadults		in owa_util.ident_longarr,
	fChild		in owa_util.ident_longarr,
	fInfants	in owa_util.ident_longarr,
	fArrtimehh	in owa_util.ident_longarr,
	fArrtimemi	in owa_util.ident_longarr,
	fcarrier	in owa_util.ident_longarr,
	fflight		in owa_util.ident_longarr,
	fremarks	in owa_util.ident_longarr,
	fpage		in number ,
	fdue_tot	in number ,
	faction 	in varchar2,
	fratetype	in varchar2 default '') is  -- Current page number
    
    
cursor crsroom (xro_hotel varchar2) is
select * from rsroom
where ro_hotel = xro_hotel;

cursor cRoom(xhotel varchar2, xcharter varchar2, xtype varchar2, xarrival date, xnights number) is
select distinct nvl( cd_room,'ROH') cd_room
from rsconhed, rscondet
where ch_hotel = xhotel
    and ch_charter = xcharter
    and ch_type = xtype
    and xarrival between ch_sta_sea and ch_end_sea
  --  and xarrival+xnights-1 between ch_sta_sea and ch_end_sea
    and ch_activ ='Y'
    and cd_hotel = ch_hotel
    and cd_charter = ch_charter
    and cd_type = ch_type
    and cd_end_sea = ch_end_sea;
    


cursor crsplanes (xcp_hotel varchar2,xcp_charter varchar2, xarrival date) is
select *
from rscoplan
where 	cp_hotel = xcp_hotel
and cp_charter = xcp_charter
and xarrival between cp_sta_sea and cp_end_sea;

cursor c3 (xhotel varchar2, xcharter varchar2, xarrival date, xdepart date, xrate varchar2) is
select *
from rsconhed
where 	ch_hotel = xhotel
and ch_charter = xcharter
and ch_type = xrate
and nvl(ch_activ,'N') = 'Y'
and xarrival between ch_sta_sea and ch_end_sea;

cursor c4 (xhotel varchar2) is
select *
from rspackage
where 	pk_hotel = xhotel
and nvl(pk_activ,'N') = 'Y'
order by pk_desc;

cursor c5  is
select *
from rscarrier
order by ca_desc;

cursor c6(XHOTEL varchar2, XCHARTER varchar2, XARRIVAL date,
		  XNITES number ) is
select *
from rsrlhead
where 	rh_hotel = XHOTEL
	and rh_charter = XCHARTER
	and rh_arrival = XARRIVAL
	and rh_nites = XNITES;
    
cursor c7 (xhotel varchar2, xcharter varchar2, xarrival date, xdepart date, xrate varchar2) is
select *
from rsconhed
where 	ch_hotel = xhotel
and ch_charter = xcharter
and ch_type = xrate
and nvl(ch_activ,'N') = 'N'
and (xarrival between ch_sta_sea and ch_end_sea
or   xdepart  between ch_sta_sea and ch_end_sea);


cursor c8(xCharter varchar2) is
select nvl(op_res_currency, op_inv_currency) op_res_currency
from rsoperator, rsopecharter
where  op_id = oc_operator
    and  oc_charter = xCharter;


vrspackage	rspackage%rowtype;
vrsplanes	rsplanes%rowtype;
vrsroom		rsroom%rowtype;
vrsconhed	rsconhed%rowtype;
vrscarrier	rscarrier%rowtype;
vrsrlhead	rsrlhead%rowtype;
vc8             c8%rowtype;
vho_rooming	rshotel.ho_rooming%type;
vho_desc	rshotel.ho_desc%type;
vRoom   cRoom%rowtype;
varrival 	date;
vdeparture 	date;
vroomdisplay	number;
vroomnumber	number;
Rc		number;
xline		number;
duetot		number(16,2) := 0;
bMealPlan	varchar2(1);
buttonMessage   varchar2(50) := 'Next Rooms';
ErrorFounded 	exception;
ShowError 		exception;
OraError 		exception;
InvalidCharter	exception;
vcolor      varchar2(7):='#eeedf0';
begin
htp.p('<link REL="STYLESHEET" HREF="/lib/style.css" TYPE="text/css" media="screen">');
-- Error List
ListError(0)	:= 'System Error';
ListError(1)	:= 'No names founded';
ListError(2)	:= 'No Last Name founded';
ListError(3)	:= 'No First Name founded';
ListError(4) 	:= 'So many names founded';
ListError(5) 	:= 'Hotel Closed';
ListError(6) 	:= 'Charter Closed';
ListError(7) 	:= 'Market Closed';
ListError(8) 	:= 'Invalid Hotel-Charter-Arrival Combination';
ListError(9) 	:= 'No Tour Operator confirmation founded';
varrival 	:= to_date(fday||'-'||fmonth||'-'||fyear,'DD-MM-YYYY');
vdeparture 	:= varrival + fnites;
--<<<<<<<<<<    VALIDATION SECTION
	-- VALIDATE HOTEL - CHARTER - ARRIVAL
	open c3(fhotel,fcharter,varrival,vdeparture, fratetype);
	fetch c3 into vrsconhed;
	if c3%NOTFOUND then
		raise InvalidCharter;
	end if;
	close c3;
	-- VALIDATE HOTEL - CONTRACT
	open c7(fhotel,fcharter,varrival,vdeparture, fratetype);
	fetch c7 into vrsconhed;
	if c7%FOUND then
		raise InvalidCharter;
	end if;
	close c7;
	-- HOTEL CLOSED
	Rc := 0;
	Rc := pckgCRSHotel.HotelClosed(fhotel,fcharter,varrival,vdeparture);
	if Rc > 0 then
		if Rc = 1 then
			Rc := 5;
		elsif Rc = 2 then
			Rc := 6;
		elsif Rc = 3 then
			Rc := 7;
		else
			Rc := 5;
		end if;
		raise ShowError;
	elsif Rc < 0 then
		raise OraError;
	end if;
--<<<<<<<< Hotel Name
select ho_desc
into vho_desc
from rshotel
where ho_hotel = fhotel;
if faction = 'Save Rooming List' then
	--=== GET ROOMING LIST NUMBER
	select (ho_rooming + 1)
	into vho_rooming
	from rshotel
	where ho_hotel = fhotel
	for update of ho_rooming;
	update rshotel set ho_rooming = nvl(ho_rooming,0)+1 where ho_hotel = fhotel;
	--====== VERIFY THE NAMES
	Rc := CheckNames(fpage,fname,fadults,fChild,fInfants,xline, fagencyNmbr);
	if Rc = -1 then
		raise OraError;
	elsif Rc > 0 then
		raise ErrorFounded;
		-- The error is showed in the called function.
	end if;
    
    -- In case RSCONHED.CH_DIVISA IS NULL then get it from the tour operator divisa
    if (ltrim(vrsconhed.ch_divisa) is null) then
        open c8(fcharter);   
        fetch c8 into vc8;
        close c8;
        
        vrsconhed.ch_divisa := nvl(vc8.op_res_currency,'USD');
    end if;
    
	--====== SAVE Rooming List
	Rc := SaveRL (fusr, fpage, fhotel, vho_rooming, fsource, fcontact,
				ftel, fmonth, fday, fyear, fnites, fline, fagencyNmbr,
				fname, froomtype, fmeal1, fmeal2, fpackage, ffs	,
				fadults, fChild, fInfants, farrtimehh, farrtimemi,
				fcarrier, fflight, fremarks	, fcharter, duetot, fratetype, vrsconhed.ch_divisa);
                
          
	--*********** CHECK AVAILABILITY
	Rc := CheckAvailability(fhotel,fcharter,vho_rooming,varrival,vdeparture);
	if Rc < 0 then
			raise OraError;
	end if;
	--*********** TRANFERING ROOMING LIST
	Rc := TransferRL(fhotel,vho_rooming);
	if Rc < 0 then
		raise OraError;
	elsif Rc > 0 then
		raise ErrorFounded;
	end if;
	--*********** SHOWING THE FINAL CONFIRMATION REPORT
	RoomingList2.Report(fusr,fhotel,vho_rooming,null);
	utl.fontOpen(2);
	utl.centerON;
	htp.tableOpen;
	htp.tableRowOpen;
	htp.p('<td>');
	  	htp.formOpen('mentry.GetRL');
		htp.formHidden ('fusr',fusr);
		htp.formHidden('foperator',foperator);
		htp.formHidden('fhotel',fhotel);
		htp.formHidden('fmonth',fmonth);
		htp.formHidden('fday',fday);
		htp.formHidden('fyear',fyear);
		htp.formHidden('fnites',fnites);
		htp.formHidden('fcharter',fcharter);
		htp.formHidden('fcontact',null);
		htp.formHidden('fsource',null);
		htp.formHidden('ftel',null);
		htp.formHidden('frooming',null);
		htp.formHidden('fline','0');
		htp.formHidden('fagencyNmbr',null);
		htp.formHidden('fname',null);
		htp.formHidden('froomtype',null);
		htp.formHidden('fmeal1',null);
		htp.formHidden('fmeal2',null);
		htp.formHidden('fpackage',null);
		htp.formHidden('ffs',null);
		htp.formHidden('fadults','0');
		htp.formHidden('fChild','0');
		htp.formHidden('fInfants','0');
		htp.formHidden('fArrtimehh',null);
		htp.formHidden('fArrtimemi',null);
		htp.formHidden('fcarrier',null);
		htp.formHidden('fflight',null);
		htp.formHidden('fremarks',null);
		htp.formHidden('fpage','0');
		htp.formHidden('fdue_tot','0');
		htp.formhidden('fratetype',fratetype);
		--htp.formHidden('faction','Begin');
		htp.formSubmit('faction','Continue Rooming List');
		htp.formClose;
	htp.p('</td>');
	htp.p('<td>');
		htp.formOpen('mentry.stay');
		htp.formHidden('usr',fusr);
		htp.formSubmit(null,'New Rooming List');
		htp.formClose;
	htp.p('</td>');
	htp.tableRowClose;
	htp.tableClose;
	utl.fontClose;
	utl.centerOff;
	return;
-- New rooming list number
else
	RepArrivals.CRSNames(fusr, fhotel, fcharter, vArrival,fnites);
end if;
--utl.prolog('Reservations', null,null,null);
htp.p('<html>');
htp.p('<head><title>Rooming List</title></head>');
htp.p('<script language="JavaScript">');
htp.p(' function setWinName()');
htp.p('{');
htp.p('  this.name="WINBODY";');
htp.p('}');
htp.p('</script>');
htp.p('<body onLoad="setWinName()">');
htp.formOpen(path||'GetRL');
htp.formHidden('fusr',fusr);
htp.formHidden('foperator',foperator);
htp.formHidden('fpage',nvl(fpage,1) + 1);
htp.formHidden('fhotel',fhotel);
htp.formHidden('frooming',vho_rooming);
htp.formHidden('fsource',fsource);
htp.formHidden('fcontact',fcontact);
htp.formHidden('ftel',ftel);
htp.formHidden('fmonth',fmonth);
htp.formHidden('fday',fday);
htp.formHidden('fyear',fyear);
htp.formHidden('fnites',fnites);
htp.formHidden('fcharter',fcharter);
htp.formHidden('fdue_tot', (nvl(fdue_tot,0) + nvl(duetot,0)));
htp.formhidden('fratetype',fratetype);
htp.p('<TABLE  width=100% cellspacing=0 cellpadding=5 border=0 class="tableoutline" ID="shadow" align="center">');
htp.tableRowOpen;
htp.p('<td align="left">');
	pckgOperator.procInfo(fOperator,null,'N');
htp.p('</td>');
htp.p('<td align="right">');
	pckgCRSHotel.printaddress(fHotel);
htp.p('</td>');
htp.tableRowClose;
htp.tableClose;
htp.p('<center>');
htp.br;
htp.p('<TABLE  width=100% cellspacing=0 cellpadding=5 border=0 class="tableoutline" ID="shadow" align="center">');
htp.tableRowOpen(cattributes=>'class="trblueNotop"');
    htp.tableData('R O O M I N G &nbsp&nbsp L I S T','center',ccolspan=>'100%',cattributes=>'class="txtboldcap"');
htp.tableRowClose;
htp.tableRowOpen(cattributes=>'bgcolor="#CCCCCC"');
    htp.p('<td colspan="100%" align="center">');
	 htp.tableOpen(' cellspacing=0 cellpadding=5 border=0');
	  htp.tableRowOpen;
	   htp.tableData('Arrival: ',cattributes=>'class="txttenpointbold"');
	   htp.tableData(varrival,cattributes=>'class="txttenpoint"');
	   htp.tableData('Departure: ',cattributes=>'class="txttenpointbold"');
	   htp.tableData(vdeparture,cattributes=>'class="txttenpoint"');
	   htp.tableData('Rate Type: ',cattributes=>'class="txttenpointbold"');
	   htp.tableData(fcharter,cattributes=>'class="txttenpoint"');
	   htp.tableData('Page: ',cattributes=>'class="txttenpointbold"');
	   htp.tableData(to_char(nvl(fpage,1)+1),cattributes=>'class="txttenpoint"');
	 htp.tableClose;
	htp.p('</td>');
htp.tableRowClose;
-- Header
htp.tableRowOpen(cattributes=>'bgcolor="#CCCCCC"');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Ln');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Voucher');
	htp.br;
	htp.bold('Number');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Passengers Name');
	htp.br;
	htp.bold('LName/FName,LName/FName');
	htp.p('</font>');
htp.p('</td>');
--htp.p('<td align="center" valign="center">');
	--htp.p('<font size=1>');
	--htp.bold('FName');
	--htp.p('</font>');
--htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Room');
	htp.br;
	htp.bold('Type');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Meal');
	htp.br;
	htp.bold('1');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Meal');
	htp.br;
	htp.bold('2');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Pckg');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('F');
	htp.br;
	htp.bold('S');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Ad');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Ch');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('In');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Arr Time');
	htp.br;
	htp.bold('HH:MI');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Crr');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Flt');
	htp.p('</font>');
htp.p('</td>');
htp.p('<td align="center" valign="center">');
	htp.p('<font size=1>');
	htp.bold('Remarks');
	htp.p('</font>');
htp.p('</td>');
htp.tableRowClose;
-- Body
for i in 1..MAXROOMPAGE loop --{
		--========== LINE
		htp.tableRowOpen(cattributes=>'bgcolor='||vcolor);
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.bold(i + (fpage * MAXROOMPAGE));
			htp.formHidden('fline',i + (fpage * MAXROOMPAGE));
			htp.p('</font>');
		htp.p('</td>');
		--========== AGNCY CONFIRMATION
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formText('fagencyNmbr',5,15);
			htp.p('</font>');
		htp.p('</td>');
		--========== NAMES
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formtextarea('fname',2,20);
			htp.p('</font>');
		htp.p('</td>');
		--========== ROOM TYPE
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('froomtype');
            
            
            for vRoom in cRoom (fhotel,fCharter, fratetype, varrival, fnites) loop
                htp.formSelectOption(vRoom.cd_room);
            end loop;
            /*
			for vrsroom in crsroom(fhotel) loop
				htp.formSelectOption(vrsroom.ro_room);
			end loop;
            */
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== MEAL 1
		htp.p('<td align="center">');
			bMealPlan := 'N';
			htp.p('<font size=1>');
			htp.formSelectOpen('fmeal1');
			htp.formSelectOption(' ');
			for vrscoplan in crsplanes(fhotel,fcharter,varrival) loop
				htp.formSelectOption(vrscoplan.cp_plan);
				bMealPlan := 'Y';
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== MEAL 2
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('fmeal2');
			htp.formSelectOption(' ');
			for vrscoplan in crsplanes(fhotel,fcharter,varrival) loop
				htp.formSelectOption(vrscoplan.cp_plan);
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== PACKAGE
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('fpackage');
			htp.formSelectOption(null);
			for vrspackage in c4(fhotel) loop
				htp.formSelectOption(vrspackage.pk_pack,null,
						'value='||vrspackage.pk_pack);
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== FIRST SERVICE
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('ffs');
			htp.formSelectOption(' ');
			if bMealPlan = 'Y' then
				htp.formSelectOption('B');
				htp.formSelectOption('L');
				htp.formSelectOption('D');
			end if;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== ADULTS
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('fadults');
			for i in 1..MAXADULTS loop
				if i = 2 then
					htp.formSelectOption(i,'selected');
				else
					htp.formSelectOption(i);
				end if;
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== CHILDREN
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('fChild');
			for i in 0..MAXCHILD loop
				htp.formSelectOption(i);
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== INFANT
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('fInfants');
			for i in 0..MAXINFANT loop
				htp.formSelectOption(i);
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== ARRIVAL TIME
		htp.p('<td nowrap align="center">');
			htp.p('<font size=1>');
			htp.formText('farrtimehh',3,2);
			htp.p(':');
			htp.formText('farrtimemi',3,2);
			htp.p('</font>');
		htp.p('</td>');
		--========== CARRIER
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formSelectOpen('fcarrier');
			htp.formSelectOption(null);
			for vrscarrier in c5 loop
				htp.formSelectOption(vrscarrier.ca_desc,null,
						'value='||vrscarrier.ca_carrier);
			end loop;
			htp.formSelectClose;
			htp.p('</font>');
		htp.p('</td>');
		--========== FLIGHT
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formText('fflight',4,5);
			htp.p('</font>');
		htp.p('</td>');
		--========== REMARKS
		htp.p('<td align="center">');
			htp.p('<font size=1>');
			htp.formText('fremarks',15,40);
			htp.p('</font>');
		htp.p('</td>');
		htp.tableRowClose;
		if vcolor = '#eeedf0' then vcolor := '#FFFFFF';
        else vcolor := '#eeedf0'; end if;
end loop; --}
htp.tableClose;
htp.br;
htp.br;
htp.p('<center>');
htp.formSubmit('faction','Save Rooming List');
--htp.formSubmit('faction','Next Rooms');
htp.p('</center>');
htp.br;
htp.formClose;
utl.epilog;
exception
	when InvalidCharter then
		utl.panic('Error Groups:','Invalid Rate Type or contract not activated');
		return;
	when ErrorFounded then
		utl.panic('Error getting Rooming: ',ListError(Rc)||' Line '||xline);
		return;
	when ShowError then
		utl.panic('Error GetRL: ',ListError(Rc));
		return;
	when OraError then
		null; -- The error is showed in the Routine;
		return;
	--when others then
		--rollback;
		--utl.panic('Error GetRL ',sqlerrm);
end GetRL ; --Entry List Detail }
begin
	null;
end;
/