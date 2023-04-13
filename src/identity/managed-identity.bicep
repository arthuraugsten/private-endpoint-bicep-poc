@minLength(3)
@maxLength(12)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param resourceShortName string

@allowed([
  'd'
  'q'
  't'
  'p'
  'n'
])
@description('Single character indicating the target environment: d (development), q (QA), t (UAT), p (production).')
param environment string

@minLength(2)
@maxLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

@description('The Azure location/data center to deploy to.')
param location string

var deploymentNameSuffix = '${resourceShortName}-${environment}-${sequence}'

module managedIdentityNameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-mi-${deploymentNameSuffix}'
  params: {
    resourceType: 'managedIdentity'
    shortName: resourceShortName
    environment: environment
    sequence: sequence
    location: location
  }
}

module managedIdentityHelper './internals/managed-identity-helper.bicep' = {
  name: 'mi-helper-${deploymentNameSuffix}'
  params: {
    managedIdentityName: managedIdentityNameHelper.outputs.resourceName
    location: location
  }
}

output managedIdentityId string = managedIdentityHelper.outputs.managedIdentityId
output managedIdentityName string = managedIdentityNameHelper.outputs.resourceName
output managedIdentityTenantId string = managedIdentityHelper.outputs.managedIdentityTenantId
output managedIdentityClientId string = managedIdentityHelper.outputs.managedIdentityClientId
output managedIdentityPrincipalId string = managedIdentityHelper.outputs.managedIdentityPrincipalId
