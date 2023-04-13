@description('The address prefix for the subnet.')
param addressPrefix string

var name = 'NET-${replace(addressPrefix, '/', '_')}'

output subnetName string = name
