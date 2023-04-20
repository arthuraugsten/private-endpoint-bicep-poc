param location string
param resourceName string
param sku string

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: resourceName
  location: location
  tags: { 'HV-Source': 'Bicep' }
  sku: {
    name: sku
    tier: 'Regional'
  }
  properties: {
    dnsSettings: {
      domainNameLabel: resourceName
    }
    idleTimeoutInMinutes: 4
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

output id string = publicIp.id
