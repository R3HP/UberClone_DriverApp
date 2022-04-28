import 'package:flutter/material.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';
import 'package:latlong2/latlong.dart';

class DriverAvailabilityContainer extends StatelessWidget {
  const DriverAvailabilityContainer({
    Key? key,
    required this.authController,
    required this.startPosition,
  }) : super(key: key);

  final AuthController authController;
  final LatLng startPosition;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 50,
      right: 50,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 20,
        shadowColor: Colors.black54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You Are Not Available Yet'),
            ElevatedButton(
                onPressed: () => authController
                    .makeDriverOnline(startPosition),
                child: const Text('Go Online'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10)))),
          ],
        ),
      ),
    );
  }
}
