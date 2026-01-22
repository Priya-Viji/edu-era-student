
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();

 void init() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }
 void _onPaymentSuccess(PaymentSuccessResponse res) {
    // verify payment on server using res.paymentId + orderId
  }

  void _onPaymentError(PaymentFailureResponse res) {
    // show toast/snackbar + log error
  }

  void _onExternalWallet(ExternalWalletResponse res) {
    // handle wallet flow if needed
  }

}
