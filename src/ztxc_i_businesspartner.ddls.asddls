@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Businesspartner'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

define root view entity ztxc_i_businesspartner
  as select from I_BusinessPartnerTP_2

  association [1..1] to ZTXC_I_BP_NOTE as _Note on _Note.Partner = $projection.BusinessPartner

{
      @Search.defaultSearchElement: true
      @UI.facet: [ { id: 'BusinesspartnerId',
                     purpose: #STANDARD,
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'Businesspartner',
                     position: 10 } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key BusinessPartner,

      @UI.lineItem: [ { position: 20, cssDefault.width: '350px' } ]
      @UI.selectionField: [ { position: 20 } ]
      BusinessPartnerUUID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @UI.lineItem: [ { position: 30, cssDefault.width: '350px' } ]
      @UI.selectionField: [ { position: 30 } ]
      @UI.identification: [{ position: 10 }]
      OrganizationBPName1,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @UI.lineItem: [ { position: 40 } ]
      @UI.selectionField: [ { position: 40 } ]
      @UI.identification: [{ position: 20 }]
      OrganizationBPName2,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @UI.lineItem: [ { position: 50 } ]
      @UI.selectionField: [ { position: 50 } ]
      @UI.identification: [{ position: 30 }]
      @EndUserText.label: 'Note'
      _Note.Note           as Note
}
