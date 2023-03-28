// az deployment group create --resource-group <resource-group> --name vnet-resource-test --template-file ./tests/network/virtual-network-test.bicep

module vnetDeploy '../../src/network/virtual-network/virtual-network.bicep' = {
  name: 'dpl-vnet-test'
  params: {
    location: 'eastus2'
    shortName: 'sample'
    addressPrefixes: []
    dnsServers: [ '' ]
    subnets: []
  }
}
