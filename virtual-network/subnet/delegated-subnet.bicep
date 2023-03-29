@minLength(1)
@maxLength(80)
@description('Network where the subnet will be deployed.')
param networkName string

@description('The address prefix for the subnet.')
param addressPrefix string

@description('Route Table ID which will be linked to this subnet.')
param routeTableId string

@description('Network Security Group ID which will be linked to this subnet.')
param networkSecurityGroupId string

@description('The name of the service to whom the subnet should be delegated (e.g. Microsoft.Sql/servers).')
param serviceDelegation string

@allowed([
  'Enabled'
  'Disabled'
])
@description('Enable or Disable apply network policies on private end point in the subnet.')
param privateEndpointNetworkPolicies string = 'Enabled'

@allowed([
  'Enabled'
  'Disabled'
])
@description('Enable or Disable apply network policies on private link service in the subnet.')
param privateLinkServiceNetworkPolicies string = 'Enabled'

@description('An array of service endpoints. It should follow ServiceEndpointPropertiesFormat object schema.')
param serviceEndpoints array = []

module subnetDeploy './internals/subnet.bicep' = {
  name: 'dpl-sub-${replace(addressPrefix, '/', '-')}'
  params: {
    addressPrefix: addressPrefix
    networkName: networkName
    serviceDelegation: [
      {
        name: replace(serviceDelegation, '/', '.')
        properties: {
          serviceName: serviceDelegation
        }
      }
    ]
    networkSecurityGroupId: networkSecurityGroupId
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
    privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
    routeTableId: routeTableId
    serviceEndpoints: serviceEndpoints
  }
}
