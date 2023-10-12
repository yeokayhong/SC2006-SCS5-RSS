import 'package:flutter/material.dart';
import 'screens/screens_barrel.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.red, // Adjust as needed
//       ),
//       home: AuthenticationPage(),
//       //home: LoginPage(),
//     );
//   }
// }

// ... [Your imports and existing code remains the same]

enum AppTab {
  authentication,
  mapInput,
  routeDetails,
  selectedRoute,
  NotificationHistory,
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTab _currentTab = AppTab.authentication;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: _buildBodyForTab(_currentTab),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.red,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.blue.withOpacity(0.6),
          currentIndex: _currentTab.index,
          onTap: (index) {
            setState(() {
              _currentTab = AppTab.values[index];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map Input',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions),
              label: 'Route Details',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Selected Route',
            ),
            // Add more items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildBodyForTab(AppTab tab) {
    switch (tab) {
      case AppTab.authentication:
        return AuthenticationPage();
      case AppTab.mapInput:
        return MapInputPage();
      case AppTab.routeDetails:
        return RouteDetailsPage(routeNumber: 1); // Placeholder
      case AppTab.selectedRoute:
        return SelectedRoutePage(routeNumber: 1); // Placeholder
      default:
        return AuthenticationPage(); // Default page
    }
  }
}
