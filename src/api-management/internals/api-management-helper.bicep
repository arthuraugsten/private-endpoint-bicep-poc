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
    type: 'SystemAssigned'
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
      
      // Disabling weak ciphers
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'false'
    }
    // hostnameConfigurations: [
    //   {
    //     defaultSslBinding: true
    //     hostName: '${hostname}.augsten.com.br'
    //     //identityClientId: 'string'
    //     keyVaultId: certificateSecretUri
    //     negotiateClientCertificate: false
    //     type: 'Proxy'
    //   }
    // ]
    publicIpAddressId: publicIpId
    publicNetworkAccess: 'Enabled'
    publisherEmail: 'arthuraugsten@outlook.com'//'bcollins@harbourvest.com'
    publisherName: 'HarbourVest'
    virtualNetworkConfiguration: {
      subnetResourceId: subnetId
    }
    virtualNetworkType: 'Internal'
  }
}
