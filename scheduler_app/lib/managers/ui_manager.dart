// // IGNORE THIS ui_manager.dart; ITS REDUNDANT; JUST FOR REFERENCES ONLY 17.10.23 16:52 W9 AY23/24

// // Assuming there is a class `Location` which represents the location data
// class Location {
//   double latitude;
//   double longitude;

//   Location(this.latitude, this.longitude);
// }

// // UserInterfaceManager implementation
// class UserInterfaceManager {
//   // Methods based on the class diagram

//   void displayErrorMessage() {
//     print("Error: An unexpected error occurred.");
//   }

//   void displayEnableLocationServiceMessage() {
//     print("Please enable location services to continue.");
//   }

//   void displayRouteInformation() {
//     // Implementation to display route info
//     print("Displaying route information...");
//   }

//   void displayLiveLocation(Location location) {
//     // Display the live location of the user
//     print(
//         "Current Location: Latitude: ${location.latitude}, Longitude: ${location.longitude}");
//   }

//   Location getRouteRequest() {
//     // Stub implementation. Actual implementation might fetch data from user inputs.
//     return Location(0.0, 0.0);
//   }

//   Location requestCurrentLocation() {
//     // Stub implementation. Actual implementation might fetch live location data.
//     return Location(0.0, 0.0);
//   }

//   void requestRouteCalculation() {
//     // Stub. Actual implementation would initiate route calculations, maybe using an external service.
//     print("Calculating route...");
//   }
// }

// void main() {
//   var uiManager = UserInterfaceManager();
//   uiManager.displayErrorMessage();
//   uiManager.displayEnableLocationServiceMessage();
//   uiManager.displayRouteInformation();
//   uiManager
//       .displayLiveLocation(Location(34.0522, -118.2437)); // Sample location
//   uiManager.getRouteRequest();
//   uiManager.requestCurrentLocation();
//   uiManager.requestRouteCalculation();
// }
