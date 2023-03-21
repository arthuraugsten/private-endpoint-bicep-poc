var id = resourceId('Microsoft.Network/VirtualNetworks/subnets', 'my-vnet', 'my-subnet')

output id string = id

// resourceId('Microsoft.Network/VirtualNetworks/subnets', 'my-vnet', 'my-subnet')
// /subscriptions/5b0877a8-0217-477c-9f05-6e6a5d5b0a58/resourceGroups/rg-pep-poc-brsouth/providers/Microsoft.Network/VirtualNetworks/my-vnet/subnets/my-subnet
