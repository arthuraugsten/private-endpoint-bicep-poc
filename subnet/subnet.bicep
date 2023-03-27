@description('Network where the subnet will be deployed.')
param networkName string

@description('The address prefix for the subnet.')
param addressPreffix string

@description('Route Table ID which will be linked to this subnet.')
param routeTableId string

@description('Network Security Group ID which will be linked to this subnet.')
param networkSecurityGroupId string

resource parentNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: networkName
}

resource subnetDeploy 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'NET-${replace(addressPreffix, '/', '_')}'
  parent: parentNetwork
  properties: {
    addressPrefix: addressPreffix
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    routeTable: {
      id: routeTableId
    }
  }
}
