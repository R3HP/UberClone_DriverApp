import 'package:taxi_line_driver/features/accounting/data/model/driver_model.dart';
import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class LoginDriverUseCase {
  final DriverRepository driverRepository;

  LoginDriverUseCase({
    required this.driverRepository,
  });

  Future<DriverModel> call(String email, String password) async {
    try {
        final driver = await driverRepository.loginUserWithEmailAndPassword(email, password);  
        return driver;
    } catch (error) {
      rethrow;
    }
  }
}
