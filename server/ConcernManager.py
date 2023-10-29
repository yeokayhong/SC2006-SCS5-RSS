from Concern import Concern
from lta_api import LtaApi
import threading
import datetime
import time


class ConcernManager:
    def __init__(self, mode="production"):
        self.concerns = []
        self.sse_instances = []

        self.mode = mode

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
            match self.mode:
                case "production":
                    self.query_train_service_alerts()
                case "development":
                    print("Returning dummy data...")
                    concern = Concern("TrainDisruption", "EW", [
                        "EW1", "EW2"], datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S"), "Test Due to a signal fault, expect delays of 10 minutes for train services between EW1 and EW2")
                    self.update_concerns([concern])
            time.sleep(self.seconds_between_queries)

    def update_concerns(self, concerns: list[Concern]):
        for existing_concern in self.concerns:
            if existing_concern not in concerns:
                self.update_subscribers(
                    event="remove", payload=existing_concern.__dict__)
                self.concerns.remove(existing_concern)

            matching_concern = next(
                concern for concern in concerns if concern == existing_concern)
            if matching_concern.time != existing_concern.time:
                self.update_subscribers(
                    event="update", payload=matching_concern.__dict__)
                self.concerns.remove(existing_concern)
                self.concerns.append(matching_concern)
            concerns.remove(matching_concern)

        for concern in concerns:
            self.update_subscribers(event="add", payload=concern.__dict__)
            self.concerns.append(concern)

    def update_subscribers(self, *args, **kwargs):
        for sse_instance in self.sse_instances:
            sse_instance.send(*args, **kwargs)
        return

    def add_subscriber(self, sse_instance):
        self.sse_instances.append(sse_instance)
        return
