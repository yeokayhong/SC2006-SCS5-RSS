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
        time.sleep(30000)
        while True:
            match self.mode:
                case "production":
                    self.query_train_service_alerts()
                case "development":
                    print("Returning dummy data...")
                    concern_periodic = Concern("TrainDisruption", "NS", [
                        "NS5", "NS6"], datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S"), "concern periodic, Test Due to a signal fault, expect delays of 10 minutes for train services between NS5 and NS6")

                    self.update_concerns([concern_periodic])

            time.sleep(self.seconds_between_queries)

    def create_concern(self, choice):
        concern1 = Concern("TrainDisruption", "EW", [
            "EW25", "EW26"], datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S"), "concern1, Test Due to a signal fault, expect delays of 10 minutes for train services between EW1 and EW2")
        concern2 = Concern("TrainDisruption", "EW", [
            "EW25", "EW26", "EW27"], datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S"), "concern2, Test Due to a signal fault, expect delays of 10 minutes for train services between EW1 and EW3")
        concern3 = Concern("TrainBreakdown", "DT", [
            "DT1", "DT2", "DT3", "DT4", "DT5", "DT6", "DT7", "DT8", "DT9", "DT10"], datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S"), "concern_delayed, Test Due to a signal fault, expect delays of 30 minutes for train services between DT1 and DT10")
        concern_empty = Concern("", "", [], None, "")
        concern_error = Concern("", 6, [], None, "")
        if choice == '1':
            self.update_concerns([concern1])
        elif choice == '2':
            self.update_concerns([concern2])
        elif choice == '3':
            self.update_concerns([concern3])
        elif choice == '4':
            self.update_concerns([concern_empty])
        elif choice == '5':
            self.update_concerns([concern_error])
        else:
            print("Invalid choice. Please enter a valid option.")

    def update_concerns(self, concerns: list[Concern]):
        for concern in concerns:
            if (concern.type == "" or concern.service == "" or concern.affected_stops == [] or type(concern.type) != str or type(concern.service) != str):
                pass
            else:
                for existing_concern in self.concerns:
                    if existing_concern not in concerns:
                        self.update_subscribers(
                            event="remove", payload=existing_concern.__dict__)
                        self.concerns.remove(existing_concern)

                    matching_concern = next(
                        (concern for concern in concerns if concern == existing_concern), None)
                    if matching_concern != None:
                        if matching_concern.time != existing_concern.time:
                            self.update_subscribers(
                                event="update", payload=matching_concern.__dict__)
                            self.concerns.remove(existing_concern)
                            self.concerns.append(matching_concern)
                        concerns.remove(matching_concern)

                for concern in concerns:
                    self.update_subscribers(
                        event="add", payload=concern.__dict__)
                    self.concerns.append(concern)

    def update_subscribers(self, *args, **kwargs):
        for sse_instance in self.sse_instances:
            sse_instance.send(*args, **kwargs)
        return

    def add_subscriber(self, sse_instance):
        self.sse_instances.append(sse_instance)
        return
