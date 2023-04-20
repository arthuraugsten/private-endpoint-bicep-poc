param location string
param name string
param appServiceEnvironmentId string
param operationalSystem string
param size string
param instanceCount int

resource servicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  tags: { 'HV-Source': 'Bicep' }
  sku: {
    capacity: instanceCount
    family: 'Iv2'
    name: size
    size: size
    tier: 'IsolatedV2'
  }
  kind: operationalSystem
  properties: {
    hostingEnvironmentProfile: {
      id: appServiceEnvironmentId
    }
    perSiteScaling: false
    reserved: operationalSystem == 'linux' ? true : false
    zoneRedundant: false
  }
}
