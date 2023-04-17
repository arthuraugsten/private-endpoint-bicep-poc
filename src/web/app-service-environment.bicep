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

@maxLength(2)
@minLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

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

module vnetAppNameHelper '../network/virtual-network/virtual-network-name-helper.bicep' = {
  name: 'vnet-name-helper-${vnetShortName}-${resourceShortName}'
  params: {
    location: location
    shortName: vnetShortName
    sequence: vnetSequence
  }
}

module vnetHubNameHelper '../network/virtual-network/virtual-network-name-helper.bicep' = {
  name: 'vnet-name-helper-hub-${resourceShortName}'
  params: {
    location: location
    shortName: 'hub'
  }
}

module subnetNameHelper '../network/virtual-network/subnet/subnet-name-helper.bicep' = {
  name: 'subnet-name-helper-${vnetShortName}-${resourceShortName}'
  params: {
    addressPrefix: addressPrefix
  }
}

module nameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'ase-name-helper-${resourceShortName}'
  params: {
    environment: environment
    location: location
    sequence: sequence
    shortName: resourceShortName
    resourceType: 'appServiceEnvironment'
  }
}

var zoneName = '${take(nameHelper.outputs.resourceName, 37)}.appserviceenvironment.net'

module privateDnsDeploy '../network/private-dns/private-dns.bicep' = {
  name: 'dpl-pdns-ase-${resourceShortName}-${environment}'
  params: {
    location: 'global'
    name: zoneName
  }
}

module vnetAppDnsLink '../network/private-dns/virtual-network-link.bicep' = {
  name: 'dpl-pdns-applink-${resourceShortName}-${environment}'
  dependsOn: [ privateDnsDeploy ]
  params: {
    linkName: 'vnetlink'
    location: 'global'
    zoneName: zoneName
    virtualNetworkId: resourceId(subscription().subscriptionId, vnetAppNameHelper.outputs.resourceGroup, 'Microsoft.Network/virtualNetworks', vnetAppNameHelper.outputs.name)
  }
}

module vnetHubDnsLink '../network/private-dns/virtual-network-link.bicep' = {
  name: 'dpl-pdns-hublink-${resourceShortName}-${environment}'
  dependsOn: [ privateDnsDeploy, vnetAppDnsLink ]
  params: {
    linkName: 'vlinkhub'
    location: 'global'
    zoneName: zoneName
    virtualNetworkId: resourceId(subscription().subscriptionId, vnetHubNameHelper.outputs.resourceGroup, 'Microsoft.Network/virtualNetworks', vnetHubNameHelper.outputs.name)
  }
}

module aseDeploy 'internals/app-service-environment-helper.bicep' = {
  name: 'dpl-ase-${resourceShortName}-${environment}'
  dependsOn: [ privateDnsDeploy ]
  params: {
    location: location
    resourceName: nameHelper.outputs.resourceName
    subnetId: resourceId(subscription().subscriptionId, vnetAppNameHelper.outputs.resourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vnetAppNameHelper.outputs.name, subnetNameHelper.outputs.subnetName)
  }
}

module dnsEntryApp '../network/private-dns/a-record.bicep' = {
  name: 'dpl-a-record-app-${resourceShortName}-${environment}'
  params: {
    entryName: '*'
    zoneName: zoneName
    ip: aseDeploy.outputs.internalIp
  }
}

module dnsEntryScm '../network/private-dns/a-record.bicep' = {
  name: 'dpl-a-record-scm-${resourceShortName}-${environment}'
  params: {
    entryName: '*.scm'
    zoneName: zoneName
    ip: aseDeploy.outputs.internalIp
  }
}

module dnsEntryAt '../network/private-dns/a-record.bicep' = {
  name: 'dpl-a-record-at-${resourceShortName}-${environment}'
  params: {
    entryName: '@'
    zoneName: zoneName
    ip: aseDeploy.outputs.internalIp
  }
}

output id string = aseDeploy.outputs.id
