@description('The Azure location/data center to deploy to.')
param location string

@minLength(1)
@maxLength(80)
@description('Peering name.')
param name string

@minLength(2)
@maxLength(30)
@description('Source network short name where the peering will be created.')
param sourceVNetShortName string

@minLength(2)
@maxLength(30)
@description('Destination network short name where the peering will be connected.')
param destinationVNetShortName string

module sourceNameHelper '../virtual-network-name-helper.bicep' = {
  name: 'vn-name-helper-${sourceVNetShortName}-${guid(destinationVNetShortName)}'
  params: {
    location: location
    shortName: sourceVNetShortName
  }
}

module destinationNameHelper '../virtual-network-name-helper.bicep' = {
  name: 'vn-name-helper-${destinationVNetShortName}-${guid(sourceVNetShortName)}'
  params: {
    location: location
    shortName: destinationVNetShortName
  }
}

module peeringDeploy 'internals/peering.bicep' = {
  name: 'vn-name-helper-${sourceVNetShortName}-${destinationVNetShortName}'
  params: {
    name: name
    sourceNetworkName: sourceNameHelper.outputs.name
    destinationNetworkName: destinationNameHelper.outputs.name
    allowForwardedTraffic: true
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    useRemoteGateways: false
  }
}
