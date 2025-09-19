type subnet = {
  name: string
  addressPrefix: string
}

@description('The name of the virtual network to be deployed')
param virtualNetworkName string
@description('The virtual network CIDR to deploy')
param virtualNetworkCIDR string
@description('An array of subnet configurations containing the name and CIDR range of the subnet. Objects within this array must include a name and addressPrefix value with the type of string.')
param subnetValues subnet[]
@description('The location the resources will be deployed to.')
param location string = 'uksouth'
param tags object

resource virtualNetworkResource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: { 
    addressSpace: { 
      addressPrefixes: [ virtualNetworkCIDR ]
    }
  }

  tags: tags
}

resource networkSecurityGroupResource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = [for subnet in subnetValues: { 
  name: '${subnet.name}-nsg'
  location: location

  tags: tags
}]

resource subnetResource 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = [for (subnet, i) in subnetValues: {
  parent: virtualNetworkResource
  name: subnet.name
  properties: {
    addressPrefix: subnet.addressPrefix
    networkSecurityGroup: {
      id: networkSecurityGroupResource[i].id
    }
  }
}]

output subnetOutputs array = [for (subnet, i) in subnetValues: {
  subnetName: subnet.name
  subnetProperties: subnetResource[i].properties
}]

output nsgOutputs array =  [for (subnet, i) in subnetValues: {
  nsgName: networkSecurityGroupResource[i].name
  nsgProperties: networkSecurityGroupResource[i].properties
}]
