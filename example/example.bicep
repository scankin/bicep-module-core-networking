param service string = 'sc4'
param region string = 'uksouth'
param environment string = 'development'
param vnetCIDR string = '10.0.0.0/24'
param subnetConfiguration array = [
  {
    name: 'subnet-1'
    addressPrefix: '10.0.0.0/25'
  }
  {
    name: 'subnet-2'
    addressPrefix: '10.0.0.128/25'
  }
]

var regionShortcode object = {
  uksouth: 'uks'
  ukwest: 'ukw'
}

var environmentShortcode object = {
  development: 'dev'
  staging: 'stg'
  UAT: 'uat'
}

var tags object = {
  environment: environmentShortcode[environment]
  region: region
  service: service
}

var vnetName string = '${service}-vnet-${regionShortcode[region]}-${environmentShortcode[environment]}'

module coreNetwork '../main.bicep' = {
  params: { 
    virtualNetworkName: vnetName
    virtualNetworkCIDR: vnetCIDR
    subnetValues: subnetConfiguration
    tags: tags
  }
}

