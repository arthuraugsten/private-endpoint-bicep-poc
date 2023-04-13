// az deployment group create --resource-group eus2rgroutep01 --name rt-resource-test --template-file ./tests/network/route-table-test.bicep

var CUSTOM_NAME = ''

module nsgDeploy '../../src/network/route-table/route-table.bicep' = {
  name: 'test-rt'
  params: {
    location: 'eastus2'
    subnetAddressSpace: '10.20.30.40'
    groupShortName: 'smpltst'
    disableBgpRoutePropagation: true
    routeType: 'service'
    name: CUSTOM_NAME
    routes: []
  }
}
