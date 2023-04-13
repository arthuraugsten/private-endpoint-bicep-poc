// az deployment group create --resource-group eus2rgsmplintd01 --name ase-resource-test --template-file ./tests/web/app-service-environment-test.bicep --parameters environment=n

@allowed([
  'n'
])
param environment string

module aseDeploy '../../src/web/app-service-environment.bicep' = {
  name: 'dpl-ase-test'
  params: {
    addressPrefix: ''
    environment: environment
    location: 'eastus2'
    resourceShortName: 'smplase'
    vnetSequence: '01'
    vnetShortName: 'nonprod'
    sequence: '01'
  }
}
