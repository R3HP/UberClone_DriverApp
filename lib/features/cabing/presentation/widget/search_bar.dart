import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
import 'package:taxi_line_driver/features/cabing/presentation/controller/geo_code_controller.dart';

class SearchBar extends StatefulWidget {
  final MapController mapController;

  const SearchBar({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final focus = FocusNode();
  final myController = TextEditingController();
  final GeoCodeController geoController = sl();


  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 20,
        left: 50,
        right: 48,
        child: AnimatedContainer(
          duration: const Duration(microseconds: 100),
          width: focus.hasFocus ? 200 : 150,
          curve: Curves.ease,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(focus.hasFocus ? 15.0 : 10.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Colors.black,offset: Offset(2, 2),spreadRadius: 0.0,blurRadius: 3.0,blurStyle: BlurStyle.outer)
            ]
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focus,
                  controller: myController,
                  decoration: InputDecoration(
                    label: Row(children: const [Icon(Icons.search),Text('Search')]),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    constraints: const BoxConstraints(maxHeight: 50)
                  ),
                ),
              ),
              if(focus.hasFocus)
              IconButton(
                  onPressed: () async {
                    final addresses = await geoController.geoCodeAddressToLatLng(myController.text);
                    focus.unfocus();
                    showSearchAddressesDialog(context, addresses,widget.mapController);
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ))
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(() { });
    focus.dispose();
    myController.dispose();
  }

  Future<dynamic> showSearchAddressesDialog(BuildContext context, List<Address> addresses,MapController mapController) {
    return showDialog(
                  context: context,
                  builder: (ctx) => Dialog(
                        alignment: Alignment.center,
                        elevation: 16,
                        child: ListView.builder(
                          itemCount: addresses.length,
                          itemBuilder: (ctx, index) => ListTile(
                            title: Text(
                              addresses[index].placeAddress,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              
                              mapController.move(LatLng(addresses[index].latitude,addresses[index].longitude) , 18.4);
                            },
                          ),
                        ),
                      ));

  }
}
