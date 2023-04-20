@description('The Azure location/data center to deploy to.')
param location string

@maxLength(80)
@description('Network Security Group name. This parameter will override the default name convention.')
param name string = ''

@description('Network address space to identify the subnet. Ex.: 10.136.248.8')
param subnetAddressSpace string

param rules array = [
  {
    name: 'Any_Inbound'
    properties: {
      description: 'Allow All Inbound Traffic'
      protocol: '*'
      sourceAddressPrefix: '*'
      sourcePortRange: '*'
      destinationPortRange: '0-65535'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
      
    }
  }
  {
    name: 'Any_Outbound'
    properties: {
      description: 'Allow All Outbound Traffic'
      protocol: '*'
      sourceAddressPrefix: '*'
      sourcePortRange: '*'
      destinationPortRange: '0-65535'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
]

var locationCode = loadJsonContent('../../helpers/location-codes.json')[location]
var subnetOctects = split(subnetAddressSpace, '.')

resource nsgDeployment 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: empty(name) ? '${locationCode}nsg-${subnetOctects[1]}-${subnetOctects[2]}-${subnetOctects[3]}' : name
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
  properties: {
    securityRules: rules
  }
}

output nsgId string = nsgDeployment.id
