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

    DATA l_partner TYPE bp_partner.

    l_partner = '0000000171'.

    MODIFY ENTITIES OF I_BusinessPartnerTP_3
           ENTITY BusinessPartner
           UPDATE FIELDS ( OrganizationBPName1 )
           WITH VALUE #( ( BusinessPartner     = l_partner
                           OrganizationBPName1 = |CCH – Congress Center Demo 5 - { sy-uzeit }| ) )
           FAILED DATA(modify_failed)
           REPORTED DATA(modifiy_reported).

    READ ENTITIES OF ztxc_i_bp_note
         ENTITY note
         FIELDS ( note )
         WITH VALUE #( ( Partner = l_partner ) )
         RESULT DATA(read_result)
         FAILED DATA(read_failed)
         REPORTED DATA(read_reported).

    IF read_failed-note IS NOT INITIAL.

      MODIFY ENTITIES OF ztxc_i_bp_note
             ENTITY note
             CREATE FIELDS ( Partner Note )
             AUTO FILL CID
             WITH VALUE #( ( Partner = l_partner
                             note    = |Notiz Demo 5 - { sy-uzeit }| ) )
             FAILED DATA(create_note_failed)
             REPORTED DATA(create_note_reported).

    ELSE.

      MODIFY ENTITIES OF ztxc_i_bp_note
             ENTITY note
             UPDATE FIELDS ( Note )
             WITH VALUE #( ( Partner = l_partner
                             note    = |Notiz Demo 5 - { sy-uzeit }| ) )
             FAILED DATA(modify_note_failed)
             REPORTED DATA(modifiy_note_reported).
    ENDIF.

    COMMIT ENTITIES
           IN SIMULATION MODE
           RESPONSES
           FAILED DATA(commit_failed)
           REPORTED DATA(commit_reported).
    out->write( |COMMIT ENTITIES IN SIMULATION MODE - SY-SUBRC = { sy-subrc }| ).

    "ROLLBACK ENTITIES.

    "COMMIT WORK.
    "out->write( |COMMIT WORK - SY-SUBRC = { sy-subrc }| ).

  ENDMETHOD.

ENDCLASS.
