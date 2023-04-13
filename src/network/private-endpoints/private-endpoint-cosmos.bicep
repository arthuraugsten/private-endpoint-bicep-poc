// az deployment group create -g eus2rgplinkn01 -n cosmos-test -f ./src/network/private-endpoints/private-endpoint-cosmos.bicep --parameters location=eastus2 environment=n resourceName=eus2cdbsmplintd01 resourceGroupName=eus2rgsmplintd01

@allowed([
  'eastus2'
  'centralus'
])
@description('The Azure location/data center to deploy to.')
param location string

@allowed([
  'n'
  'p'
])
param environment string

@maxLength(30)
@minLength(10)
@description('Resource name that will be used to attach a private endpoint.')
param resourceName string

@maxLength(30)
@minLength(10)
@description('Resource name that will be used to attach a private endpoint.')
param resourceGroupName string

var locationCode = loadJsonContent('../internals/location-settings.json')[location]

resource resource 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' existing = {
  name: resourceName
  scope: resourceGroup(resourceGroupName)
}

module privateEndpoint './internals/private-endpoint-helper.bicep' = {
  name: 'dpl-pep-${resourceName}'
  scope: resourceGroup('${locationCode}rgplink${environment}01')
  params: {
    tags: {
      'HV-Group': resource.tags['HV-Group']
      'HV-ITOps': resource.tags['HV-ITOps']
      'HV-Owner': resource.tags['HV-Owner']
      'HV-Project': resource.tags['HV-Project']
      'HV-Tier': resource.tags['HV-Tier']
      'HV-Allocation': resource.tags['HV-Allocation']
    }
    location: location
    resourceName: resource.name
    resourceId: resource.id
    resourceType: resource.type
    groupIds: [ 'sql' ]
  }
}
