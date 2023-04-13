param location string
param resourceName string
param subnetId string

resource aseDeployment 'Microsoft.Web/hostingEnvironments@2022-03-01' = {
  name: resourceName
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
  kind: 'ASEV3'
  properties: {
    // clusterSettings: [
    //   {
    //     name: 'string'
    //     value: 'string'
    //   }
    // ]
    // dedicatedHostCount: int
    dnsSuffix: '${resourceName}.appserviceenvironment.net'
    internalLoadBalancingMode: 'Web, Publishing'
    networkingConfiguration: {
      properties: {
        allowNewPrivateEndpointConnections: true
        ftpEnabled: false
        remoteDebugEnabled: false
      }
    }
    upgradePreference: 'None'
    virtualNetwork: {
      id: subnetId
    }
    zoneRedundant: false
  }
}
