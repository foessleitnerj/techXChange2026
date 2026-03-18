CLASS zcl_txc_unit_rap_demo_4 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA go_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS class_setup RAISING cx_static_check.
    CLASS-METHODS class_teardown.

    METHODS create_new_address FOR TESTING.
ENDCLASS.



CLASS zcl_txc_unit_rap_demo_4 IMPLEMENTATION.
  METHOD class_setup.

    DATA lt_partner TYPE STANDARD TABLE OF I_BusinessPartnerTP_3 WITH EMPTY KEY.

    go_environment = cl_cds_test_environment=>create(
                         i_for_entity      = 'I_BUSINESSPARTNERTP_3'
                         i_dependency_list = VALUE #( ( name = 'I_BUSINESSPARTNERTP_3' type = 'TABLE' ) ) ).

    lt_partner = VALUE #( ( BusinessPartner = '1234567890' OrganizationBPName1 = 'Las Vegas Corp'  ) ).

    go_environment->insert_test_data( lt_partner ).
    go_environment->enable_double_redirection( ).

  ENDMETHOD.

  METHOD class_teardown.
    go_environment->destroy( ).
  ENDMETHOD.

  METHOD create_new_address.

     MODIFY ENTITIES OF I_BusinessPartnerTP_3
        entity BusinessPartner
        create by \_BusinessPartnerAddress
        FIELDS ( country cityname streetName PostalCode HouseNumber )
          WITH VALUE #( ( %key = '1234567890' %target = VALUE #( ( %cid = 'bp1_1'
                                                                   country = 'DE'
                                                                   cityname = 'Hamburg'
                                                                   streetName = 'Congressplatz'
                                                                   HouseNumber = '1'
                                                                   PostalCode = '20355' ) ) ) )
      MAPPED   DATA(create_mapped)
      FAILED   DATA(create_failed)
      REPORTED DATA(create_reported).

      commit entities
         response of i_businesspartnertp_3
         reported data(commit_reported)
         failed data(commit_failed).

      cl_abap_unit_assert=>assert_subrc( ).

  ENDMETHOD.

ENDCLASS.
