import 'package:flutter/material.dart';

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
  // Add more tabs as needed
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

// ... [Your existing code for the pages remains the same]

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60), // For spacing
            Icon(Icons.location_on,
                color: Colors.red, size: 100), // Placeholder icon for the image
            SizedBox(height: 20),
            Text(
              "Travel Scheduler",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Text("Email or Username"),
            TextField(
              decoration: InputDecoration(
                hintText: "Uname@mail.com",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 20),
            Text("Password"),
            TextField(
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: Icon(
                    Icons.visibility_off), // Placeholder for visibility toggle
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text("Forgot Password?"),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Sign in"),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Button color
                onPrimary: Colors.white, // Text color
                minimumSize: Size(double.infinity, 50), // Button size
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapInputPage()),
                );
              },
              child: Text("Continue As Guest"),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey[300], // Button color
                onPrimary: Colors.black, // Text color
                minimumSize: Size(double.infinity, 50), // Button size
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {},
                  child: Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MapInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map Page')),
      body: Column(
        children: [
          Expanded(child: Placeholder()), // This is the placeholder map
          TextField(decoration: InputDecoration(labelText: 'Origin')),
          TextField(decoration: InputDecoration(labelText: 'Destination')),
          ElevatedButton(
            onPressed: () {
              _showRouteOptions(context);
            },
            child: Text('Show Result'),
          )
        ],
      ),
    );
  }

  void _showRouteOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Route options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Route 1'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 1),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Route 2'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 2),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Route 3'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteDetailsPage(routeNumber: 3),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class RouteDetailsPage extends StatelessWidget {
  final int routeNumber;

  RouteDetailsPage({required this.routeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Route #$routeNumber Details')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Route #$routeNumber',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          // Depending on the routeNumber, you can customize the data shown below
          Text('Travel Time: ~ 50 mins'),
          Text('Waiting Time: ~ 5 mins (Train)'),
          Text('Total Estimated Time: ~ 55 mins (Train)'),
          //Text('Cost: ~ $1.50'),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SelectedRoutePage(routeNumber: routeNumber),
                ),
              );
              // Do something when the user selects the route
            },
            child: Text('Select Route'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to Map Input Page
            },
            child: Text('Return'),
          ),
        ],
      ),
    );
  }
}

class SelectedRoutePage extends StatelessWidget {
  final int routeNumber;

  SelectedRoutePage({required this.routeNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selected Route #$routeNumber')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Placeholder(
              fallbackHeight: 200.0), // Placeholder for map showing path
          SizedBox(height: 20),
          Text('Path for Route #$routeNumber',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          // You can fetch the path details for the route using the routeNumber
          SizedBox(height: 20),
          Text('Estimated time remaining: 30 mins'),
          // This can be dynamic based on the route selected
        ],
      ),
    );
  }
}
