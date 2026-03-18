CLASS zcl_txc_demo_6 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_6 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA messages TYPE bapiret2_t.

    CALL FUNCTION 'BAPI_BUPA_CENTRAL_CHANGE'
      EXPORTING
        businesspartner           = '0000000035'
        centraldataorganization   = VALUE bapibus1006_central_organ( name1 = |CCH – Congress Center Demo 6 - { sy-uzeit }|  )
        centraldataorganization_x = VALUE  bapibus1006_central_organ_x( name1 = abap_true )
      TABLES
        return                    = messages.

    MODIFY ENTITIES OF ztxc_i_bp_note
           ENTITY note
           UPDATE FIELDS ( Note )
           WITH VALUE #( ( Partner = '0000000035'
                           note    = |Notiz Demo 6 - { sy-uzeit }| ) ).

    COMMIT ENTITIES
      "    IN SIMULATION MODE
           RESPONSES
           FAILED DATA(commit_failed)
           REPORTED DATA(commit_reported).

    out->write( |COMMIT ENTITIES IN SIMULATION MODE - SY-SUBRC = { sy-subrc }| ).

   " COMMIT WORK.
   " out->write( |COMMIT WORK - SY-SUBRC = { sy-subrc }| ).

  ENDMETHOD.

ENDCLASS.
