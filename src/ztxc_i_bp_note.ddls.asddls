@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Note'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZTXC_I_BP_NOTE
  as select from ztxc_bp_note

{
  key partner    as Partner,

      @EndUserText.label: 'Note'
      note       as Note,
      @Semantics.user.createdBy: true
      changed_by as ChangedBy,
      @Semantics.systemDateTime.createdAt: true
      changed_at as ChangedAt,
      @Semantics.user.lastChangedBy: true
      created_by as CreatedBy,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
      created_at as CreatedAt
}
