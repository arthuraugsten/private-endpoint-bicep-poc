param name string
param sourceNetworkName string
param destinationNetworkName string
param allowForwardedTraffic bool
param allowGatewayTransit bool
param allowVirtualNetworkAccess bool
param doNotVerifyRemoteGateways bool
param useRemoteGateways bool

resource sourceNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: sourceNetworkName
}

resource destinationNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: destinationNetworkName
}

resource peeringDeploy 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: name
  parent: sourceNetwork
  properties: {
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    doNotVerifyRemoteGateways: doNotVerifyRemoteGateways
    remoteVirtualNetwork: {
      id: destinationNetwork.id
    }
    useRemoteGateways: useRemoteGateways
  }
}
