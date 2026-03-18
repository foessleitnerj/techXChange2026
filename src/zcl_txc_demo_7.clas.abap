CLASS zcl_txc_demo_7 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
     class-data l_difference type p decimals 2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_7 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

  out->write( 'Demo 7 - EML Read' ).

   get run time field data(l_from).

    READ ENTITIES OF I_BusinessPartnerTP_3
         ENTITY businesspartner
         FIELDS ( BusinessPartner OrganizationBPName1 OrganizationBPName2 )
         WITH VALUE #( ( BusinessPartner = '0000000065'  ) )
         RESULT DATA(result_partner)
         FAILED   DATA(read_failed)
         REPORTED DATA(read_reported).

    get run time field data(l_to).
    l_difference = ( l_to - l_from ) / 1000000.

    out->write( result_partner[ 1 ]-BusinessPartner && ',' && result_partner[ 1 ]-OrganizationBPName1 && ` - ` && |{ l_difference }| ).

  ENDMETHOD.

ENDCLASS.
