// az deployment group create --resource-group <resource-group> --name peering-resource-test --template-file ./tests/network/peering-test.bicep

module hubToSpokeDeploy '../../src/network/virtual-network/peering/hub-to-spoke.bicep' = {
  name: 'test-hub-peering'
  params: {
    location: 'eastus2'
    name: 'hub-to-spoke'
    sourceVNetShortName: 'hub'
    destinationVNetShortName: 'spoke'
  }
}

module spokeToHubDeploy '../../src/network/virtual-network/peering/spoke-to-hub.bicep' = {
  name: 'test-spoke-peering'
  params: {
    location: 'eastus2'
    name: 'spoke-to-hub'
    sourceVNetShortName: 'spoke'
    destinationVNetShortName: 'hub'
  }
}
