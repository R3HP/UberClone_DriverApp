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
      final response = await dataSource.geoCodeAddressToLatLng(address);
      return response;
    }catch(error){
      throw UnimplementedError();
    }
  }

  @override
  Future<Address> latLngToAddress(double latitude, double longitude) async {
    try {
      final response = await dataSource.geoCodeLatLngToAddress(latitude, longitude);
      return response;
    } catch (error) {
      throw UnimplementedError();
    }
  }

}
