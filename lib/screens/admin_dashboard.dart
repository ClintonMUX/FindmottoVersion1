import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  List<String> drivers = []; // List to store registered drivers

  // Assume you have a method to fetch registered drivers from your backend
  Future<void> _fetchDrivers() async {
    // Fetch the list of registered drivers from your backend server
    // ...
    // Populate the drivers list
    // ...
  }

  Future<void> _authenticateDriver(String driverName) async {
    // Send a request to your backend server to authenticate the driver with the given name
    // ...
    // Handle the response
    // ...
  }

  Future<void> _logout() async {
    // Handle logout logic
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                // Authenticate Drivers button pressed
                // Implement your logic or navigation here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 24),
              ),
              child: Text('Authenticate Drivers'),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                // View Registered Drivers button pressed
                // Implement your logic or navigation here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 24),
              ),
              child: Text('View Registered Drivers'),
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                _logout(); // Logout button pressed
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                primary: Colors.yellow,
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.black), // Set text color to black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
