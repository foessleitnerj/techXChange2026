FUNCTION Z_TXC_UPDATE_TASK_V2.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"----------------------------------------------------------------------

  insert into zlog values @( value #( timestamp = utclong_current( ) log = 'insert 4 - v2'  ) ).

ENDFUNCTION.
