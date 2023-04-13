// az deployment group create --resource-group EAST-US2-RG-NET --name vnet-resource-test --template-file ./tests/network/virtual-network-test.bicep

var subnetAddressPrefix = '10.99.2.0/24'
module vnetDeploy '../../src/network/virtual-network/virtual-network.bicep' = {
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
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}
