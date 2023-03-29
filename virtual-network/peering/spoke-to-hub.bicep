@description('The Azure location/data center to deploy to.')
param location string

@minLength(1)
@maxLength(80)
@description('Peering name.')
param name string

@description('Source network short name where the peering will be created.')
param sourceVNetShortName string

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
  name: 'vn-peering-${sourceVNetShortName}-${destinationVNetShortName}'
  params: {
    name: name
    sourceNetworkName: sourceNameHelper.outputs.name
    destinationNetworkName: destinationNameHelper.outputs.name
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    doNotVerifyRemoteGateways: false
    useRemoteGateways: true
  }
}
