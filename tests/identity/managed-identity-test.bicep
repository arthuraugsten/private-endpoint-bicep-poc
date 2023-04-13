// az deployment group create --resource-group eus2rgsmplintd01 --name mi-resource-test --template-file ./tests/identity/managed-identity-test.bicep --parameters environment=d
@allowed([
  'd'
])
param environment string

//  App resource name constants.
var MANAGED_IDENTITY_NAME = 'bitestint'
var APP_SEQUENCE = '01'

module deployManagedIdentity '../../src/identity/managed-identity.bicep' = {
  name: 'test-managed-identity'
  params: {
    location: 'eastus2'
    resourceShortName: MANAGED_IDENTITY_NAME
    sequence: APP_SEQUENCE
    environment: environment
  }
}
