// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:taxi_line_driver/core/service_locator.dart';
// import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
// import 'package:taxi_line_driver/features/cabing/presentation/controller/geo_code_controller.dart';

// // final cabControllerProvider = ChangeNotifierProvider.autoDispose<CabController>((ref) => CabController(),);

// class SearchBar extends ConsumerWidget {
//   // final FocusNode searchTextFieldFocusNode;
//   final GeoCodeController geoController = sl();

//   final searchTextFieldFocusNode = FocusNode();

//   SearchBar({
//     Key? key,
//     // required this.searchTextFieldFocusNode,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context,WidgetRef ref) {
//     final searchTextFieldController = TextEditingController();
//     final Size size = MediaQuery.of(context).size;
//     return AnimatedPadding(
//       duration: const Duration(milliseconds: 20),
//       curve: Curves.ease,
//       padding: EdgeInsets.only(
//           top: 35.0,
//           left: searchTextFieldFocusNode.hasFocus
//               ? size.width / 12
//               : size.width / 6.8,
//           right: searchTextFieldFocusNode.hasFocus ? size.width / 13 : 0),
//       child: Card(
//         elevation: 12,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               focusNode: searchTextFieldFocusNode,
//               controller: searchTextFieldController,
//               textInputAction: TextInputAction.done,
//               onSubmitted: (value) async {
//                 final addresses =
//                     await geoController.geoCodeAddressToLatLng(value);
//                 showSearchAddressesDialog(context, addresses,ref);
//               },
//               decoration: InputDecoration(
//                 fillColor: Colors.white,
//                 filled: true,
//                 label:
//                     Row(children: const [Icon(Icons.search), Text('Search')]),
//                 floatingLabelBehavior: FloatingLabelBehavior.never,
//                 constraints:
//                     BoxConstraints(maxHeight: 50, maxWidth: size.width * 0.7),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none),
//               ),
//             ),
            
//             if (searchTextFieldFocusNode.hasFocus)
//               IconButton(
//                 onPressed: () async {
//                   final addresses = await geoController
//                       .geoCodeAddressToLatLng(searchTextFieldController.text);
//                   // newMethod(context, addresses);
//                   showSearchAddressesDialog(context, addresses,ref);
//                 },
//                 icon: const Icon(
//                   Icons.check_circle,
//                   color: Colors.green,
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }

  
// }

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
    
    print('new widget build');
    return Positioned(
        top: 20,
        left: 50,
        right: 50,
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
                              
                              // if (geoController.pointLatitude == null) {
                              //   ref.read(cabControllerProvider).startTripAddress= addresses[index];
                              //   // geoController.pointLatitude =
                              //   //     addresses[index].latitude;
                              //   // geoController.pointLongitude =
                              //   //     addresses[index].longitude;
                              //   // startTextFieldController.text =
                              //   //     addresses[index].placeText;
                              // } else {
                              //   ref.read(cabControllerProvider).finishTripAddress = addresses[index];
                              //   // geoController.pointLatitude =
                              //   //     addresses[index].latitude;
                              //   // geoController.pointLongitude =
                              //   //     addresses[index].longitude;
                              //   // finishTextFieldController.text =
                              //   //     addresses[index].placeText;
                              // }
                              // // location and text controller should be set Here
                              // // a way of finding if its starting poin or finishing point
                            },
                          ),
                        ),
                      ));

  }
}
