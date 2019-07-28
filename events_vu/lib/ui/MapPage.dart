import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:events_vu/secrets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:events_vu/logic/Events.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  LatLng eventLocation;
  final String location;
  final Event event;

  MapPage(
      {Key key,
      this.latitude,
      this.longitude,
      @required this.location,
      @required this.event})
      : eventLocation = latitude != null && longitude != null
            ? LatLng(latitude, longitude)
            : null,
        super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  final List<String> options = ['Add Marker', 'Is this correct?'];

  @override
  void initState() {
    super.initState();
    print('init state');
  }

//  void _initMap(context) {
//    List<Marker> markers = [];
//    if (widget.latitude != null && widget.longitude != null)
//      markers
//          .add(Marker('1', widget.location, widget.latitude, widget.longitude));
//
//    widget._mapView
//      ..onToolbarAction.listen((id) {
//        if (id == 1) // exit
//          _handleExit(context);
//        else if (id == 2) _addMarker();
//      })
//      ..onMapReady.listen((_) {
//        if (markers.length > 0) widget._mapView.addMarker(markers[0]);
//      });
//
//    print('${widget.latitude}, ${widget.longitude}');
//    _createStaticMap(context, markers, widget.latitude ?? 36.145844,
//        widget.longitude ?? -86.801838);
//  }
//
//  void _createStaticMap(context, List<Marker> markers, latitude, longitude) {
//    print('++++++++++++++++++++++++++++++++++\nHERE');
//    setState(() {
//      String staticMapStr = widget._staticMapProvider
//          .getStaticUriWithMarkersAndZoom(
//            markers,
//            center: Location(latitude, longitude),
//            height: MediaQuery.of(context).size.height.toInt(),
//            zoomLevel: 15,
//          )
//          .toString();
//
//      staticMapStr +=
//          '&signature=${base64UrlEncode(Hmac(sha1, base64Url.decode(SIGNING_SECRET)).convert(utf8.encode(staticMapStr.replaceAll(RegExp(r'https://maps.googleapis.com'), ''))).bytes)}';
//      mapImage = Image.network(staticMapStr);
//    });
//  }
//
//  void _addMarker() async {
//    if (widget._mapView.markers.length > 0) return;
//
//    Location currentLocation = await widget._mapView.centerLocation;
//
//    widget._mapView.addMarker(Marker('1', widget.location,
//        currentLocation.latitude, currentLocation.longitude,
//        draggable: true));
//
////    widget.event.latitude = currentLocation.latitude;
////    widget.event.longitude = currentLocation.longitude;
//
//    widget._mapView.onAnnotationDragEnd
//        .listen((Map<Marker, Location> markerMap) {
//      Marker marker = markerMap.keys.first;
//      Location l = markerMap[
//          marker]; // The actual position of the marker after finishing the dragging.
//      setState(() {
////        widget.event.latitude = l.latitude;
////        widget.event.longitude = l.longitude;
//      });
//      _createStaticMap(
//          context,
//          [Marker('1', widget.location, l.latitude, l.longitude)],
//          l.latitude,
//          l.longitude);
//      print("Annotation ${marker.id} dragging ended at ${l.toString()}");
//    });
//
//    // TODO: cache the current map and update event lat/long
//  }

//  void _showMap() {
//    List<ToolbarAction> actions = [];
//    if (widget.latitude == null || widget.longitude == null)
//      actions.add(ToolbarAction('Add Marker', 2));
//
//    actions.add(ToolbarAction('Close', 1));
//
//    widget._mapView.show(
//        MapOptions(
//          showCompassButton: true,
//          showMyLocationButton: true,
//          showUserLocation: true,
//          initialCameraPosition: CameraPosition(
//              Location(
//                  widget.latitude ?? 36.145844, widget.longitude ?? -86.801838),
//              16.0),
//          title: widget.location,
//        ),
//        toolbarActions: actions);
//  }

  Widget _bottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: 0.7,
          child: FlatButton(
            child: Text('Button'),
            onPressed: () => {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    _initMap(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (val) {
              switch (val) {
                case 0: // options[0]
                  break;
                case 1: // options[1]
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) => options
                .asMap()
                .map((int idx, String val) => MapEntry(
                    idx,
                    PopupMenuItem(
                      value: idx,
                      child: Text(val),
                    )))
                .values
                .toList(),
          ),
        ],
      ),
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: widget.eventLocation ?? LatLng(36.145844, -86.801838),
              zoom: 18),
          myLocationEnabled: true,
          trackCameraPosition: true,
          onMapCreated: _onMapCreated,
        ),
//        ListView(
//          primary: false,
//          children: <Widget>[
//        widget.eventLocation != null
//            ? Text('Tap the map to view')
//            : Text('No location. Tap map to place marker.'),
//          ],
//        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (widget.eventLocation != null)
      controller.addMarker(MarkerOptions(
          infoWindowText: InfoWindowText(widget.location,
              'This is where the ${widget.event.name} will be held.'),
          position: widget.eventLocation));
    setState(() {
      mapController = controller;
    });
  }
}
