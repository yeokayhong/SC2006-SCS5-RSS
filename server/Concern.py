class Concern:
    def __init__(self, type, service, affected_stops, time, message):
        self.type = type
        self.service = service
        self.affected_stops = affected_stops
        self.time = time
        self.message = message

    def __eq__(self, other):
        if (not isinstance(other, Concern)):
            return False
        return self.type == other.type and self.service == other.service
