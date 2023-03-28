// az deployment group create --resource-group eusrgnet01 --name vnet-resource-test --template-file ./virtual-network-test.bicep

var subnetAddressPrefix = '10.99.2.0/24'
module vnetDeploy './virtual-network.bicep' = {
  name: 'dpl-vnet-test'
  params: {
    location: 'eastus2'
    shortName: 'sample'
    addressPrefixes: [ '10.99.0.0/16' ]
    dnsServers: [ '10.99.0.100', '10.99.0.101' ]
    subnets: [
      {
        name: 'NET-${replace(subnetAddressPrefix, '/', '_')}'
        properties: {
          addressPrefix: subnetAddressPrefix
          // networkSecurityGroup: {
          //   id: '/subscriptions/5b0877a8-0217-477c-9f05-6e6a5d5b0a58/resourceGroups/eusrgnet01/providers/Microsoft.Network/networkSecurityGroups/eusnsgsmplintd01'
          // }
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          // routeTable: {
          //   id: '/subscriptions/5b0877a8-0217-477c-9f05-6e6a5d5b0a58/resourceGroups/eusrgnet01/providers/Microsoft.Network/routeTables/eus2rtsmplintd01'
          // }
        }
      }
    ]
  }
}
