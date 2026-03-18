REPORT zy_txc_demo_5.

MODIFY ENTITIES OF I_BusinessPartnerTP_3
   entity BusinessPartner
      update fields ( OrganizationBPName1 )
         with value #( ( BusinessPartner = '0000000035'
                          OrganizationBPName1 = |CCH – Congress Center Hamburg - { sy-uzeit }|
                     ) ).

MODIFY ENTITIES OF ztxc_i_bp_note
   entity note
      update fields ( Note )
         with value #( ( Partner = '0000000035'
                         note = |CCH – Notiz - { sy-uzeit }|
                     ) ).

COMMIT ENTITIES
   in SIMULATION MODE
   RESPONSES
      FAILED DATA(commit_failed)
      REPORTED DATA(commit_reported).

" ...

commit work.
