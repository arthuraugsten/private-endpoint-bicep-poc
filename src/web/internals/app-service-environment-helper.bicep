param location string
param resourceName string
param subnetId string

resource aseDeployment 'Microsoft.Web/hostingEnvironments@2022-09-01' = {
  name: resourceName
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
  kind: 'ASEV3'
  properties: {
    clusterSettings: [
      {
        name: 'InternalEncryption'
        value: 'true'
      }
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    internalLoadBalancingMode: 'Web, Publishing'
    upgradePreference: 'None'
    virtualNetwork: {
      id: subnetId
    }
    zoneRedundant: false
  }

  resource networkASE 'configurations' = {
    name: 'networking'
    properties: {
      allowNewPrivateEndpointConnections: true
      ftpEnabled: false
      remoteDebugEnabled: false
    }
  }
}

output id string = aseDeployment.id
output internalIp string = aseDeployment::networkASE.properties.internalInboundIpAddresses[0]
