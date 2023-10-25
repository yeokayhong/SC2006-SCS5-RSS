from Concern import Concern
from lta_api import LtaApi
import threading
import time


class ConcernManager:
    def __init__(self):
        self.concerns = []
        self.seconds_between_queries = 300

        self.timer_thread = threading.Thread(target=self.monitor_concerns)
        self.timer_thread.daemon = True
        self.timer_thread.start()

    def get_concerns(self):
        return self.concerns

    def query_train_service_alerts(self):
        print("Querying Train Service Alerts...")
        api = LtaApi()
        response = api.get("/TrainServiceAlerts")
        data = response.json()

        if (data.get("Status", 1) != 2):
            return []

        concerns = []
        for affected_segment, message in zip(data.get("AffectedSegments", []), data.get("Message", [])):
            service = affected_segment["Line"]
            affected_stops = affected_segment["Stations"]
            time = message["CreatedDate"]
            message = message["Content"]

            concern = Concern("TrainDisruption", service,
                              affected_stops, time, message)
            concerns.append(concern)

        self.update_concerns(concerns)

    def monitor_concerns(self):
        while True:
            self.query_train_service_alerts()
            time.sleep(self.seconds_between_queries)

    def update_concerns(self, concerns: list[Concern]):
        for existing_concern in self.concerns:
            if existing_concern not in concerns:
                # Fire remove event
                self.concerns.remove(existing_concern)
            matching_concern = next(
                [concern for concern in concerns if concern == existing_concern])
            if matching_concern.time != existing_concern.time:
                # Fire update event
                self.concerns.remove(existing_concern)
                self.concerns.append(matching_concern)
                concerns.remove(matching_concern)
        for concern in concerns:
            # Fire add event
            self.concerns.append(concern)
