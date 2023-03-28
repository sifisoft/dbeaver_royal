


select *
from nmNomina_empleado
where ne_company = 110 and ne_numero_nomina = 201515 and ne_seq_folio is null and exists (
    select 1
    from nmTimbrado
    where ti_company = ne_company 
        and ti_empleado = ne_empleado
        and ti_numero_nomina = ne_numero_nomina
        and ti_status = 'T'
)        
    

select * from nmTimbrado



update nmNOmina_empleado
set ne_seq_folio = 1 , 
    ne_pac_uddi = (
        select ti_uuid
        from nmTimbrado
        where ti_company = ne_company 
            and ti_empleado = ne_empleado
            and ti_numero_nomina = ne_numero_nomina
            and ti_status = 'T'
    )
where ne_company = 110 and ne_numero_nomina = 201515 and ne_seq_folio is null and exists (
    select 1
    from nmTimbrado
    where ti_company = ne_company 
        and ti_empleado = ne_empleado
        and ti_numero_nomina = ne_numero_nomina
        and ti_status = 'T'
)        
         
    



    
    