param location string
param vnetName string
param addressPrefixes array
param dnsServers array
param subnets array
param virtualNetworkPeerings array = []

resource networkDeploy 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
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
