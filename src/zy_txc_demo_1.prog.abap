REPORT zy_txc_demo_1.

DATA centraldata  TYPE bapibus1006_central.
DATA organization TYPE bapibus1006_central_organ.
DATA partner_id   TYPE bp_partner.
DATA messages     TYPE TABLE OF bapiret2.
DATA address      TYPE bapibus1006_address.

TRY.

    organization-name1 = |CCH – Congress Center Hamburg - { sy-uzeit } |.
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

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    WRITE: / 'Partner:', partner_id.

  CATCH zcx_txc_error INTO DATA(exception).

    WRITE / exception->get_text( ).

ENDTRY.
