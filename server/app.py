from flask_queue_sse import ServerSentEvents
from flask import Flask, request, jsonify
from ConcernManager import ConcernManager
from routes_api import ServerRoutesAPI
from dotenv import load_dotenv
from lta_api import LtaApi
import os
from flask_restx import Api, Resource

load_dotenv()
app = Flask(__name__)

# Create instances of LtaApi and OneMapAPI
lta_api = LtaApi(os.getenv("LTA_API_KEY"))
one_map_api = ServerRoutesAPI(
    os.getenv("ONEMAP_EMAIL"), os.getenv("ONEMAP_PASSWORD"))

# Create instances of ConcernManager
concern_manager = ConcernManager(mode=os.getenv("MODE"))

api = Api(app, doc='/')
# HelloWorld resource as provided
@api.route('/hello')
class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}

# EstimatedWaitingTime resource
class EstimatedWaitingTime(Resource):
    def get(self):
        bus_stop_code = request.args.get('bus_stop_code')
        service_no = request.args.get('service_no', "")
        try:
            estimated_waiting_time = lta_api.get_estimated_waiting_time(bus_stop_code, service_no)
            return jsonify({"estimated_waiting_time": estimated_waiting_time})
        except Exception as e:
            return jsonify({"error": str(e)})

# Register the resource with the API
api.add_resource(EstimatedWaitingTime, '/get_estimated_waiting_time')

# TrainServiceAlerts resource
class TrainServiceAlerts(Resource):
    def get(self):
        try:
            alerts = lta_api.get_train_service_alerts()
            disrupted_services = [alert for alert in alerts if alert['Status'] == '2']
            if not disrupted_services:
                return jsonify({"message": "All train services are operating normally."})
            return jsonify({"disrupted_services": disrupted_services})
        except Exception as e:
            return jsonify({"error": str(e)})

# Register the resource with the API
api.add_resource(TrainServiceAlerts, '/query_train_service_discription')

# PlatformCrowdDensityRealtime resource
class PlatformCrowdDensityRealtime(Resource):
    def get(self):
        train_line = request.args.get('train_line')
        if not train_line:
            return jsonify({"error": "TrainLine parameter is required"})
        try:
            density_data = lta_api.get_platform_crowd_density_realtime(train_line)
            return jsonify(density_data)
        except Exception as e:
            return jsonify({"error": str(e)})

# Register the resource with the API
api.add_resource(PlatformCrowdDensityRealtime, '/get_platform_crowd_density_realtime')

# PlatformCrowdDensityForecast resource
class PlatformCrowdDensityForecast(Resource):
    def get(self):
        train_line = request.args.get('train_line')
        if not train_line:
            return jsonify({"error": "TrainLine parameter is required"})
        try:
            forecast_data = lta_api.get_platform_crowd_density_forecast(train_line)
            return jsonify(forecast_data)
        except Exception as e:
            return jsonify({"error": str(e)})

# Register the resource with the API
api.add_resource(PlatformCrowdDensityForecast, '/get_platform_crowd_density_forecast')

# CrowdDensity resource
class CrowdDensity(Resource):
    def get(self):
        train_line = request.args.get('train_line')
        station = request.args.get('station')
        time = request.args.get('time')
        if not all([train_line, station, time]):
            return jsonify({"error": "TrainLine, Station and Time parameters are required"})
        fixed_time = time.replace(" ", "+")
        query_time = datetime.fromisoformat(fixed_time)
        density_data = lta_api.get_platform_crowd_density_realtime(train_line)
        for entry in density_data['value']:
            start_time = datetime.fromisoformat(entry['StartTime'])
            end_time = datetime.fromisoformat(entry['EndTime'])
            if entry['Station'] == station and start_time <= query_time <= end_time:
                return jsonify({"CrowdLevel": entry['CrowdLevel'], "StartTime": entry['StartTime'], "EndTime": entry['EndTime']})
        return jsonify({"error": "No data found for given station and time."})

# Register the resource with the API
api.add_resource(CrowdDensity, '/query_crowded_Stations')

# RoutesPT resource
class RoutesPT(Resource):
    def get(self):
        start = request.args.get('start')
        end = request.args.get('end')
        routeType = request.args.get('routeType')
        date = request.args.get('date')
        time = request.args.get('time')
        mode = request.args.get('mode')
        maxWalkDistance = request.args.get('maxWalkDistance', "1000")
        numItineraries = request.args.get('numItineraries', "3")
        access_token = one_map_api.fetch_token()
        routes = one_map_api.get_routes_pt(
            access_token, start, end, routeType, date, time, mode, maxWalkDistance, numItineraries
        )
        return routes

# Register the resource with the API
api.add_resource(RoutesPT, '/get_routes_pt')

# Concerns resource
class Concerns(Resource):
    def get(self):
        concerns = concern_manager.get_concerns()
        response = jsonify({"concerns": [concern.__dict__ for concern in concerns]})
        print(response)
        return response

# Register the resource with the API
api.add_resource(Concerns, '/concerns')

# Subscribe resource
class Subscribe(Resource):
    def get(self):
        print('subscribed')
        sse = ServerSentEvents()
        concern_manager.add_subscriber(sse)
        return sse.response()

# Register the resource with the API
api.add_resource(Subscribe, '/concerns/subscribe')

# UserInput resource
class UserInput(Resource):
    def post(self):
        try:
            data = request.get_json()
            choice = data.get('choice')
            if choice is not None:
                concern_manager.create_concern(choice)
                print(f'Received choice: {choice}')
                return {'message': 'Choice received and processed successfully'}, 200
            else:
                return {'error': 'Invalid data'}, 400
        except Exception as e:
            return {'error': 'Error processing the request'}, 500
# Register the resource with the API
api.add_resource(UserInput, '/get_user_input')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)