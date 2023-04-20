param keyVaultName string
param location string
param enableForDeployment bool
param enableForDiskEncryption bool
param enableForTemplateDeployment bool
param enableRbacAuthorization bool
param microsoftServiceByPassFirewall string

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForDeployment: enableForDeployment
    enabledForDiskEncryption: enableForDiskEncryption
    enabledForTemplateDeployment: enableForTemplateDeployment
    enableSoftDelete: true
    enableRbacAuthorization: enableRbacAuthorization
    publicNetworkAccess: 'disabled'
    enablePurgeProtection: true
    networkAcls: {
      bypass: microsoftServiceByPassFirewall
      ipRules: []
      defaultAction: 'Deny'
    }
  }
}

output keyVaultId string = keyVault.id
