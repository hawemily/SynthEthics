import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:synthetics/components/navbar/navbar.dart';
import 'bottomsheet.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  GoogleMapController mapController;

  LatLng center;
  // List<LatLng> latlngs = new List(2);
  // List<Marker> markers = new List(3);
  /* For testing: changed to 2 from 5*/
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
        // this.latlngs[i] = LatLng(lat, lng);
        this.distances[i] = double.parse(d.toStringAsFixed(2));
      }

      //   for (var i = 0; i < 2; i++) {
      //     this.markers[i] = Marker(
      //         draggable: false, position: latlngs[i], markerId: MarkerId('$i'));
      //   }
      //   this.markers[2] = Marker(
      //       markerId: MarkerId('center'), draggable: false, position: center);
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
          // markers: Set.from(markers),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target:
                center != null ? center : const LatLng(51.497311, -0.179720),
            zoom: 11.0,
          ),
        ),
      ),
      floatingActionButton: Align(
          child: BottomSheetButton(
            names: names,
            addresses: addresses,
            distances: distances,
          ),
          alignment: Alignment(1, 0.7)),
      bottomNavigationBar: NavBar(),
    );
  }
}
