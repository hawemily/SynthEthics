import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'bottomsheet.dart';
import 'package:geolocator/geolocator.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  GoogleMapController mapController;

  LatLng center;

  @override
  void initState() {
    super.initState();
    this.getDistance();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future getDistance() async {
    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      this.center = LatLng(coords.latitude, coords.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation centres near you'),
        backgroundColor: Colors.green[700],
      ),
      body: SizedBox(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target:
                center != null ? center : const LatLng(51.497311, -0.179720),
            zoom: 11.0,
          ),
        ),
      ),
      floatingActionButton:
          Align(child: BottomSheetButton(), alignment: Alignment(1, 0.7)),
      bottomNavigationBar: NavBar(),
    );
  }
}
