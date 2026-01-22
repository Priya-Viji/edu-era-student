
import 'package:dio/dio.dart';

class PaymentRemoteSource {
  final Dio _dio;
  PaymentRemoteSource(this._dio);

  Future<Map<String, dynamic>> createOrder({
    required int amountInPaise,
    required String currency,
    required String receipt,
  }) async {
    final resp = await _dio.post(
      '/payments/create-order',
      data: {'amount': amountInPaise, 'currency': currency, 'receipt': receipt},
    );
    return resp.data; // expect { id, amount, currency, status }
  }
}