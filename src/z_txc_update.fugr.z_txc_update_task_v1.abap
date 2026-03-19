FUNCTION Z_TXC_UPDATE_TASK_V1.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"----------------------------------------------------------------------

  insert into zlog values @( value #( timestamp = utclong_current( ) log = 'insert 3 - v1'  ) ).

ENDFUNCTION.
