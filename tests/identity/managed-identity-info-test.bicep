// az deployment group create --resource-group eus2rgsmplintd01 --name mi-resource-test --template-file ./tests/identity/managed-identity-info-test.bicep --parameters environment=d
@allowed([
  'd'
])
param environment string

module deployManagedIdentity '../../src/identity/managed-identity-info.bicep' = {
  name: 'test-managed-identity'
  params: {
    managedIdentityName: 'eus2mismplint${environment}01'
  }
}
