param virtualNetworkName string
param virtualNetworkCIDR string
param location string
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


