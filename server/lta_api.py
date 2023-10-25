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
