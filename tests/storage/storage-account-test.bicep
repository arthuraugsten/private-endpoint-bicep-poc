// az deployment group create --resource-group eus2rgsmplintd01 --name storage-resource-test --template-file ./tests/storage/storage-account-test.bicep --parameters environment=d
@allowed([
  'd'
])
param environment string

//  App resource name constants.
var STORAGE_ACCT_NAME = 'biteststore'
var APP_SEQUENCE = '01'

module deployStorageAccount '../../src/storage/storage-account.bicep' = {
  name: 'test-storage-account'
  params: {
    location: 'eastus2'
    resourceShortName: STORAGE_ACCT_NAME
    sequence: APP_SEQUENCE
    environment: environment
  }
}
