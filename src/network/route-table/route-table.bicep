@description('The Azure location/data center to deploy to.')
param location string

@maxLength(80)
@description('Route Table name. This parameter will override the default name convention.')
param name string = ''

@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param groupShortName string

@allowed([
  'project'
  'service'
])
param routeType string

@description('When true, disable the routes learned by BGP on that route table')
param disableBgpRoutePropagation bool

@description('Collection of routes contained within a route table. Objects in this array should follow the structure bellow. It should follow **_Route_** object schema')
param routes array

@description('Network address space to identify the subnet. Ex.: 10.136.248.8')
param subnetAddressSpace string

var locationCode = loadJsonContent('../../helpers/location-codes.json')[location]
var subnetOctects = split(subnetAddressSpace, '.')

var routeName = routeType == 'service' ? '${subnetOctects[2]}-${subnetOctects[3]}' : '${subnetOctects[2]}'

module routeTableDeploy 'internals/route-table-helper.bicep' = {
  name: 'dpl-rt-${routeName}'
  params: {
    name: empty(name) ? '${locationCode}${groupShortName}-${routeName}' : name
    location: location
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: routes
  }
}

output routeTableId string = routeTableDeploy.outputs.routeTableId
