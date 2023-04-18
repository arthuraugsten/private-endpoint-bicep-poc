@description('The type of resource to generate the name for.')
@allowed([
  'apiConnections'
  'apiManagementService'
  'appServiceEnvironment'
  'appServicePlan'
  'appService'
  'cosmosDbAccount'
  'dataBricks'
  'dataFactory'
  'dataLakeStore'
  'eventGridDomain'
  'functionApp'
  'integrationServiceEnvironment'
  'keyVault'
  'logicApp'
  'managedIdentity'
  'publicIp'
  'sqlDatabase'
  'sqlServer'
  'storageAccount'
])
param resourceType string

@minLength(3)
@maxLength(15)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param shortName string

@allowed([
  'd'
  'q'
  't'
  'p'
  'n'
])
@description('Single character indicating the target environment: d (development), q (QA), t (UAT), p (production), or n (non-production).')
param environment string

@minLength(2)
@maxLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

@description('The Azure location/data center to deploy to.')
param location string

var sharedResourceTypes = json(loadTextContent('./resource-codes.json'))
var sharedLocationCodes = json(loadTextContent('./location-codes.json'))
var resourceName = '${sharedLocationCodes[location]}${sharedResourceTypes[resourceType]}${shortName}${environment}${sequence}'

output resourceName string = resourceName
