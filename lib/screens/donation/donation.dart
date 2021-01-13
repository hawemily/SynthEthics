import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'package:synthetics/theme/custom_colours.dart';
import 'bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

/// Donation Map to show users the clothing donation centres nearest to them
class _DonationPageState extends State<DonationPage> {
  GoogleMapController mapController;

  LatLng center;
  List<LatLng> latlngs = new List(2);
  var markers = new List<Marker>();

  var names = new List(2);
  var addresses = new List(2);
  var distances = new List(2);

  @override
  void initState() {
    super.initState();
    this.getDistance();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  /// Uses Flutter's Geolocater package to retrieve the user's location.
  /// Finds nearest clothing donation centres using Google Maps Places API call
  Future getDistance() async {
    Position coords = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var str =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" +
            coords.latitude.toString() +
            "," +
            coords.longitude.toString() +
            "&rankby=distance&type=establishment&keyword=clothes+donation&key=AIzaSyAjd1nv48FAp72dRwalhcQWRAJ7oikwU2E";
    http.Response response = await http.get(str);
    var results = jsonDecode(response.body);

    // Saves fields of each entry retrieved by the API call
    setState(() {
      this.center = LatLng(coords.latitude, coords.longitude);
      for (var i = 0; i < 2; i++) {
        this.names[i] = results['results'][i]['name'];
        this.addresses[i] = results['results'][i]['vicinity'];
        double lat = results['results'][i]['geometry']['location']['lat'];
        double lng = results['results'][i]['geometry']['location']['lng'];
        double d = Geolocator.distanceBetween(
            center.latitude, center.longitude, lat, lng);
        d = d / 1000;
        this.latlngs[i] = LatLng(lat, lng);
        this.distances[i] = double.parse(d.toStringAsFixed(2));
      }
      for (var i = 0; i < 2; i++) {
        this.markers.add(Marker(
            draggable: false, position: latlngs[i], markerId: MarkerId('$i')));
      }

      // Builds markers for each donation center
      this.markers.add(Marker(
          markerId: MarkerId('center'),
          draggable: false,
          position: center,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation centres near you',
            style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: CustomColours.greenNavy(),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        markers: Set.of(markers),
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center != null ? center : const LatLng(51.497311, -0.179720),
          zoom: 14.0,
        ),
      ),
      floatingActionButton: Align(
          child: BottomSheetButton(
            names: names,
            addresses: addresses,
            distances: distances,
          ),
          alignment: Alignment(1, 0.7)),
      bottomNavigationBar: NavBar(selected: 4),
    );
  }
}
