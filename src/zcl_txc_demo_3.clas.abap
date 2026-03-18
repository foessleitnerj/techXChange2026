CLASS zcl_txc_demo_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
     class-data l_difference type p decimals 2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_3 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( 'Demo 3' ).

    GET RUN TIME FIELD DATA(l_from).

    DATA create_partner TYPE TABLE FOR CREATE I_BusinessPartnerTP_3.
    DATA create_address TYPE TABLE FOR CREATE i_businesspartnertp_3\_businesspartneraddress.

    create_partner = VALUE #( ( %cid                               = 'bp1'
                                BusinessPartnerCategory            = '2'
                                FormOfAddressOrganization          = '0003'
                                OrganizationBPName1                = |CCH – Congress Center Hamburg - { sy-uzeit } |
                                BusinessPartnerGrouping            = '0001'
                                %control-BusinessPartnerCategory   = if_abap_behv=>mk-on
                                %control-FormOfAddressOrganization = if_abap_behv=>mk-on
                                %control-OrganizationBPName1       = if_abap_behv=>mk-on
                                %control-BusinessPartnerGrouping   = if_abap_behv=>mk-on ) ).

    create_address = VALUE #( ( %cid_ref = 'bp1'
                                %target  = VALUE #( ( %cid                 = 'bp1_1'
                                                      Country              = 'DE'
                                                      CityName             = 'Hamburg'
                                                      StreetName           = 'Congressplatz'
                                                      HouseNumber          = '1'
                                                      PostalCode           = '20355'
                                                      %control-Country     = if_abap_behv=>mk-on
                                                      %control-CityName    = if_abap_behv=>mk-on
                                                      %control-StreetName  = if_abap_behv=>mk-on
                                                      %control-HouseNumber = if_abap_behv=>mk-on
                                                      %control-PostalCode  = if_abap_behv=>mk-on ) ) ) ).

    TRY.

        MODIFY ENTITIES OF I_BusinessPartnerTP_3
               ENTITY businesspartner
               CREATE FROM create_partner
               CREATE BY \_businesspartneraddress FROM create_address
               MAPPED   DATA(create_mapped)
               FAILED   DATA(create_failed)
               REPORTED DATA(create_reported).

        COMMIT ENTITIES BEGIN RESPONSE OF i_businesspartnertp_3
               FAILED   DATA(commit_failed)
               REPORTED DATA(commit_reported).

        LOOP AT create_mapped-BusinessPartner ASSIGNING FIELD-SYMBOL(<create_mapped>).
          CONVERT KEY OF I_BusinessPartnerTP_3
                  FROM <create_mapped>-%pid
                  TO FINAL(root_key).
          <create_mapped>-BusinessPartner = root_key.
        ENDLOOP.

        COMMIT ENTITIES END.

        GET RUN TIME FIELD DATA(l_to).
        l_difference = ( l_to - l_from ) / 1000000.

        out->write(
            |Partner Nr { create_mapped-BusinessPartner[ %cid = 'bp1' ]-BusinessPartner ALPHA = IN } - { l_difference }| ).

      CATCH zcx_txc_error INTO DATA(exception).

        out->write( exception->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
