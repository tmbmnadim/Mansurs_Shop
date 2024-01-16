import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'const.dart';

class MakePayment {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePaymentRepo({
    required String amount,
    required String currency,
  }) async {
    try {
      // paymentIntentData =
      //     await createPaymentIntent(amount: amount, currency: currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: const BillingDetails(
                name: "",
                address: Address(
                    city: "",
                    country: "",
                    line1: "",
                    line2: "",
                    postalCode: "",
                    state: ""),
                email: "",
                phone: ""),
            billingDetailsCollectionConfiguration:
                const BillingDetailsCollectionConfiguration(
              phone: CollectionMode.always,
              attachDefaultsToPaymentMethod: true,
            ),
            merchantDisplayName: "Prospects",
            customerId: paymentIntentData!["customer"],
            paymentIntentClientSecret: paymentIntentData!["client_secret"],
            customerEphemeralKeySecret: paymentIntentData!["ephemeralKey"],
          ),
        );
      }
      // return paymentIntentData;
    } catch (e /*, s*/) {
      // print("exception:$e$s");
    }
    // return null;
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      {required String amount, required String currency}) async {
    try {
      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: {
          "amount": amount,
          "currency": currency,
          'payment_method_types[]': 'card',
          // "automatic_payment_methods[enabled]":"true",
        },
        headers: {
          "Authorization": "Bearer $secKey",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );
      debugPrint("FROM PAYMENT REPO: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      // print("error charging user$e");
      EasyLoading.showError(
          "Please Check Your Internet Connection...\nError charging user $e");
    }
    return null;
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      EasyLoading.showSuccess("Payment Successful");
    } on Exception catch (e) {
      if (e is StripeException) {
        // print('error from stripe: ${e.error.localizedMessage}');
      } else {
        // print("unforced error: $e");
        EasyLoading.showError("Cancelled");
      }
    } catch (e) {
      // print("exception" + e.toString());
    }
  }
}
