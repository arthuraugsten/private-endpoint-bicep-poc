@description('The Azure location/data center to deploy to.')
param location string

@minLength(3)
@maxLength(12)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param resourceShortName string

@maxLength(2)
@minLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

@allowed([
  'n'
  'd'
  'q'
  't'
  'p'
])
@description('Single character indicating the target environment: d (development), q (QA), t (UAT), p (production).')
param environment string

@allowed([
  'nonprod'
  'prod'
])
@minLength(2)
@maxLength(30)
@description('VNET Short name where the resource will be deployed.')
param vnetShortName string

@description('Two digit, zero padded vnet sequence number (e.g. 01, 02, 03, etc.).')
param vnetSequence string

@description('The address prefix for the subnet.')
param addressPrefix string

@allowed([
  'Developer'
  'Premium'
])
@description('API Management service tier.')
param sku string

@minValue(1)
@maxValue(4)
@description('How many instances will be configured for this API Management instance.')
param instanceCount int = 1

module vnetNameHelper '../network/virtual-network/virtual-network-name-helper.bicep' = {
  name: 'vnet-name-helper-${vnetShortName}-${resourceShortName}-${environment}'
  params: {
    location: location
    shortName: vnetShortName
    sequence: vnetSequence
  }
}

module subnetNameHelper '../network/virtual-network/subnet/subnet-name-helper.bicep' = {
  name: 'subnet-name-helper-${vnetShortName}-${resourceShortName}'
  params: {
    addressPrefix: addressPrefix
  }
}

module nameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-am-${resourceShortName}-${location}-${environment}'
  params: {
    environment: environment
    location: location
    resourceType: 'apiManagementService'
    shortName: resourceShortName
    sequence: sequence
  }
}

module publicIp '../network/public-ip/public-ip.bicep' = {
  name: 'dpl-pip-${resourceShortName}${sequence}-${environment}'
  params: {
    environment: environment
    location: location
    sku: 'Standard'
    targetResourceShortName: resourceShortName
    targetResourceSequence: sequence
    targetResourceType: 'apiManagementService'
  }
}

module apiManagement 'internals/api-management-helper.bicep' = {
  name: 'dpl-appgw-${resourceShortName}-${sequence}-${environment}'
  params: {
    instanceCount: instanceCount
    location: location
    name: nameHelper.outputs.resourceName
    publicIpId: publicIp.outputs.id
    sku: sku
    subnetId: resourceId(subscription().subscriptionId, vnetNameHelper.outputs.resourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetNameHelper.outputs.name, subnetNameHelper.outputs.subnetName)
  }
}
