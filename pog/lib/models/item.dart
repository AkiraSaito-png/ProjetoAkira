//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pog/request/google_maps_requests.dart';
import '../utils/cores.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pog/state/app_state.dart';

class PaginaInicial extends StatefulWidget {
  PaginaInicial({Key key, this.title}) : super(key: key);

  final String title;
  static final tag = 'about_page';

  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController controleLocal = TextEditingController();
  TextEditingController controleDestino = TextEditingController();
  static LatLng _posicaoInicial;
  LatLng _posicaoFinal = _posicaoInicial;
  final Set<Marker> _marcador = {};
  final Set<Polyline> _polyLines = {};

  @override
  void initState() {
    super.initState();
    _getLocalizacoaUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(-21.15, -47.82), zoom: 17.0),
          onMapCreated: onCreated,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          onCameraMove: _onCameraMove,
        ),

        Positioned(
          top: 50.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              // controller: locationController,
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                ),
                hintText: "Sua Localização",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
            ),
          ),
        ),

        Positioned(
          top: 105.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20, top: 5),
                  width: 10,
                  height: 10,
                  child: Icon(
                    Icons.local_taxi,
                    color: Colors.black,
                  ),
                ),
                hintText: "Seu Destino?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
            ),
          ),
        ),

        // Positioned(
        //   top: 40,
        //   right: 10,
        //   child: FloatingActionButton(
        //     onPressed: _addMarcador,
        //     tooltip: "colocar marcador",
        //     backgroundColor: azulEscuro,
        //     child: Icon(
        //       Icons.add_location,
        //       color: branco,
        //     ),
        //   ),
        // )
      ],
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _posicaoFinal = position.target;
    });
  }

  void _addMarcador() {
    setState(() {
      _marcador.add(Marker(
          markerId: MarkerId(_posicaoFinal.toString()),
          position: _posicaoFinal,
          infoWindow:
              InfoWindow(title: "lembre daqui", snippet: "boa Localização"),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  List decodePoly(String poly) {
    var lista = poly.codeUnits;
    var lLista = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do {
      var shift = 0;
      int result = 0;

      do {
        c = lista[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }

      var result1 = (result >> 1) * 0.00001;
      lLista.add(result1);
    } while (index < len);

    for (var i = 2; i < lLista.length; i++) {
      lLista[i] += lLista[i - 2];
    }

    print(lLista.toString());

    return lLista;
  }

  void _getLocalizacoaUsuario() async {
    Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
