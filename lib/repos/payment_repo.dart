import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:maanecommerceui/repos/const.dart';

String paymentIntent = "https://api.stripe.com/v1/payment_intents";

Map<String, dynamic>? paymentIntentData;

makePaymentRepo({required String amount, required String currency}) async {
  try {
    paymentIntentData =
        await createPaymentIntent(amount: amount, currency: currency);
    if (paymentIntentData != null) {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          billingDetails: const BillingDetails(
            name: "Mansur Nadim",
          ),
          merchantDisplayName: "Mansur Nadim",
          customerId: paymentIntentData!["customer"],
          paymentIntentClientSecret: paymentIntentData![secKey],
        ),
      );
      displayPaymentSheet();
    }
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}

createPaymentIntent({required String amount, required String currency}) async {
  try {
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,
      'payment_method_types[]': 'card',
    };
    var response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: body,
      headers: {
        "Authorization": "Bearer $secKey",
        "Content-Type": "application/x-www-form-urlencoded"
      },
    );
    return jsonDecode(response.body);
  } catch (e) {
    EasyLoading.showError(
        "CONNECT YOUR INTERNET CONNECTION..\n exception error charging user $e");
  }
}

displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();
  } catch (e) {
    EasyLoading.showError(e.toString());
  }
}
