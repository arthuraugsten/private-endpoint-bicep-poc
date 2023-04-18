@description('The Azure location/data center to deploy to.')
param location string

@allowed([
  'n'
  'd'
  'q'
  't'
  'p'
])
@description('Single character indicating the target environment: d (development), q (QA), t (UAT), p (production).')
param environment string

@minLength(3)
@maxLength(12)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param targetResourceShortName string

@description('The type of resource where the IP will be attached.')
param targetResourceType string

@maxLength(2)
@minLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param targetResourceSequence string

@allowed([
  'Basic'
  'Standard'
])
@description('IP service tier')
param sku string

var targetResourceCode = loadJsonContent('../../helpers/resource-codes.json')[targetResourceType]

module nameHelper '../../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-pip-${targetResourceShortName}-${location}-${environment}'
  params: {
    environment: environment
    location: location
    resourceType: targetResourceType
    shortName: take('${targetResourceCode}${targetResourceShortName}', 15)
    sequence: targetResourceSequence
  }
}

module publicIp 'internals/public-ip-helper.bicep' = {
  name: 'dpl-pip-${location}-${targetResourceShortName}-${environment}'
  params: {
    location: location
    resourceName: nameHelper.outputs.resourceName
    sku: sku
  }
}

output id string = publicIp.outputs.id
