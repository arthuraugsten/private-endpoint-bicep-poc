@description('The address prefix for the subnet.')
param addressPrefix string

var name = toUpper('NET-${replace(addressPrefix, '/', '_')}')

output subnetName string = name
