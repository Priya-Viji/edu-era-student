import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Payment status
enum PaymentStatus { idle, creatingOrder, success, failure }

/// Payment state
class PaymentState {
  final PaymentStatus status;
  final String? error;
  final String? paymentId;
  final String? courseName;

  PaymentState({
    this.status = PaymentStatus.idle,
    this.error,
    this.paymentId,
    this.courseName,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? error,
    String? paymentId,
    String? courseName,
  }) {
    return PaymentState(
      status: status ?? this.status,
      error: error ?? this.error,
      paymentId: paymentId ?? this.paymentId,
      courseName: courseName ?? this.courseName,
    );
  }
}

/// Events
abstract class PaymentEvent {}

class PaymentInit extends PaymentEvent {}

class PaymentStartRequested extends PaymentEvent {
  final String key;
  final int amountInPaise;
  final String currency;
  final String receipt;
  final String name;
  final String description;
  final String prefillEmail;
  final String prefillContact;
  final Map<String, String> notes;

  PaymentStartRequested({
    required this.key,
    required this.amountInPaise,
    required this.currency,
    required this.receipt,
    required this.name,
    required this.description,
    required this.prefillEmail,
    required this.prefillContact,
    required this.notes,
  });
}

class PaymentSucceeded extends PaymentEvent {
  final String paymentId;
  final String courseName;

  PaymentSucceeded({required this.paymentId, required this.courseName});
}

class PaymentFailed extends PaymentEvent {
  final String error;

  PaymentFailed(this.error);
}

/// Bloc
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  late Razorpay _razorpay;

  PaymentBloc() : super(PaymentState()) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleWallet);

    // Init
    on<PaymentInit>((event, emit) {
      emit(PaymentState(status: PaymentStatus.idle));
    });

    // Start payment
    on<PaymentStartRequested>((event, emit) {
      emit(
        PaymentState(
          status: PaymentStatus.creatingOrder,
          courseName: event.notes['course'],
        ),
      );

      final options = {
        'key': event.key,
        'amount': event.amountInPaise,
        'currency': event.currency,
        'name': event.name,
        'description': event.description,
        'prefill': {
          'contact': event.prefillContact,
          'email': event.prefillEmail,
        },
        'notes': event.notes,
        'theme': {'color': '#43A047'},
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        emit(PaymentState(status: PaymentStatus.failure, error: e.toString()));
      }
    });

    // Success
    on<PaymentSucceeded>((event, emit) {
      emit(
        PaymentState(
          status: PaymentStatus.success,
          paymentId: event.paymentId,
          courseName: event.courseName,
        ),
      );
    });

    // Failure
    on<PaymentFailed>((event, emit) {
      emit(PaymentState(status: PaymentStatus.failure, error: event.error));
    });
  }

  void _handleSuccess(PaymentSuccessResponse res) {
    add(
      PaymentSucceeded(
        paymentId: res.paymentId!,
        courseName: state.courseName ?? '',
      ),
    );
  }

  void _handleError(PaymentFailureResponse res) {
    add(PaymentFailed(res.message ?? 'Payment failed'));
  }

  void _handleWallet(ExternalWalletResponse res) {
    // Optional: handle external wallet
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }
}
