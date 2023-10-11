
# Initial backend for flutter app

## Server Overview

This is a backend server developed using Flask, designed to provide various functionalities called by app. This document will guide you on how to set up and run the project, configure API keys, create new method objects and API routes, and how to call backend methods using the command line or the Dart programming language.

## Environment Setup

### Install Python

Ensure that Python is installed on your computer. It is recommended to use Python 3.x versions.

### Enviornment requirements

Run the following command in your command line to install Flask:

```bash
pip install Flask
```

### Install Dependencies

Depending on your project requirements, you may need to install additional dependencies. Use the `pip` command to install them.

## Configure Secret Key

1. Create a configuration file named `config.json` in the project's root directory.

2. In the `config.json` file, add your API keys and other configuration information. For example:

```json
{
    "lta_api_key": "YOUR_LTA_API_KEY",
    "oneMapEmail": "YOUR_ONEMAP_EMAIL",
    "oneMapPassword": "YOUR_ONEMAP_PASSWORD"
}
```

3. Save and close the `config.json` file.

## Creating New Method Objects and API Routes

### Creating New Method Objects

In your project, you can create new method objects to provide different functionalities. Method objects can be instances of classes, such as `RouteManager` and `ConcernManager`.

### Creating New API Routes

To add new API routes, you can use the `@app.route` decorator on the Flask application object. This will create a view function for a specific URL, which will handle requests from the client and return the appropriate response.

Example:

```python
@app.route('/new_api_route', methods=['GET'])
def new_api_route():
    # Write code to handle the request here
    return jsonify({"message": "This is a new API route"})
```

## Calling Backend Methods

You can call backend methods using the command line or the Dart programming language. Here's an example of using Dart to call the `/get_estimated_waiting_time` route:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final busStopCode = '83139';
  final serviceNo = '15';

  final response = await http.get(
    Uri.parse('http://localhost:5000/get_estimated_waiting_time?bus_stop_code=$busStopCode&service_no=$serviceNo'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Estimated Waiting Time: ${data["estimated_waiting_time"]} minutes');
  } else {
    print('Error: Failed to fetch estimated waiting time.');
  }
}
```
Or you can use this link to test directly 
```
http://localhost:5000/get_estimated_waiting_time?bus_stop_code=83139&service_no=15
```