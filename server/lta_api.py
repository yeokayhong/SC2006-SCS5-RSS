from datetime import datetime
import requests
import os


class LtaApi:
    def __init__(self, api_key=os.getenv("LTA_API_KEY")):
        self.api_key = api_key
        self.base_url = "http://datamall2.mytransport.sg/ltaodataservice"

    def get(self, path, *args, **kwargs):
        url = f"{self.base_url}{path}"
        headers = {
            'AccountKey': self.api_key,
        }
        return requests.get(url, headers=headers, *args, **kwargs)

    def get_train_service_alerts(self):
        url = f"{self.base_url}/TrainServiceAlerts"
        headers = {
            'AccountKey': self.api_key,
        }

        try:
            response = requests.get(url, headers=headers)

            if response.status_code == 200:
                data = response.json()
                # Assuming the response contains a 'value' key with the alerts
                return data['value']
            else:
                raise Exception(
                    f"Failed to fetch train service alerts. Status code: {response.status_code}")
        except Exception as e:
            raise Exception(f"Failed to get train service alerts: {e}")

    def get_platform_crowd_density_realtime(self, train_line):
        url = f"{self.base_url}/PCDRealTime?TrainLine={train_line}"
        headers = {
            'AccountKey': self.api_key,
        }

        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            raise Exception(
                f"Failed to fetch platform crowd density real-time: {e}")

    def get_platform_crowd_density_forecast(self, train_line):
        url = f"{self.base_url}/PCDForecast?TrainLine={train_line}"
        headers = {
            'AccountKey': self.api_key,
        }

        try:
            response = requests.get(url, headers=headers)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            raise Exception(
                f"Failed to fetch platform crowd density forecast: {e}")

    def get_estimated_waiting_time(self, bus_stop_code, service_no=""):
        url = f"{self.base_url}/BusArrivalv2?BusStopCode={bus_stop_code}&ServiceNo={service_no}"
        headers = {
            'AccountKey': self.api_key,
        }
        return requests.get(url, headers=headers, *args, **kwargs)

    def get_estimated_waiting_time(self, bus_stop_code, service_no=""):
        try:
            response = self.get(
                f"/BusArrivalv2?BusStopCode={bus_stop_code}&ServiceNo={service_no}")

            if response.status_code == 200:
                data = response.json()
                services = data.get('Services', [])

                if services:
                    first_bus = services[0]
                    estimated_arrival = first_bus['NextBus']['EstimatedArrival']

                    # Parse estimatedArrival string and convert it to minutes
                    estimated_arrival_time = datetime.strptime(
                        estimated_arrival, "%Y-%m-%dT%H:%M:%S%z")
                    now = datetime.now(estimated_arrival_time.tzinfo)
                    waiting_time = estimated_arrival_time - now

                    waiting_minutes = waiting_time.total_seconds() / 60.0
                    return waiting_minutes
                else:
                    raise Exception('No bus services available at the moment.')
            else:
                raise Exception('Failed to fetch estimated waiting time.')
        except Exception as e:
            raise Exception(f'Failed to get estimated waiting time: {e}')
