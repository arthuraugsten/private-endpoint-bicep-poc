// az deployment group create -g eus2rgplinkp01 -n datafactory-test -f ./private-endpoint-datafactory.bicep --parameters region=eastus2 resourceName=eus2cdbsmplintp01 resourceGroupName=eus2rgsmplintp01

@allowed([
  'eastus2'
  'centralus'
])
@description('Region where the private endpoint will be deployed.')
param region string

@maxLength(30)
@minLength(10)
@description('Resource name that will be used to attach a private endpoint.')
param resourceName string

@maxLength(30)
@minLength(10)
@description('Resource name that will be used to attach a private endpoint.')
param resourceGroupName string

var regionSettings = loadJsonContent('region-settings.json')[region]

resource resource 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: resourceName
  scope: resourceGroup(resourceGroupName)
}

module privateEndpoint './private-endpoint.bicep' = {
  name: 'dpl-pep-${resourceName}'
  scope: resourceGroup('${regionSettings}rgplinkp01')
  params: {
    tags: {
      Group: resource.tags.Group
      ITOps: resource.tags.ITOps
      Owner: resource.tags.Owner
      Project: resource.tags.Project
      Tier: resource.tags.Tier
      Allocation: resource.tags.Allocation
    }
    region: region
    resourceName: resource.name
    resourceId: resource.id
    resourceType: resource.type
    groupIds: [
      'dataFactory'
      'portal'
    ]
  }
}
