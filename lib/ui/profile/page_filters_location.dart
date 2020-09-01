import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PageFiltersLocation extends StatefulWidget {
  @override
  _PageFiltersLocationState createState() => _PageFiltersLocationState();
}

class _PageFiltersLocationState extends State<PageFiltersLocation> {
  LatLng SOURCE_LOCATION = LatLng(65.9667, -19.5333);
  double ZOOM = 14.0;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();

  _handleTap(LatLng point) async {
      GoogleMapController gcontrol = await _controller.future;
      gcontrol.animateCamera(CameraUpdate.newLatLngZoom(point, 12.0));
      String genId = DateTime.now().millisecondsSinceEpoch.toString();
      MarkerId markerId = MarkerId(genId);
      Marker marker = Marker(
        markerId: markerId,
        position: point

      );


      setState(() {
        _markers.clear();
        _markers[markerId] = marker;
      });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: TextField(
              style: TextStyle(
                fontSize: 18.0
              ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search,color: Colors.grey,),
            prefixText: "Moscow, Russia",
        contentPadding: EdgeInsets.fromLTRB(5, 10, 5, 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:Colors.grey,
                width: 2.0,
                 
            ),
              borderRadius: BorderRadius.circular(25)
              
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:Colors.grey,
                  width: 2.0,

                ),
                borderRadius: BorderRadius.circular(25)

            ),
          ),

        )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
      ),
      body:  Stack(
          children: <Widget>[

            Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap
              (
              onTap: _handleTap,
              initialCameraPosition: CameraPosition(target: SOURCE_LOCATION),
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: MapType.hybrid,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(_markers.values),
            ),
          )]
          )

    );


  }
}
