//INFO: Parameter definitions
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

//INFO: Variable Declarations
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
// Adding naming convention to subnet names
var subnetConfigurationClean = [for subnet in subnetConfiguration: {
  name: '${service}-${subnet.name}-${regionShortcode[region]}-${environmentShortcode[environment]}'
  addressPrefix: subnet.addressPrefix
}]

//INFO: Module References
module coreNetwork '../main.bicep' = {
  params: { 
    virtualNetworkName: vnetName
    location: region
    virtualNetworkCIDR: vnetCIDR
    subnetValues: subnetConfigurationClean
    tags: tags
  }
}

//INFO: Outputs
output virtualNetworkOutput object = coreNetwork.outputs.virtualNetworkOutput
output subnetOutputs array = coreNetwork.outputs.subnetOutputs
output nsgOutputs array = coreNetwork.outputs.nsgOutputs

