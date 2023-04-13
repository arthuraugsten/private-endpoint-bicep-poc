@description('The Managed Identity\'s name.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: managedIdentityName
}

output managedIdentityId string = managedIdentity.id
output managedIdentityTenantId string = managedIdentity.properties.tenantId
output managedIdentityClientId string = managedIdentity.properties.clientId
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
