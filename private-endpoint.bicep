param region string
param resourceName string
param resourceId string
param resourceType string
param tags object
param groupIds array

var dnsConfigs = loadJsonContent('dns-settings.json')
var networkJson = loadJsonContent('network-settings.json')
var vnetRegionConfig = networkJson.vnet[region]

resource vnetPE 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetRegionConfig.name
  scope: resourceGroup(vnetRegionConfig.resourceGroup)

  resource subnetPE 'subnets' existing = {
    name: 'NET-${vnetRegionConfig.preffix}.${networkJson.subnet[tags.Tier].sn[tags.Project]}.0_22'
  }
}


// a config file is being used for DNS zone because some resources aren't support by environment().suffixes
resource privateDnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' existing = [for groupId in groupIds: {
  name: 'privatelink${dnsConfigs.zoneNames[resourceType][groupId]}'
  scope: resourceGroup(dnsConfigs.resourceGroup[region])
}]

resource privateEndpoints 'Microsoft.Network/privateEndpoints@2022-07-01' = [for groupId in groupIds: {
  name: 'pep-${resourceName}-${groupId}'
  location: region
  tags: tags
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
      // resourceId('Microsoft.Network/VirtualNetworks/subnets', 'my-vnet', 'my-subnet')
      // /subscriptions/5b0877a8-0217-477c-9f05-6e6a5d5b0a58/resourceGroups/rg-pep-poc-brsouth/providers/Microsoft.Network/VirtualNetworks/my-vnet/subnets/my-subnet
    }
  }
}]

resource privateDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = [for (groupId, index) in groupIds: {
  name: 'default-${groupId}'
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
