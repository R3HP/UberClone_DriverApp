import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class UpdateDriverUseCase {
  final DriverRepository driverRepository;

  UpdateDriverUseCase({
    required this.driverRepository,
  });

  call(Map<String,dynamic> updateMap) async {
    final response = await driverRepository.updateDriver(updateMap);
    return ;
  }

}
