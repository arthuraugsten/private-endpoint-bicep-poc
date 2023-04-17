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
param resourceShortName string

@minLength(2)
@maxLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

param appServiceEnvironmentId string

@allowed([
  'windows'
  'linux'
])
param operationalSystem string

@allowed([
  'I1v2'
  'I2v2'
  'I3v2'
])
param size string

@minValue(1)
@maxValue(10)
param instanceCount int

module nameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-asp-${resourceShortName}-${environment}'
  params: {
    environment: environment
    location: location
    resourceType: 'appServicePlan'
    shortName: resourceShortName
    sequence: sequence
  }
}

module servicePlan './internals/app-service-plan-helper.bicep' = {
  name: 'dpl-asp-${resourceShortName}-${environment}'
  params: {
    appServiceEnvironmentId: appServiceEnvironmentId
    location: location
    name: nameHelper.outputs.resourceName
    operationalSystem: operationalSystem
    size: size
    instanceCount: instanceCount
  }
}
