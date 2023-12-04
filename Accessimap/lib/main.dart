import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  Set<Marker> markers = {};
  // State variables for checkbox responses
  bool isEntranceAccessibleYes = false;
  bool isEntranceAccessibleNo = false;
  bool isRestroomAccessibleYes = false;
  bool isRestroomAccessibleNo = false;
  bool isStaffAvailableYes = false;
  bool isStaffAvailableNo = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Determine the current position
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      // Add a marker for the current location
      markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: currentLocation!,
        ),
      );
      // TODO: Add more markers for nearby buildings
    });
  }

  Widget _buildQuestionCheckbox(
      String question,
      bool checkboxValueYes,
      Function(bool?) onChangedYes,
      bool checkboxValueNo,
      Function(bool?) onChangedNo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(question),
        CheckboxListTile(
          title: const Text('Yes'),
          value: checkboxValueYes,
          onChanged: onChangedYes,
        ),
        CheckboxListTile(
          title: const Text('No'),
          value: checkboxValueNo,
          onChanged: onChangedNo,
        ),
      ],
    );
  }

  void _onMarkerTapped(String markerId) {
    // Implement your logic for when a marker is tapped
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Building Information'),
          content: Text(
              'Accessible Entrence: Yes\n Accessible Restroom: Yes\n Assitant staff: Yes\n '),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
            ),
            TextButton(
              child: Text('Check Accessibility',
                  style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the current dialog
                _showAccessibilityDetails();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAccessibilityDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accessibility Details'),
          content: SingleChildScrollView(
            // Using SingleChildScrollView for better handling of longer content
            child: ListBody(
              children: <Widget>[
                _buildQuestionCheckbox(
                  'Is there an accessible entrance to the building?',
                  isEntranceAccessibleYes,
                  (newValue) {
                    setState(() {
                      isEntranceAccessibleYes = newValue!;
                      if (newValue) isEntranceAccessibleNo = false;
                    });
                  },
                  isEntranceAccessibleNo,
                  (newValue) {
                    setState(() {
                      isEntranceAccessibleNo = newValue!;
                      if (newValue) isEntranceAccessibleYes = false;
                    });
                  },
                ),
                _buildQuestionCheckbox(
                  'Is there an accessible restroom in the building?',
                  isRestroomAccessibleYes,
                  (newValue) {
                    setState(() {
                      isRestroomAccessibleYes = newValue!;
                      if (newValue) isRestroomAccessibleNo = false;
                    });
                  },
                  isRestroomAccessibleNo,
                  (newValue) {
                    setState(() {
                      isRestroomAccessibleNo = newValue!;
                      if (newValue) isRestroomAccessibleYes = false;
                    });
                  },
                ),
                _buildQuestionCheckbox(
                  'Is there a helping staff available for contact upon visiting the building?',
                  isStaffAvailableYes,
                  (newValue) {
                    setState(() {
                      isStaffAvailableYes = newValue!;
                      if (newValue) isStaffAvailableNo = false;
                    });
                  },
                  isStaffAvailableNo,
                  (newValue) {
                    setState(() {
                      isStaffAvailableNo = newValue!;
                      if (newValue) isStaffAvailableYes = false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('AccessiMap'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: currentLocation!,
          zoom: 15.0,
        ),
        markers: Set<Marker>.of(markers.map((marker) => marker.copyWith(
              onTapParam: () => _onMarkerTapped(marker.markerId.value),
            ))),
      ),
    );
  }
}
