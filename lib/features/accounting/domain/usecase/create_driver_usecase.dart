import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class CreateDriverUseCase {
  final DriverRepository driverRepository;

  CreateDriverUseCase({
    required this.driverRepository,
  });

  Future<DriverModel> call(String userName, String email, String password,
      String carModel, String plateNumber) async {
    try {
      final driver = await driverRepository.createUserWithEmailAndPassword(
          userName, email, password, carModel, plateNumber);
      return driver;
    } catch (error) {
      rethrow;
    }
  }
}
