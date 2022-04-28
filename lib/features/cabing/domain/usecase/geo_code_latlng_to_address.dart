
import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/geo_code_repository.dart';

class GeoCodingLatLngToAddressUseCase {
  final GeoCodingRepository geoCodingRepository;

  GeoCodingLatLngToAddressUseCase({
    required this.geoCodingRepository,
  });


  Future<Address> call(double latitude,double longitude) async {
    try{
      final address = await geoCodingRepository.latLngToAddress(latitude, longitude);
      return address;
    }catch (error) {
      rethrow;
    }
  }
}
