@description('The Azure location/data center to deploy to.')
param location string

@minLength(1)
@maxLength(63)
@description('1-63 lowercase character name of private zone.')
param name string

resource dnsDeploy 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: location
  tags: { 'HV-Source': 'Bicep' }
}
