import 'package:taxi_line_driver/core/error.dart';
import 'package:taxi_line_driver/features/cabing/data/datasource/geo_code_data_source.dart';
import 'package:taxi_line_driver/features/cabing/data/model/address.dart';
import 'package:taxi_line_driver/features/cabing/domain/repository/geo_code_repository.dart';

class GeoCodingRepositoryImpl implements GeoCodingRepository {
  final GeoCodingDataSource dataSource;

  GeoCodingRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<Address>> addressToLatLng(String address) async {
    try{
      final addresses = await dataSource.geoCodeAddressToLatLng(address);
      return addresses;
    }catch (exception){
      throw Error(message: exception.toString());
    }
  }

  @override
  Future<Address> latLngToAddress(double latitude, double longitude) async {
    try {
      final address = await dataSource.geoCodeLatLngToAddress(latitude, longitude);
      return address;
    } catch (exception){
      throw Error(message: exception.toString());
    }
  }

}
