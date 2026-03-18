REPORT zy_txc_demo_4.

DATA centraldata  TYPE bapibus1006_central.
DATA organization TYPE bapibus1006_central_organ.
DATA partner_id   TYPE bp_partner.
DATA messages     TYPE TABLE OF bapiret2.
DATA address      TYPE bapibus1006_address.

DATA l_difference TYPE p LENGTH 8 DECIMALS 2.

TRY.

    GET RUN TIME FIELD DATA(l_from).

    organization-name1 = |CCH – Congress Center Demo 4 - { sy-uzeit } |.
    centraldata-title_key = '0003'. " Company

    address-postl_cod1 = '20355'.
    address-city       = 'Hamburg'.
    address-country    = 'DE'.
    address-street     = 'Congressplatz'.
    address-house_no   = '1'.

    SET UPDATE TASK LOCAL.

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

  CATCH zcx_txc_error INTO DATA(exception).

ENDTRY.
