import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class MakeDriverOnlineUseCase {
  final DriverRepository driverRepository;

  MakeDriverOnlineUseCase({
    required this.driverRepository,
  });

  Future<void>call(DriverModel driver) async {
    return await driverRepository.makeDriverAvailableInDB(driver);
  }
}
