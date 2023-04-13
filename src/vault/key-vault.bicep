@minLength(3)
@maxLength(12)
@description('3-12 lowercase character name/ID of application.  Can only contain letters, no numbers, symbols, or spaces.')
param resourceShortName string

@allowed([
  'n'
  'd'
  'q'
  't'
  'p'
])
@description('Single character indicating the target environment: d (development), q (QA), t (UAT), p (production).')
param environment string

@minLength(2)
@maxLength(2)
@description('Two digit, zero padded resource sequence number (e.g. 01, 02, 03, etc.). Defaults to 01.')
param sequence string = '01'

@description('The Azure location/data center to deploy to.')
param location string

@description('When true, Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault')
param enableForDeployment bool = false

@description('When true, Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enableForDiskEncryption bool = false

@description('When true, Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enableForTemplateDeployment bool = false

@description('When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions')
param enableRbacAuthorization bool = false

@allowed([
  'None'
  'AzureServices'
])
param microsoftServiceByPassFirewall string = 'None'

var deploymentNameSuffix = '${resourceShortName}-${environment}-${sequence}'

module keyVaultNameHelper '../helpers/resource-name-helper.bicep' = {
  name: 'name-helper-kv-${deploymentNameSuffix}'
  params: {
    resourceType: 'keyVault'
    shortName: resourceShortName
    environment: environment
    sequence: sequence
    location: location
  }
}

module keyVaultHelper './internals/key-vault-helper.bicep' = {
  name: 'kv-helper-${deploymentNameSuffix}'
  params: {
    keyVaultName: keyVaultNameHelper.outputs.resourceName
    location: location
    enableForDeployment: enableForDeployment
    enableForDiskEncryption: enableForDiskEncryption
    enableForTemplateDeployment: enableForTemplateDeployment
    enableRbacAuthorization: enableRbacAuthorization
    microsoftServiceByPassFirewall: microsoftServiceByPassFirewall
  }
}

output keyVaultId string = keyVaultHelper.outputs.keyVaultId
output keyVaultName string = keyVaultNameHelper.outputs.resourceName
