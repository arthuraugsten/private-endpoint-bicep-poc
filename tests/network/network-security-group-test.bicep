// az deployment group create --resource-group eus2rgsmplintd01 --name nsg-resource-test --template-file ./tests/network/network-security-group-test.bicep

module nsgDeploy '../../src/network/network-security-group/network-security-group.bicep' = {
  name: 'test-nsg'
  params: {
    location: 'eastus2'
    subnetAddressSpace: '10.20.30.40'
    name: 'my-custom-name'
  }
}
