@description('The name of the virtual network to be deployed')
param virtualNetworkName string = 'vnet-default'
@description('The virtual network CIDR to deploy')
param virtualNetworkCIDR string = '10.0.0.0/24'
@description('An array of subnet configurations containing the name and ')
param subnetValues array = [
  {
    name: 'subnet-default'
    addressPrefix: '10.0.0.0/25'
  }
]

@description('The location the resources will be deployed to.')
param location string = 'uksouth'
param tags object

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: { 
    addressSpace: { 
      addressPrefixes: [ virtualNetworkCIDR ]
    }
  }

  tags: tags
}

resource networkSecurityGroups 'Microsoft.Network/networkSecurityGroups@2024-07-01' = [for subnet in subnetValues: { 
  name: '${subnet.name}-nsg'
  location: location
}]

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = [for subnet in subnetValues: {
  parent: virtualNetwork
  name: subnet.name
  properties: {
    addressPrefix: subnet.addressPrefix
    networkSecurityGroup: networkSecurityGroups[subnet]
  }
}]


