CLASS zcl_txc_demo_5 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
     interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_txc_demo_5 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    MODIFY ENTITIES OF I_BusinessPartnerTP_3
           ENTITY BusinessPartner
           UPDATE FIELDS ( OrganizationBPName1 )
           WITH VALUE #( ( BusinessPartner     = '0000000035'
                           OrganizationBPName1 = |CCH – Congress Center Demo 5 - { sy-uzeit }| ) )
           FAILED DATA(modify_failed)
           REPORTED DATA(modifiy_reported).

    MODIFY ENTITIES OF ztxc_i_bp_note
           ENTITY note
           UPDATE FIELDS ( Note )
           WITH VALUE #( ( Partner = '0000000035'
                           note    = |Notiz Demo 5 - { sy-uzeit }| ) ).

    COMMIT ENTITIES
           IN SIMULATION MODE
           RESPONSES
           FAILED DATA(commit_failed)
           REPORTED DATA(commit_reported).
    out->write( |COMMIT ENTITIES IN SIMULATION MODE - SY-SUBRC = { sy-subrc }| ).

    COMMIT WORK.
    out->write( |COMMIT WORK - SY-SUBRC = { sy-subrc }| ).

  ENDMETHOD.

ENDCLASS.
