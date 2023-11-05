import 'package:scheduler_app/entities/address_search_notifier.dart';
import 'package:scheduler_app/entities/route_selection_notifier.dart';
import 'package:scheduler_app/base_classes/set_up.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screens/screens_barrel.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await instanceSetUp();
  runApp(MyApp());
}

enum AppTab {
  mapInput,
  notificationHistory,
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTab _currentTab = AppTab.mapInput;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // Primary Color
          primaryColor: Colors.lightBlue,

          // Secondary (Accent) Color
          secondaryHeaderColor: Colors.orange,

          // Text Theme
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: const Color.fromARGB(255, 8, 37, 87)),
            bodyMedium: TextStyle(color: const Color.fromARGB(255, 8, 37, 87)),
            displayLarge:
                TextStyle(color: const Color.fromARGB(255, 8, 37, 87)),
            // Add more text styles
          ),

          // Customization for BottomNavigationBar
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.lightBlue,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black.withOpacity(0.4),
          ),
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent)

          // Additional theme customization can go here
          ),
      home: Scaffold(
        body: ChangeNotifierProvider(
            create: (context) => RouteSelectionNotifier(),
            child: ChangeNotifierProvider(
                create: (context) => AddressSearchNotifier(),
                child: SafeArea(child: _buildBodyForTab(_currentTab)))),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlue,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(0.4),
          currentIndex: _currentTab.index,
          onTap: (index) {
            setState(() {
              _currentTab = AppTab.values[index];
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: 'Notifications',
            )
            // Add more items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildBodyForTab(AppTab tab) {
    switch (tab) {
      case AppTab.mapInput:
        return MapInputPage();
      case AppTab.notificationHistory:
        return GetIt.instance<NotificationUI>();
    }
  }
}
