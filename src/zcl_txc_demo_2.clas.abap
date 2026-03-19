CLASS zcl_txc_demo_2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
     class-data l_difference type p decimals 2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_2 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( 'Demo 2' ).

    GET RUN TIME FIELD DATA(l_from).

    MODIFY ENTITIES OF I_BusinessPartnerTP_3
           ENTITY businesspartner
           CREATE FIELDS ( businesspartnercategory
                           organizationbpname1
                           businesspartnergrouping
                           FormOfAddressOrganization )
           WITH VALUE #( ( %cid                      = 'bp1'  " Contend ID
                           BusinessPartnerCategory   = '2'
                           FormOfAddressOrganization = '0003'
                           OrganizationBPName1       = |CCH – Congress Center Hamburg - { sy-uzeit } |
                           BusinessPartnerGrouping   = '0001'  ) )
           CREATE BY \_businesspartneraddress
           FIELDS ( country cityname streetName PostalCode HouseNumber )
           WITH VALUE #( ( %cid_ref = 'bp1'
                           %target  = VALUE #( ( %cid        = 'bp1_1'
                                                 Country     = 'DE'
                                                 CityName    = 'Hamburg'
                                                 StreetName  = 'Congressplatz'
                                                 HouseNumber = '1'
                                                 PostalCode  = '20355' ) ) ) )

           MAPPED   DATA(create_mapped)
           FAILED   DATA(create_failed)
           REPORTED DATA(create_reported).

    COMMIT ENTITIES BEGIN
           RESPONSE OF  i_businesspartnertp_3
           FAILED   DATA(commit_failed)
           REPORTED DATA(commit_reported).
    IF sy-subrc = 0.

      LOOP AT create_mapped-BusinessPartner ASSIGNING FIELD-SYMBOL(<create_mapped>).
        CONVERT KEY OF I_BusinessPartnerTP_3
                FROM <create_mapped>-%pid
                TO FINAL(root_key).
        <create_mapped>-BusinessPartner = root_key.

      ENDLOOP.

    ENDIF.

    COMMIT ENTITIES END.

    GET RUN TIME FIELD DATA(l_to).
    l_difference = ( l_to - l_from ) / 1000000.

    out->write(
        |Partner Nr { create_mapped-BusinessPartner[ %cid = 'bp1' ]-BusinessPartner ALPHA = IN } - { l_difference }| ).

  ENDMETHOD.

ENDCLASS.
