CLASS zcl_txc_demo_4 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
     class-data l_difference type p decimals 2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_4 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( 'Demo 4' ).

    GET RUN TIME FIELD DATA(l_from).

    DATA centraldata  TYPE bapibus1006_central.
    DATA organization TYPE bapibus1006_central_organ.
    DATA partner_id   TYPE bp_partner.
    DATA messages     TYPE TABLE OF bapiret2.
    DATA address      TYPE bapibus1006_address.

    TRY.

        organization-name1 = |CCH – Congress Center Demo 4 - { sy-uzeit } |.
        centraldata-title_key = '0003'. " Company

        address-postl_cod1 = '20355'.
        address-city       = 'Hamburg'.
        address-country    = 'DE'.
        address-street     = 'Congressplatz'.
        address-house_no   = '1'.

        "  set update task local.

        CALL FUNCTION 'BAPI_BUPA_CREATE_FROM_DATA'
          EXPORTING partnercategory         = '2'
                    centraldata             = centraldata
                    centraldataorganization = organization
                    addressdata             = address
          IMPORTING businesspartner         = partner_id
          TABLES    return                  = messages.

        MODIFY ENTITIES OF ztxc_i_bp_note
               ENTITY note
               CREATE AUTO FILL CID FIELDS ( Partner Note )
               WITH VALUE #( ( Partner = partner_id
                               note    = |Notiz Demo 4 - { sy-uzeit }| ) )
               FAILED DATA(modify_failed)
               REPORTED DATA(modfiy_reported).

        COMMIT ENTITIES RESPONSE OF ztxc_i_bp_note
               FAILED   DATA(commit_failed)
               REPORTED DATA(commit_reported).

        GET RUN TIME FIELD DATA(l_to).
        l_difference = ( l_to - l_from ) / 1000000.

        out->write( |Partner Nr { partner_id ALPHA = IN } - { l_difference }| ).

      CATCH zcx_txc_error INTO DATA(exception).

        out->write( exception->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
