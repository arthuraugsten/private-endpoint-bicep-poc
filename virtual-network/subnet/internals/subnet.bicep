param networkName string
param addressPrefix string
param routeTableId string
param networkSecurityGroupId string
param serviceDelegation array
param privateEndpointNetworkPolicies string = 'Enabled'
param privateLinkServiceNetworkPolicies string = 'Enabled'
param serviceEndpoints array

resource parentNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: networkName
}

resource subnetDeploy 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'NET-${replace(addressPrefix, '/', '_')}'
  parent: parentNetwork
  properties: {
    addressPrefix: addressPrefix
    delegations: serviceDelegation
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
    privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
    routeTable: {
      id: routeTableId
    }
    serviceEndpoints: serviceEndpoints
  }
}
