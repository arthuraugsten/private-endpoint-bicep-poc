@description('The Azure location/data center to deploy to.')
param location string

@minLength(1)
@maxLength(63)
@description('1-63 lowercase character name of private zone.')
param zoneName string

@minLength(1)
@maxLength(80)
param linkName string

param virtualNetworkId string

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: zoneName
}

resource link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: linkName
  location: location
  tags: { 'HV-Source': 'Bicep' }
  parent: dnsZone
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworkId
    }
  }
}
