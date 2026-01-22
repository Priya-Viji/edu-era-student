import 'package:eduera_student/features/payment/domain/entities/payment_result.dart';

abstract class PaymentRepository {
  Future<String> createOrder({
    required int amountInPaise,
    required String currency,
    required String receipt,
  });

  void setListeners({
    required void Function(PaymentResult) onSuccess,
    required void Function(PaymentResult) onError,
    required void Function(String) onExternalWallet,
  });

  void startCheckout({
    required String key,
    required String orderId,
    required int amountInPaise,
    required String name,
    required String description,
    required String prefillEmail,
    required String prefillContact,
    Map<String, Object?>? notes,
  });

  void dispose();
}
