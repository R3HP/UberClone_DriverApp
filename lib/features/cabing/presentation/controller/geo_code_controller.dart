import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/geo_code_address_to_latlng.dart';
import 'package:taxi_line_driver/features/cabing/domain/usecase/geo_code_latlng_to_address.dart';

class GeoCodeController {
  double? pointLatitude;
  double? pointLongitude;
  final GeoCodingAddressToLatLngUseCase _addressToLatLngUseCase;
  final GeoCodingLatLngToAddressUseCase _latLngToAddressUseCase;

  GeoCodeController({
    required GeoCodingAddressToLatLngUseCase addressToLatLngUseCase,
    required GeoCodingLatLngToAddressUseCase latLngToAddressUseCase,
  })  : _addressToLatLngUseCase = addressToLatLngUseCase,
        _latLngToAddressUseCase = latLngToAddressUseCase;

  Future<List<Address>> geoCodeAddressToLatLng(String addressText) async {
    final addresses = await _addressToLatLngUseCase(addressText);
    return addresses;
  }

  Future<Address> geoCodeLatnLngToAddress(
      double latitude, double longitude) async {
    final address = await _latLngToAddressUseCase(latitude, longitude);
    return address;
  }
}
