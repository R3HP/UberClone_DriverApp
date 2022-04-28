import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class ToggleDriverOnlineUseCase {
  final DriverRepository driverRepository;

  ToggleDriverOnlineUseCase({
    required this.driverRepository,
  });

  Future<void> call(DriverModel driver, bool shouldMakeAvailable) async {
    try {
      final response = await driverRepository.toggleDriverAvailablityInDB(
          driver, shouldMakeAvailable);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
