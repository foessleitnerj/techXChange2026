REPORT zy_txc_demo_2.

TRY.

    MODIFY ENTITIES OF I_BusinessPartnerTP_3
       ENTITY businesspartner
       CREATE FIELDS ( businesspartnercategory
                       organizationbpname1
                       businesspartnergrouping
                       FormOfAddressOrganization )
       WITH VALUE #( ( %cid = 'bp1' businesspartnercategory = '2'
                                    FormOfAddressOrganization = '0003'
                                    organizationbpname1 = |CCH – Congress Center Hamburg - { sy-uzeit } |
                                    businesspartnergrouping = '0001'  ) )
       CREATE BY \_businesspartneraddress
          FIELDS ( country cityname streetName PostalCode HouseNumber )
          WITH VALUE #( ( %cid_ref = 'bp1' %target = VALUE #( ( %cid = 'bp1_1'
                                                                country = 'DE'
                                                                cityname = 'Hamburg'
                                                                streetName = 'Congressplatz'
                                                                HouseNumber = '1'
                                                                PostalCode = '20355' ) ) ) )

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
