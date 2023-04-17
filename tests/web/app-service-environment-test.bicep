// az deployment group create --resource-group eus2rgsmplasen01 --name ase-resource-test --template-file ./tests/web/app-service-environment-test.bicep --parameters environment=n

@allowed([
  'n'
])
param environment string

module aseDeploy '../../src/web/app-service-environment.bicep' = {
  name: 'dpl-ase-test'
  params: {
    addressPrefix: '10.1.0.0/24'
    environment: environment
    location: 'eastus2'
    resourceShortName: 'smplase'
    sequence: '01'
    vnetShortName: 'nonprod'
    vnetSequence: '01'
  }
}

module aspDeploy '../../src/web/app-service-plan.bicep' = {
  name: 'dpl-asp-test'
  params: {
    appServiceEnvironmentId: aseDeploy.outputs.id
    environment: 'd'
    location: 'eastus2'
    operationalSystem: 'linux'
    resourceShortName: 'smpl'
    size: 'I1v2'
    sequence: '01'
    instanceCount: 1
  }
}
