// az deployment group create --resource-group eus2rgsmplasen01 --name apim-resource-test --template-file ./tests/api-management/api-management-test.bicep

module apiManagement '../../src/api-management/api-management.bicep' = {
  name: 'dpl-apim-test'
  params: {
    addressPrefix: '10.1.1.0/24'
    environment: 'd'
    location: 'eastus2'
    resourceShortName: 'smpl'
    sku: 'Developer'
    vnetSequence: '01'
    vnetShortName: 'nonprod'
    instanceCount: 1
    sequence: '02'
  }
}
