// // presentation/bloc/payment_state.dart
// part of 'payment_bloc.dart';

// enum PaymentStatus { initial, creatingOrder, openingCheckout, success, failure }

// class PaymentState extends Equatable {
//   final PaymentStatus status;
//   final String? orderId;
//   final String? error;
//   final PaymentResult? paymentResult;

//   const PaymentState({
//     required this.status,
//     this.orderId,
//     this.error,
//     this.paymentResult,
//   });

//   const PaymentState.initial() : this(status: PaymentStatus.initial);

//   PaymentState copyWith({
//     PaymentStatus? status,
//     String? orderId,
//     String? error,
//     PaymentResult? paymentResult,
//   }) {
//     return PaymentState(
//       status: status ?? this.status,
//       orderId: orderId ?? this.orderId,
//       error: error,
//       paymentResult: paymentResult ?? this.paymentResult,
//     );
//   }

//   @override
//   List<Object?> get props => [status, orderId, error, paymentResult];
// }
