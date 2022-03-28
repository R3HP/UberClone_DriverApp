import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class ChangeDriverLocationUseCase {
  final DriverRepository driverRepository;

  ChangeDriverLocationUseCase({
    required this.driverRepository,
  });

  Future<void> call(double latitude,double longitude) async {
    return await driverRepository.changeDriverLocationInDB(latitude, longitude);
  }
}
