
import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/geo_code_address_to_latlng.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/geo_code_latlng_to_address.dart';

class GeoCodeController {
  double? pointLatitude;
  double? pointLongitude;
  final GeoCodingAddressToLatLngUseCase addressToLatLngUseCase;
  final GeoCodingLatLngToAddressUseCase latLngToAddressUseCase;

  GeoCodeController({
    required this.addressToLatLngUseCase,
    required this.latLngToAddressUseCase,
  });

  Future<List<Address>> geoCodeAddressToLatLng(String addressText) async {
    return await addressToLatLngUseCase(addressText);
  }


  Future<Address> geoCodeLatnLngToAddress(double latitude,double longitude) async {
    return await latLngToAddressUseCase(latitude,longitude);
  }

}
