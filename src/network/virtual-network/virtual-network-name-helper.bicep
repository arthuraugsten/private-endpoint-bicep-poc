@description('The Azure location/data center to deploy to.')
param location string

@maxLength(30)
@minLength(2)
param shortName string

param sequence string = ''

var locationCode = loadJsonContent('../internals/location-settings.json')[location]
var name = '${locationCode}-VN-${shortName}${sequence}'
var resourceGroup = '${locationCode}-RG-NET'

output name string = name
output resourceGroup string = resourceGroup
