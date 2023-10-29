from flask_queue_sse import ServerSentEvents
from flask import Flask, request, jsonify
from ConcernManager import ConcernManager
from routes_api import ServerRoutesAPI
from dotenv import load_dotenv
from lta_api import LtaApi
import os

load_dotenv()
app = Flask(__name__)

# Create instances of LtaApi and OneMapAPI
lta_api = LtaApi(os.getenv("LTA_API_KEY"))
one_map_api = ServerRoutesAPI(
    os.getenv("ONEMAP_EMAIL"), os.getenv("ONEMAP_PASSWORD"))

# Create instances of ConcernManager
concern_manager = ConcernManager(mode=os.getenv("MODE"))

# Example: Obtain estimated bus waiting time using bus stop code and service number instead of a route object


@app.route('/get_estimated_waiting_time', methods=['GET'])
def get_estimated_waiting_time():
    # Get bus stop code and service number from the request parameters
    bus_stop_code = request.args.get('bus_stop_code')
    service_no = request.args.get('service_no', "")

    try:
        # Call the method of the LtaApi instance to get the estimated waiting time
        estimated_waiting_time = lta_api.get_estimated_waiting_time(
            bus_stop_code, service_no)
        return jsonify({"estimated_waiting_time": estimated_waiting_time})
    except Exception as e:
        return jsonify({"error": str(e)})


@app.route('/query_train_service_discription', methods=['GET'])
def get_train_service_alerts():
    try:
        alerts = lta_api.get_train_service_alerts()

        disrupted_services = [
            alert for alert in alerts if alert['Status'] == '2']

        if not disrupted_services:
            return jsonify({"message": "All train services are operating normally."})

        return jsonify({"disrupted_services": disrupted_services})
    except Exception as e:
        return jsonify({"error": str(e)})
# for test only


@app.route('/get_platform_crowd_density_realtime', methods=['GET'])
def get_platform_crowd_density_realtime():
    train_line = request.args.get('train_line')
    if not train_line:
        return jsonify({"error": "TrainLine parameter is required"})

    try:
        density_data = lta_api.get_platform_crowd_density_realtime(train_line)
        return jsonify(density_data)
    except Exception as e:
        return jsonify({"error": str(e)})
# for test only


@app.route('/get_platform_crowd_density_forecast', methods=['GET'])
def get_platform_crowd_density_forecast():
    train_line = request.args.get('train_line')
    if not train_line:
        return jsonify({"error": "TrainLine parameter is required"})

    try:
        forecast_data = lta_api.get_platform_crowd_density_forecast(train_line)
        return jsonify(forecast_data)
    except Exception as e:
        return jsonify({"error": str(e)})


'''
sample input curl "http://localhost:5000/query_crowded_Stations?train_line=EWL&station=EW1&time=2023-10-25T21:16:00%2B08:00"
where 2023-10-25T21:16:00 is a valid time can be identity by get_platform_crowd_density_realtime function
'''


@app.route('/query_crowded_Stations', methods=['GET'])
def get_crowd_density():
    train_line = request.args.get('train_line')
    station = request.args.get('station')
    time = request.args.get('time')

    # Check if all parameters are provided
    if not all([train_line, station, time]):
        return jsonify({"error": "TrainLine, Station and Time parameters are required"})
    # density_data = lta_api.get_platform_crowd_density_forecast(train_line)
    density_data = lta_api.get_platform_crowd_density_realtime(train_line)

    # Convert the provided time to a datetime object
    fixed_time = time.replace(" ", "+")
    query_time = datetime.fromisoformat(fixed_time)

    # Find the matching entry based on train_line, station and time
    for entry in density_data['value']:
        start_time = datetime.fromisoformat(entry['StartTime'])
        end_time = datetime.fromisoformat(entry['EndTime'])

        # Look for an entry where the query time is within the start and end times
        if entry['Station'] == station and start_time <= query_time <= end_time:
            return jsonify({"CrowdLevel": entry['CrowdLevel'], "StartTime": entry['StartTime'], "EndTime": entry['EndTime']})

    # If no matching entry is found
    return jsonify({"error": "No data found for given station and time."})

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


@app.route('/concerns', methods=['GET'])
def get_concerns():
    concerns = concern_manager.get_concerns()
    response = jsonify(
        {"concerns": [concern.__dict__ for concern in concerns]})
    print(response)
    return response


@app.route('/concerns/subscribe', methods=['GET'])
def subscribe():
    sse = ServerSentEvents()
    concern_manager.add_subscriber(sse)
    return sse.response()

# Add other app routes here and call methods from RouteManager and ConcernManager


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
