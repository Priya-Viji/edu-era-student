// // presentation/bloc/payment_event.dart
// part of 'payment_bloc.dart';

// abstract class PaymentEvent extends Equatable {
//   const PaymentEvent();
//   @override
//   List<Object?> get props => [];
// }

// class PaymentInit extends PaymentEvent {
//   const PaymentInit();
// }

// class PaymentStartRequested extends PaymentEvent {
//   final String key;
//   final int amountInPaise;
//   final String currency;
//   final String receipt;
//   final String name;
//   final String description;
//   final String prefillEmail;
//   final String prefillContact;
//   final Map<String, Object?>? notes;

//   const PaymentStartRequested({
//     required this.key,
//     required this.amountInPaise,
//     required this.currency,
//     required this.receipt,
//     required this.name,
//     required this.description,
//     required this.prefillEmail,
//     required this.prefillContact,
//     this.notes,
//   });

//   @override
//   List<Object?> get props => [
//     key,
//     amountInPaise,
//     currency,
//     receipt,
//     name,
//     description,
//     prefillEmail,
//     prefillContact,
//     notes,
//   ];
// }

// class PaymentResultReceived extends PaymentEvent {
//   final PaymentResult result;
//   const PaymentResultReceived({required this.result});

//   @override
//   List<Object?> get props => [result];
// }
