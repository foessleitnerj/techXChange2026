CLASS zcl_txc_demo_1m DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
     class-data l_difference type p decimals 2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_1m IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( 'Demo 1M - BAPI Classic Pattern' ).

    GET RUN TIME FIELD DATA(l_from).

    DATA centraldata  TYPE bapibus1006_central.
    DATA organization TYPE bapibus1006_central_organ.
    DATA partner_id   TYPE bp_partner.
    DATA messages     TYPE TABLE OF bapiret2.
    DATA address      TYPE bapibus1006_address.

    TRY.

        do 100 times.

        organization-name1 = |CCH – Congress Center Demo 1M{ sy-index } - { sy-uzeit } |.
        centraldata-title_key = '0003'. " Company

        address-postl_cod1 = '20355'.
        address-city       = 'Hamburg'.
        address-country    = 'DE'.
        address-street     = 'Congressplatz'.
        address-house_no   = '1'.

        CALL FUNCTION 'BAPI_BUPA_CREATE_FROM_DATA'
          EXPORTING partnercategory         = '2'
                    centraldata             = centraldata
                    centraldataorganization = organization
                    addressdata             = address
          IMPORTING businesspartner         = partner_id
          TABLES    return                  = messages.

        LOOP AT messages INTO DATA(message) WHERE type = 'E' OR type = 'A' OR type = 'X'.
          RAISE EXCEPTION TYPE zcx_txc_error MESSAGE ID message-id
                TYPE message-type
                NUMBER message-number
                WITH message-message_v1
                     message-message_v2
                     message-message_v3
                     message-message_v4.
        ENDLOOP.

        enddo.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.


        GET RUN TIME FIELD DATA(l_to).
        l_difference = ( l_to - l_from ) / 1000000.

        out->write( |Partner: { partner_id } - { l_difference }| ).

      CATCH zcx_txc_error INTO DATA(exception).

        out->write( exception->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
