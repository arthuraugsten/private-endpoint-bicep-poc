param location string
param name string
param instanceCount int
param sku string
param publicIpId string
param subnetId string

resource apiManagement 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: name
  location: location
  tags: { 'HV-Source': 'Bicep' }
  sku: {
    capacity: instanceCount
    name: sku
  }
  identity: {
    type: 'None'
  }
  properties: {
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'false'
    }
    // hostnameConfigurations: [
    //   {
    //     certificate: {
    //       expiry: 'string'
    //       subject: 'string'
    //       thumbprint: 'string'
    //     }
    //     certificatePassword: 'string'
    //     certificateSource: 'string'
    //     certificateStatus: 'string'
    //     defaultSslBinding: bool
    //     encodedCertificate: 'string'
    //     hostName: 'string'
    //     identityClientId: 'string'
    //     keyVaultId: 'string'
    //     negotiateClientCertificate: bool
    //     type: 'string'
    //   }
    // ]
    publicIpAddressId: publicIpId
    publicNetworkAccess: 'Enabled'
    publisherEmail: 'bcollins@harbourvest.com'
    publisherName: 'HarbourVest'
    virtualNetworkConfiguration: {
      subnetResourceId: subnetId
    }
    virtualNetworkType: 'Internal'
  }
}
