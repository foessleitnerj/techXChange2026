REPORT zy_txc_demo_1.


DATA l_partner TYPE bp_partner.

START-OF-SELECTION.

  l_partner = '0000000171'.

  "set update task local.

  "perform vb_commit on commit.

  "insert into zlog values @( value #( timestamp = utclong_current( ) log = 'insert 2 - direct'  ) ).

  "call function 'Z_TXC_UPDATE_TASK_V1' in update task.

  "call function 'Z_TXC_UPDATE_TASK_V2' in update task.

  MODIFY ENTITIES OF ztxc_i_bp_note
         ENTITY note
         UPDATE FIELDS ( Note )
         WITH VALUE #( ( Partner = l_partner
                         note    = |Notiz Demo 5 - { sy-uzeit }| ) )
         FAILED DATA(modify_note_failed)
         REPORTED DATA(modifiy_note_reported).

  COMMIT ENTITIES
         RESPONSES
         FAILED DATA(commit_failed)
         REPORTED DATA(commit_reported).


form vb_commit.
   insert into zlog values @( value #( timestamp = utclong_current( ) log = 'insert 1 - form'  ) ).
endform.
