@description('The Azure location/data center to deploy to.')
param location string

@maxLength(30)
@minLength(2)
param shortName string

param sequence string = ''

var locationSetting = loadJsonContent('./internals/location-settings.json')[location]
var name = toUpper('${locationSetting.code}-VN-${shortName}${sequence}')

output name string = name
output resourceGroup string = locationSetting.resourceGroup
