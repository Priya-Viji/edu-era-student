// domain/usecases/start_payment_usecase.dart
import '../repositories/payment_repository.dart';

class StartPaymentUseCase {
  final PaymentRepository repo;
  StartPaymentUseCase(this.repo);

  void call({
    required String key,
    required String orderId,
    required int amountInPaise,
    required String name,
    required String description,
    required String prefillEmail,
    required String prefillContact,
    Map<String, Object?>? notes,
  }) {
    repo.startCheckout(
      key: key,
      orderId: orderId,
      amountInPaise: amountInPaise,
      name: name,
      description: description,
      prefillEmail: prefillEmail,
      prefillContact: prefillContact,
      notes: notes,
    );
  }
}
