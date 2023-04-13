// az deployment group create --resource-group eus2rgsmplintd01 --name vault-resource-test --template-file ./tests/vault/key-vault-test.bicep --parameters environment=d
@allowed([
  'd'
])
param environment string

var KEY_VAULT_NAME = 'bitestint'
var APP_SEQUENCE = '03'

module deployKeyVault '../../src/vault/key-vault.bicep' = {
  name: 'test-key-vault'
  params: {
    location: 'eastus2'
    resourceShortName: KEY_VAULT_NAME
    sequence: APP_SEQUENCE
    environment: environment
    enableRbacAuthorization: true
  }
}
