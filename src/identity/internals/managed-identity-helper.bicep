param managedIdentityName string
param location string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: union(resourceGroup().tags, { 'HV-Source': 'Bicep' })
}

output managedIdentityTenantId string = managedIdentity.properties.tenantId
output managedIdentityId string = managedIdentity.id
output managedIdentityClientId string = managedIdentity.properties.clientId
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
