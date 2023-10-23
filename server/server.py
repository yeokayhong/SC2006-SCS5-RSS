from flask import Flask, request, jsonify
import json
from lta_api import LtaApi
from routes_api import ServerRoutesAPI
from ConcernManager import ConcernManager  # Assuming that the ConcernManager class is already defined

app = Flask(__name__)

# Load configuration file
with open('config.json', 'r') as config_file:
    config = json.load(config_file)

# Create instances of LtaApi and OneMapAPI
lta_api = LtaApi(config['lta_api_key'])
one_map_api = ServerRoutesAPI(config['oneMapEmail'], config['oneMapPassword'])

# Create instances of ConcernManager
concern_manager = ConcernManager()

# Example: Obtain estimated bus waiting time using bus stop code and service number instead of a route object
@app.route('/get_estimated_waiting_time', methods=['GET'])
def get_estimated_waiting_time():
    # Get bus stop code and service number from the request parameters
    bus_stop_code = request.args.get('bus_stop_code')
    service_no = request.args.get('service_no', "")

    try:
        # Call the method of the LtaApi instance to get the estimated waiting time
        estimated_waiting_time = lta_api.get_estimated_waiting_time(bus_stop_code, service_no)
        return jsonify({"estimated_waiting_time": estimated_waiting_time})
    except Exception as e:
        return jsonify({"error": str(e)})

# (To be completed) Call methods from the OneMap API
@app.route('/get_routes_pt', methods=['GET'])
def get_routes_pt():
    # Get parameters from the request
    start = request.args.get('start')
    end = request.args.get('end')
    routeType = request.args.get('routeType')
    date = request.args.get('date')
    time = request.args.get('time')
    mode = request.args.get('mode')
    maxWalkDistance = request.args.get('maxWalkDistance', "1000")
    numItineraries = request.args.get('numItineraries', "3")

    # Get the access token from OneMapAPI
    access_token = one_map_api.fetch_token()

    # Call the get_routes_pt method from OneMapAPI
    routes = one_map_api.get_routes_pt(
        access_token, start, end, routeType, date, time, mode, maxWalkDistance, numItineraries
    )

    return routes

# Assuming that the code for adding potential concern is defined
@app.route('/add_potential_concern', methods=['POST'])
def add_potential_concern():
    # Get the content of potential concern from the request
    content = request.json.get('content')

    # Create a Notification object
    notification = Notification(content)

    # Call the add_potential_concern method of the ConcernManager instance
    concern_manager.add_potential_concern(notification)

    return jsonify({"message": "Potential concern added successfully"})

# Add other app routes here and call methods from RouteManager and ConcernManager

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
