var iotHubName = 'iothub-${uniqueString(resourceGroup().id)}'
var iotHubServiceConnectionString = 'HostName=${iotHub.properties.hostName};SharedAccessKeyName=iothubowner;SharedAccessKey=${listKeys(iotHub.id, iotHub.apiVersion).value[0].primaryKey}'
var iotHubEventHubConnectionString = 'Endpoint=${iotHub.properties.eventHubEndpoints.events.endpoint};SharedAccessKeyName=iothubowner;SharedAccessKey=${listKeys(iotHub.id, iotHub.apiVersion).value[0].primaryKey};EntityPath=${iotHub.properties.eventHubEndpoints.events.path}'
var managedGroupId = '${resourceGroup().id}-resources-${uniqueString(resourceGroup().id)}'

resource managedApp 'Microsoft.Solutions/applications@2019-07-01' = {
  name: 'ux4iot'
  kind: 'marketplace'
  location: resourceGroup().location
  plan: {
    name: 'standard'
    product: 'ux4iot'
    publisher: 'deviceinsightgmbh-4961725'
    version: '1.0.1'
  }
  properties: {
    managedResourceGroupId: managedGroupId
    parameters: {
      iotHubEventHubConnectionString: {
        value: iotHubEventHubConnectionString
      }
      iotHubServiceConnectionString: {
        value: iotHubServiceConnectionString
      }
    }
  }
}

resource iotHub 'Microsoft.Devices/IotHubs@2021-03-31' = {
  name: iotHubName
  location: resourceGroup().location
  sku: {
    capacity: 1
    name: 'S1'
  }
  properties: {
    routing: {
      fallbackRoute: {
        name: '$fallback'
        source: 'DeviceMessages'
        condition: 'true'
        endpointNames: [
          'events'
        ]
        isEnabled: true
      }
      routes: [
        {
          name: 'ux4iot-twin-changes'
          isEnabled: true
          source: 'TwinChangeEvents'
          condition: 'true'
          endpointNames: [
            'events'
          ]
        }
        {
          name: 'ux4iot-connection-events'
          isEnabled: true
          source: 'DeviceConnectionStateEvents'
          condition: 'true'
          endpointNames: [
            'events'
          ]
        }
      ]
    }
  }
}
