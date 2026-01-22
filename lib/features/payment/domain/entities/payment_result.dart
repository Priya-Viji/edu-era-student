
import 'package:equatable/equatable.dart';

class PaymentResult extends Equatable {
  final bool isSuccess;
  final String message;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final int? code;

  const PaymentResult({
    required this.isSuccess,
    required this.message,
    this.paymentId,
    this.orderId,
    this.signature,
    this.code,
  });

  factory PaymentResult.success({
    required String paymentId,
    required String orderId,
    required String signature,
  }) => PaymentResult(
    isSuccess: true,
    message: 'Payment Successful',
    paymentId: paymentId,
    orderId: orderId,
    signature: signature,
  );

  factory PaymentResult.failure({required int code, required String message}) =>
      PaymentResult(isSuccess: false, message: message, code: code);

  @override
  List<Object?> get props => [
    isSuccess,
    message,
    paymentId,
    orderId,
    signature,
    code,
  ];
}
