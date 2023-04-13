@minLength(3)
@maxLength(12)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param resourceShortName string

@allowed([
  'n'
  'd'
  'q'
  't'
  'p'
])
@description('Single character indicating the target environment: d (development), q (QA), t (UAT), p (production).')
param environment string

@minLength(2)
@maxLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

@description('The Azure location/data center to deploy to.')
param location string

@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
])
param sku string = 'Standard_GRS'

@allowed([
  'Hot'
  'Cool'
  'Premium'
])
param accessTier string = 'Hot'

var deploymentNameSuffix = '${resourceShortName}-${environment}-${sequence}'

module storageAccountNameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-sa-${deploymentNameSuffix}'
  params: {
    resourceType: 'storageAccount'
    shortName: resourceShortName
    environment: environment
    sequence: sequence
    location: location
  }
}

//  The template that builds the Azure Web App Service.
//  Implemented as a nested template so that it can use template-helper outputs via parameters.
module storageAccountHelper './internals/storage-account-helper.bicep' = {
  name: 'sa-helper-${deploymentNameSuffix}'
  params: {
    location: location
    storageAccountName: storageAccountNameHelper.outputs.resourceName
    sku: sku
    accessTier: accessTier
  }
}

output storageAccountId string = storageAccountHelper.outputs.storageAccountId
output storageAccountName string = storageAccountNameHelper.outputs.resourceName
