
import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/geo_code_repository.dart';

class GeoCodingAddressToLatLngUseCase {
  final GeoCodingRepository geoCodingRepostory;

  GeoCodingAddressToLatLngUseCase({
    required this.geoCodingRepostory,
  });

  Future<List<Address>> call(String address) async {
    try{
      final latLng = await geoCodingRepostory.addressToLatLng(address);
      return latLng;
    }catch (error) {
      rethrow;
    }
  }

}
