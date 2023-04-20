param location string
param resourceName string
param resourceId string
param resourceType string
param tags object
param groupIds array

var dnsConfigs = loadJsonContent('dns-settings.json')
var networkJson = loadJsonContent('network-settings.json')
var vnetLocationConfig = networkJson.vnet[location]

resource vnetPE 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: vnetLocationConfig.name
  scope: resourceGroup(vnetLocationConfig.resourceGroup)

  resource subnetPE 'subnets' existing = {
    name: 'NET-${vnetLocationConfig.prefix}.${networkJson.subnet[tags['HV-Tier']].sn[tags['HV-Project']]}.0_22'
  }
}

// a config file is being used for DNS zone because some resources aren't supported by environment().suffixes
resource privateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' existing = [for groupId in groupIds: {
  name: 'privatelink${dnsConfigs.zoneNames[resourceType][groupId]}'
  scope: resourceGroup(dnsConfigs.resourceGroup[location])
}]

resource privateEndpoints 'Microsoft.Network/privateEndpoints@2022-09-01' = [for groupId in groupIds: {
  name: 'pep-${resourceName}-${groupId}'
  location: location
  tags: union(tags, { 'HV-Source': 'Bicep' })
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'pep-${resourceName}-${groupId}'
        properties: {
          groupIds: [ groupId ]
          privateLinkServiceId: resourceId
        }
      }
    ]
    subnet: {
      id: vnetPE::subnetPE.id
    }
  }
}]

resource privateDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-09-01' = [for (groupId, index) in groupIds: {
  name: 'default-${resourceName}-${groupId}'
  parent: privateEndpoints[index]
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'pvl-${guid(resourceName, groupId)}'
        properties: {
          privateDnsZoneId: privateDnsZones[index].id
        }
      }
    ]
  }
}]
