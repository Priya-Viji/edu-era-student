// import 'package:eduera_student/features/payment/data/services/razorpay_service.dart';
// import 'package:eduera_student/features/payment/domain/entities/payment_result.dart';
// import 'package:eduera_student/features/payment/domain/repositories/payment_repository.dart';

// class PaymentRepositoryImpl implements PaymentRepository {
//  // final PaymentRemoteSource remote;
//   final RazorpayService service;
//   PaymentRepositoryImpl({required this.service});
// final String dummyOrderId = 'order_Dummy123456';

//   @override
//   Future<String> createOrder({
//     required int amountInPaise,
//     required String currency,
//     required String receipt,
//   }) async {
//     // final data = await remote.createOrder(
//     //   amountInPaise: amountInPaise,
//     //   currency: currency,
//     //   receipt: receipt,
//     // );
//     // return data['id'] as String;
//         return "order_Dummy123456";
//   }

//   @override
//   void setListeners({
//     required void Function(PaymentResult) onSuccess,
//     required void Function(PaymentResult) onError,
//     required void Function(String) onExternalWallet,
//   }) {
//     service.setListeners(
//       onSuccess: (r) => onSuccess(PaymentResult.success(
//         paymentId: r.paymentId ?? '',
//         orderId: r.orderId ?? '',
//         signature: r.signature ?? '',
//       )),
//       onError: (e) => onError(PaymentResult.failure(
//         code: e.code ?? 0,
//         message: e.message ?? '',
//       )),
//       onExternalWallet: (w) => onExternalWallet(w.walletName ?? 'wallet'),
//     );
//   }

//   @override
//   void startCheckout({
//     required String key,
//     required String orderId,
//     required int amountInPaise,
//     required String name,
//     required String description,
//     required String prefillEmail,
//     required String prefillContact,
//     Map<String, Object?>? notes,
//   }) {
//     final options = {
//       'key': key,
//       'order_id': dummyOrderId,
//       'amount': amountInPaise, // in paise
//       'currency': 'INR',
//       'name': name,
//       'description': description,
//       'prefill': {
//         'email': prefillEmail,
//         'contact': prefillContact,
//       },
//       'notes': notes ?? {},
//       'retry': {'enabled': true, 'max_count': 1},
//       'theme': {'color': '#3399cc'},
//     };
//     service.openCheckout(options);
//   }

//   @override
//   void dispose() => service.clear();
// }
