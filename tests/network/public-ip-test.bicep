// az deployment group create --resource-group <resource-group> --name pip-resource-test --template-file ./tests/network/public-ip-test.bicep

module pipDeploy '../../src/network/public-ip/public-ip.bicep' = {
  name: 'dpl-pip-test'
  params: {
    environment: 'd'
    location: 'eastus2'
    sku: 'Standard'
    targetResourceSequence: '01'
    targetResourceShortName: 'smpl'
    targetResourceType: 'apiManagementService'
  }
}
