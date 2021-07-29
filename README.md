# Deploy

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdeviceinsight%2Fux4iot-quickstart%2Fmaster%2Fquickstart.json)

This deploys an IoT Hub and a ux4iot instance. They are already linked, meaning that ux4iot is configured
with shared access policies to interact with the IoT Hub.

# Note

`quickstart.json` is generated from `quickstart.bicep` using `az bicep build --file quickstart.bicep`
