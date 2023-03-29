@description('The Azure location/data center to deploy to.')
param location string

@maxLength(30)
@minLength(2)
param shortName string

var regionCode = loadJsonContent('./internals/region-settings.json')[location]
var name = '${regionCode}-VN-${shortName}'

output name string = name
