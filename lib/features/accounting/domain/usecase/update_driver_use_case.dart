import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class UpdateDriverUseCase {
  final DriverRepository driverRepository;

  UpdateDriverUseCase({
    required this.driverRepository,
  });

  Future<void> call(Map<String, dynamic> updateMap) async {
    try {
      final response = await driverRepository.updateDriver(updateMap);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
