// domain/usecases/create_order_usecase.dart
import '../repositories/payment_repository.dart';

class CreateOrderUseCase {
  final PaymentRepository repo;
  CreateOrderUseCase(this.repo);

  Future<String> call({
    required int amountInPaise,
    required String currency,
    required String receipt,
  }) {
    return repo.createOrder(
      amountInPaise: amountInPaise,
      currency: currency,
      receipt: receipt,
    );
  }
}
