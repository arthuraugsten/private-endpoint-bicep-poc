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

@maxLength(30)
@minLength(2)
@allowed([
  'nonprod'
  'prod'
])
param vnetShortName string

param vnetSequence string

@description('The address prefix for the subnet.')
param addressPrefix string

module vnetNameHelper '../network/virtual-network/virtual-network-name-helper.bicep' = {
  name: 'dpl-vnet-name-helper-${vnetShortName}-${resourceShortName}'
  params: {
    location: location
    shortName: vnetShortName
    sequence: vnetSequence
  }
}

module subnetNameHelper '../network/virtual-network/subnet/subnet-name-helper.bicep' = {
  name: 'dpl-subnet-name-helper-${vnetShortName}-${resourceShortName}'
  params: {
    addressPrefix: addressPrefix
  }
}

module nameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-ase-${resourceShortName}'
  params: {
    environment: environment
    location: location
    sequence: sequence
    shortName: resourceShortName
    resourceType: 'appServiceEnvironment'
  }
}

module aseDeploy 'internals/app-service-environment-helper.bicep' = {
  name: 'dpl-ase-${resourceShortName}-${environment}'
  params: {
    location: location
    resourceName: resourceShortName
    subnetId: resourceId(subscription().subscriptionId, vnetNameHelper.outputs.resourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNameHelper.outputs.name, subnetNameHelper.outputs.subnetName)
  }
}
