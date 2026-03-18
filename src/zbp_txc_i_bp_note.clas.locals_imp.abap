CLASS lsc_ztxc_i_bp_note DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    methods cleanup_finalize redefinition.

ENDCLASS.

CLASS lsc_ztxc_i_bp_note IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
     if 1 = 2.
     endif.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_note DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR note RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR note~validateCustomer.
    METHODS validateNote FOR VALIDATE ON SAVE
      IMPORTING keys FOR note~validateNote.

ENDCLASS.

CLASS lhc_note IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validateCustomer.

    DATA lt_but000_new TYPE STANDARD TABLE OF but000.

    CALL FUNCTION 'BUPA_GENERAL_CALLBACK'
      TABLES et_but000_new = lt_but000_new.

    READ ENTITIES OF I_BusinessPartnerTP_3
         ENTITY BusinessPartner
         FIELDS ( BusinessPartner BusinessPartnerCategory )
         WITH CORRESPONDING #( keys MAPPING BusinessPartner = Partner )
         RESULT DATA(lt_partner).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      IF     NOT line_exists( lt_partner[ KEY entity
                                          BusinessPartner = <key>-Partner ] )
         AND NOT line_exists( lt_but000_new[ partner = <key>-Partner ] ).
        INSERT VALUE #( %tky = <key>-%tky ) INTO TABLE failed-note.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateNote.

    READ ENTITIES OF ztxc_i_bp_note IN LOCAL MODE
         ENTITY note
         FIELDS ( partner note )
         WITH CORRESPONDING #( keys )
         RESULT DATA(partner_notes).

    LOOP AT partner_notes ASSIGNING FIELD-SYMBOL(<partner_note>).

      IF strlen( <partner_note>-note ) BETWEEN 1 AND 3.

        append VALUE #( %tky                  = <partner_note>-%tky
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                      text = 'zu kurz! -> Mind 3 Zeichen' ) )
                     TO reported-note.

        INSERT VALUE #( %tky = <partner_note>-%tky ) INTO TABLE failed-note.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
