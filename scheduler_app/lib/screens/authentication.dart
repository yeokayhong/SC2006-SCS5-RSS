import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens_barrel.dart';

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
