// az deployment group create --resource-group eus2rgsmplintd01 --name nsg-resource-test --template-file ./tests/network/network-security-group-for-apim-test.bicep

module nsgDeploy '../../src/network/network-security-group/network-security-group-for-apim.bicep' = {
  name: 'test-nsg'
  params: {
    location: 'eastus2'
    subnetAddressSpace: '10.1.1.0'
    name: 'eus2nsgapimd01'
  }
}
