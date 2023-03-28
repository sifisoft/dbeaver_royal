CREATE OR REPLACE package travamerica_utils  is
    function getNombre(pReserv in varchar2, pPosition in varchar2) return varchar2;
    function getApellido(pReserv in varchar2, pPosition in varchar2) return varchar2;
    function getPlan(pReserv in varchar2, pPosition in varchar2) return varchar2;
end;
/

CREATE OR REPLACE package body travamerica_utils is 
    function getNombre(pReserv in varchar2, pPosition in varchar2) return varchar2 is
    cursor c1(xReserv in varchar2, xPosition in varchar2) is
    select * from freserno where vn_reserva = xReserv and vn_secuencia = xPosition; 
    
    vc1     c1%rowtype;
    begin
        open c1(pReserv, pPosition);
        fetch c1 into vc1;
        close c1;
        
        return vc1.vn_nombre;
    end;
    
    function getApellido(pReserv in varchar2, pPosition in varchar2) return varchar2 is
    cursor c1(xReserv in varchar2, xPosition in varchar2) is
    select * from freserno where vn_reserva = xReserv and vn_secuencia = xPosition;
    
    vc1     c1%rowtype; 
    begin
        open c1(pReserv, pPosition);
        fetch c1 into vc1;
        close c1;
        
        return vc1.vn_apellido;
    end;

    
    
    function getPlan(pReserv in varchar2, pPosition in varchar2) return varchar2 is
    cursor c1(xReserv in varchar2, xPosition in varchar2) is
    select * from freserpl where vp_reserva = xReserv and vp_secuencia = xPosition;
    vc1     c1%rowtype; 
    begin
        open c1(pReserv, pPosition);
        fetch c1 into vc1;
        close c1;
        
        return vc1.vp_plan;
    end;
    
end;
/
