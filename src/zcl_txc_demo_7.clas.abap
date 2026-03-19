CLASS zcl_txc_demo_7 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
     methods: side_by_side.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_7 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

  out->write( 'Demo 7 - EML Read' ).

    READ ENTITIES OF I_BusinessPartnerTP_3   "Which BusinessObject?
         ENTITY businesspartner              "Which Entity? BusinessPartner, Address, ...
         FIELDS ( BusinessPartner OrganizationBPName1 OrganizationBPName2 ) "Exactly which fields. Typed, from the CDS definition.
         WITH VALUE #( ( BusinessPartner = '0000000171'  ) "The key. Always a table - could be a whole table of keys.
                       ( BusinessPartner = '0000000001'  ) )
         RESULT DATA(result_partner) "Structured response
         FAILED   DATA(read_failed)
         REPORTED DATA(read_reported).

    loop at result_partner assigning field-symbol(<partner>).
       out->write( <partner>-BusinessPartner && ` , ` && <partner>-OrganizationBPName1 ).
    endloop.

  ENDMETHOD.

  METHOD side_by_side.

    READ ENTITIES OF I_BusinessPartnerTP_3
         ENTITY businesspartner
         FIELDS ( BusinessPartner OrganizationBPName1 OrganizationBPName2 )
         WITH VALUE #( ( BusinessPartner = '0000000171'  ) )
         RESULT DATA(result_partner)
         FAILED   DATA(read_failed)
         REPORTED DATA(read_reported).

    DATA lt_messages    TYPE bapiret2_t.
    DATA l_organization TYPE bapibus1006_central_organ.

    CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
      EXPORTING businesspartner         = '0000000171'
      IMPORTING centraldataorganization = l_organization
      TABLES    return                  = lt_messages.

  ENDMETHOD.

ENDCLASS.
