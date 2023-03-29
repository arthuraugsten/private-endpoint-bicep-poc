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

var regionCode = loadJsonContent('./internals/region-settings.json')[location]

resource networkDeploy 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: '${regionCode}-VN-${shortName}'
  location: location
  tags: resourceGroup().tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    enableDdosProtection: false
    subnets: subnets
    virtualNetworkPeerings: virtualNetworkPeerings
  }
}

output networkId string = networkDeploy.id
