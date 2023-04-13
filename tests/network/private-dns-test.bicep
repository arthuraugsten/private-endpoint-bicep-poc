// az deployment group create --resource-group eus2rgdnsp01 --name pdns-resource-test --template-file ./tests/network/private-dns-test.bicep

module dnsDeploy '../../src/network/private-dns/private-dns.bicep' = {
  name: 'dpl-pdns-test'
  params: {
    location: 'eastus2'
    name: 'mysite.com'
  }
}
