import 'package:taxi_line_driver/features/accounting/domain/repository/driver_repositor.dart';

class LoginDriverUseCase {
  final DriverRepository driverRepository;

  LoginDriverUseCase({
    required this.driverRepository,
  });

  call(String email, String password) async {
    try {
      final user =
          await driverRepository.loginUserWithEmailAndPassword(email, password);  
    } catch (error) {
      print(error);
      throw UnimplementedError();
    }
  }
}
