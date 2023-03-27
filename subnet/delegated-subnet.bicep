@description('Network where the subnet will be deployed.')
param networkName string

@description('The address prefix for the subnet.')
param addressPreffix string

@description('Route Table ID which will be linked to this subnet.')
param routeTableId string

@description('Network Security Group ID which will be linked to this subnet.')
param networkSecurityGroupId string

@description('The name of the service to whom the subnet should be delegated (e.g. Microsoft.Sql/servers).')
param serviceDelegation string

resource parentNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: networkName
}

resource subnetDeploy 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: 'NET-${replace(addressPreffix, '/', '_')}'
  parent: parentNetwork
  properties: {
    addressPrefix: addressPreffix
    delegations: [
      {
        name: replace(serviceDelegation, '/', '.')
        properties: {
          serviceName: serviceDelegation
        }
      }
    ]
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
