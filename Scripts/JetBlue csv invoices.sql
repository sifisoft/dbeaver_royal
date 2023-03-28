set heading off verify off feedback off echo off term off linesize 10000 trimout on trimspool on timing off

spool /Users/alfredozarza/Downloads/jetblueTestInvoices.xls

select /*csv*/ 'IP000115'   CustomerID,
       '1000'               BusinessUnit,
       in_inv_num           InvoiceNbr,
       to_char(in_inv_date,'mm/dd/yy')  InvoiceDate,
       null                 PONbr,
       'ZN10'               TermsCode,
       'USD'                CurrencyCode,
       0                    InvoiceTax,
       0                    InvoiceFreigh,
       in_a_total           InvoiceTotal,
       null                 Notes,
       'JetBlue'            Loc1Name1,
       null                 Loc1Name2,
       'Two Hampshire Street'   LocStreet1,
       null                 Loc1Street2,
       'FOXBORO'            Loc1City,
       'MA'                 Loc1State,
       '2035'               Loc1Zip,
       'US'                 Loc1Country,
       'CreditCard'         CreditCard,
       'CJONES'             HeaderCustomField1,
       null                 HeaderCustomFilld2,
       null                 HeaderCustomField3,
       null                 HeaderCustomField4,
       'Debit'              HeaderCustomField5,
       null                 HeaderCustomField6,
       null                 HeaderCustomField7,
       null                 HeaderCustomField8,
       null                 HeaderCustomField9,
       null                 HeaderCustomField10,
       null                 HeaderCustomField11,
       null                 HeaderCustomField12,
       null                 HeaderCustomField13,
       null                 HeaderCustomField14,
       null                 HeaderCustomField15,
      1                     LineNbr,
      1                     POLineNbr,
      1                     Quantity,
      'EA'                  UOfMCode,
      in_voucher            PartNbr,
      CONTA.GETGUESTNAME(in_hotel, in_reserv)     ItemDescription,
      in_a_total            UnitPrice,
      null                  LineTax,
      null                  LineFreight,
      in_agcy_cnf           LineCustomField1,
      HO_DESC               LineCustomField2,
      in_wholes             LineCustomField3,
      to_char(in_arrival,'mm/dd/yy')      LineCustomField4,
      to_char(in_depart,'mm/dd/yy')       LineCustomField5,
      in_reserv             LineCustomField6,
      in_room               LineCustomField7,
      in_adult              LineCustomField8,
      in_child              LineCustomField9,
      in_infant             LineCustomField10,
      null                  LineCustomField11,
      null                  LineCustomField12,
      null                  LineCustomField13,
      null                  LineCustomField14,
      null                  LineCustomField15,
      '!'                   EndOfLine
from rinvoice, rshotel, rsopecharter
where in_hotel = ho_hotel
  and oc_operator = 'JETBLUE' 
  and in_wholes = oc_charter
;
    