@description('The Azure location/data center to deploy to.')
param location string

@maxLength(80)
@description('Network Security Group name. This parameter will override the default name convention.')
param name string = ''

@description('Network address space to identify the subnet. Ex.: 10.136.248.8')
param subnetAddressSpace string

var subnetOctects = split(subnetAddressSpace, '.')

// https://learn.microsoft.com/en-us/azure/api-management/virtual-network-reference?tabs=stv2#required-ports
var rules = [
  {
    name: 'Permit_From_HTTPS'
    properties: {
      description: 'Client communication to API Management'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'Internet'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }
  {
    name: 'Permit_From_Control_Plane_Management'
    properties: {
      description: 'Management endpoint for Azure portal and PowerShell'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '3443'
      sourceAddressPrefix: 'ApiManagement'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 200
      direction: 'Inbound'
    }
  }
  {
    name: 'Permit_From_Azure_Cache'
    properties: {
      description: 'Access external Azure Cache for Redis service for caching policies between machines (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '6380-6383'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 300
      direction: 'Inbound'
    }
  }
  {
    name: 'Permit_Access_From_Sync_Counters_Rate_Limit'
    properties: {
      description: 'Sync Counters for Rate Limit policies between machines (optional)'
      protocol: 'Udp'
      sourcePortRange: '*'
      destinationPortRange: '4290'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 400
      direction: 'Inbound'
    }
  }
  {
    name: 'Permit_From_Azure_Infrastructure_Load_Balancer'
    properties: {
      description: 'Azure Infrastructure Load Balancer'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '6390'
      sourceAddressPrefix: 'AzureLoadBalancer'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 500
      direction: 'Inbound'
    }
  }
  {
    name: 'Permit_Access_To_Azure_Storage'
    properties: {
      description: 'Dependency on Azure Storage'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Storage'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_Azure_AD'
    properties: {
      description: 'Azure Active Directory and Azure Key Vault dependency (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'AzureActiveDirectory'
      access: 'Allow'
      priority: 200
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_Azure_SQL'
    properties: {
      description: 'Access to Azure SQL endpoints'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '1433'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Sql'
      access: 'Allow'
      priority: 300
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_Azure_Key_Vault'
    properties: {
      description: 'Access to Azure SQL endpoints'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '443'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'AzureKeyVault'
      access: 'Allow'
      priority: 400
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_EventHub'
    properties: {
      description: 'Dependency for Log to Azure Event Hubs policy and Azure Monitor (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRanges: [
        '443'
        '5671-5672'
      ]
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'EventHub'
      access: 'Allow'
      priority: 500
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_FileShare_GIT'
    properties: {
      description: 'Dependency on Azure File Share for GIT (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '445'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Storage'
      access: 'Allow'
      priority: 600
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_Azure_Monitor'
    properties: {
      description: 'Publish Diagnostics Logs and Metrics, Resource Health, and Application Insights (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRanges: [
        '443'
        '1886'
      ]
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'AzureMonitor'
      access: 'Allow'
      priority: 700
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_Azure_Cache'
    properties: {
      description: 'Access external Azure Cache for Redis service for caching policies between machines (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '6380-6383'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 800
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_Sync_Counters_Rate_Limit'
    properties: {
      description: 'Sync Counters for Rate Limit policies between machines (optional)'
      protocol: 'Udp'
      sourcePortRange: '*'
      destinationPortRange: '4290'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'VirtualNetwork'
      access: 'Allow'
      priority: 900
      direction: 'Outbound'
    }
  }
  {
    name: 'Permit_Access_To_SMTP_SMTPS_SMPTALT'
    properties: {
      description: 'SMTP relay for sending emails (optional)'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRanges: [
        '25'
        '587'
        '25028'
      ]
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: 'Internet'
      access: 'Allow'
      priority: 1000
      direction: 'Outbound'
    }
  }
]

module networkSecurityGroup 'network-security-group.bicep' = {
  name: 'dpl-nsg-${subnetOctects[1]}-${subnetOctects[2]}-${subnetOctects[3]}'
  params: {
    location: location
    subnetAddressSpace: subnetAddressSpace
    name: name
    rules: rules
  }
}

output nsgId string = networkSecurityGroup.outputs.nsgId
