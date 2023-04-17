@minLength(1)
@maxLength(63)
@description('1-63 lowercase character name of private zone.')
param zoneName string

@description('Entry to be added in Private DNS Zone.')
param entryName string

@description('IP that this entry will point to.')
param ip string

@description('TTL for this entry.')
param ttl int = 3600

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: zoneName
}

resource record 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: entryName
  parent: dnsZone
  properties: {
    aRecords: [
      {
        ipv4Address: ip
      }
    ]
    ttl: ttl
  }
}
