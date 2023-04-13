@description('The Azure location/data center to deploy to.')
param location string

@maxLength(30)
@minLength(2)
param shortName string

@description('A list of address blocks reserved for this virtual network in CIDR notation.')
@minLength(1)
param addressPrefixes array

@description('The list of DNS servers IP addresses.')
@minLength(2)
param dnsServers array

@description('A list of subnets in a Virtual Network. It should follow **_Subnet_** object schema.')
@minLength(1)
param subnets array

@description('A list of peerings in a Virtual Network. It should follow **_VirtualNetworkPeering_** object schema.')
param virtualNetworkPeerings array = []

var locationCode = loadJsonContent('../internals/location-settings.json')[location]

module nameHelper 'virtual-network-name-helper.bicep' = {
  name: 'dpl-vnet-name-helper${locationCode}-${shortName}'
  params: {
    location: location
    shortName: shortName
  }
}

module networkDeploy 'internals/virtual-network-helper.bicep' = {
  name: 'dpl-vnet-${location}-${shortName}'
  params: {
    addressPrefixes: addressPrefixes
    dnsServers: dnsServers
    location: location
    subnets: subnets
    vnetName: nameHelper.outputs.name
    virtualNetworkPeerings: virtualNetworkPeerings
  }
}

output networkId string = networkDeploy.outputs.networkId
