// az deployment group create --resource-group <resource-group> --name subnet-resource-test --template-file ./tests/network/subnet-test.bicep

module nsgDeploy '../../src/network/virtual-network/subnet/delegated-subnet.bicep' = {
  name: 'test-subnet'
  params: {
    addressPrefix: '10.0.1.0/24'
    networkName: 'my-vnet'
    networkSecurityGroupId: '<nsg-id>'
    routeTableId: '<route-table-id>'
    serviceDelegation: 'Microsoft.Web/hostingEnvironment'
  }
}
