import requests
import json
from flask import jsonify

class ServerRoutesAPI:
    def __init__(self, email, password):
        self.email = email
        self.password = password

    def fetch_token(self):
        url = "https://www.onemap.gov.sg/api/auth/post/getToken"
        payload = {
            "email": self.email,
            "password": self.password
        }

        response = requests.post(url, json=payload, headers={'Content-Type': 'application/json'})

        if response.status_code == 200:
            access_token = response.json().get("access_token")
            return access_token
        else:
            raise Exception('Failed to get token')

    @staticmethod
    def get_routes_pt(accessToken, start, end, routeType, date, time, mode, maxWalkDistance="1000", numItineraries="3"):
        url = f"https://www.onemap.gov.sg/api/public/routingsvc/route?start={start}&end={end}&routeType={routeType}&date={date}&time={time}&mode={mode}&maxWalkDistance={maxWalkDistance}&numItineraries={numItineraries}"
        headers = {'Authorization': accessToken}

        result = {"error": ""}
        
        response = requests.get(url, headers=headers)
        
        if response.status_code == 200:
            json_data = response.json()
            if json_data.get('plan', {}).get('itineraries'):
                result.update(json_data)
            else:
                result["error"] = "No Routes Found"
        else:
            result["error"] = f"Failed to fetch routes: {response.status_code}"
        print(f"Response: {result}")
            
        return result
