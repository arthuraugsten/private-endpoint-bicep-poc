param name string
param location string
param disableBgpRoutePropagation bool
param routes array

resource routeTableDeploy 'Microsoft.Network/routeTables@2022-07-01' = {
  name: name
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: routes
  }
}

output routeTableId string = routeTableDeploy.id
