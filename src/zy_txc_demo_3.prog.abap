REPORT zy_txc_demo_3.

DATA create_partner TYPE TABLE FOR CREATE i_businesspartnertp_3.
DATA create_address TYPE TABLE FOR CREATE i_businesspartnertp_3\_businesspartneraddress.

create_partner = VALUE #( ( %cid = 'bp1'
                            businesspartnercategory = '2'
                            FormOfAddressOrganization = '0003'
                            organizationbpname1 = |CCH – Congress Center Hamburg - { sy-uzeit } |
                            businesspartnergrouping = '0001'
                            %control-businesspartnercategory = if_abap_behv=>mk-on
                            %control-formofaddressorganization = if_abap_behv=>mk-on
                            %control-organizationbpname1 = if_abap_behv=>mk-on
                            %control-businesspartnergrouping = if_abap_behv=>mk-on ) ).

create_address = VALUE #( ( %cid_ref = 'bp1' %target = VALUE #( ( %cid = 'bp1_1'
                                                                  country = 'DE'
                                                                  cityname = 'Hamburg'
                                                                  streetNAme = 'Congressplatz'
                                                                  HouseNumber = '1'
                                                                  PostalCode = '20355'
                                                                  %control-country = if_abap_behv=>mk-on
                                                                  %control-cityname = if_abap_behv=>mk-on
                                                                  %control-streetName = if_abap_behv=>mk-on
                                                                  %control-HouseNumber = if_abap_behv=>mk-on
                                                                  %control-PostalCode = if_abap_behv=>mk-on ) ) ) ).

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

    LOOP AT create_mapped-businesspartner ASSIGNING FIELD-SYMBOL(<create_mapped>).
      CONVERT KEY OF I_BusinessPartnerTP_3
         FROM <create_mapped>-%pid
         TO FINAL(root_key).
      <create_mapped>-businesspartner = root_key.
    ENDLOOP.

    COMMIT ENTITIES END.

    WRITE: / 'Partner Nr', | { create_mapped-businesspartner[ %cid = 'bp1' ]-businesspartner ALPHA = IN } |.


  CATCH zcx_txc_error INTO DATA(exception).

    WRITE: / exception->get_text( ).

ENDTRY.
