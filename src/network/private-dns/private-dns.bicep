@description('The Azure location/data center to deploy to.')
param location string

@minLength(3)
@maxLength(12)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param name string

resource dnsDeploy 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: location
  tags: { 'HV-Source': 'Bicep' }
}
