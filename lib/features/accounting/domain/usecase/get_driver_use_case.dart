import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class GetDriverFromDataBaseUseCase {
  final DriverRepository driverRepository;

  GetDriverFromDataBaseUseCase({
    required this.driverRepository,
  });

  Future<DriverModel> call(String driverId) {
    try {
      final driver = driverRepository.getDriverFromWithDriverId(driverId);
      return driver;
    } catch (error) {
      rethrow;
    }
  }
}
