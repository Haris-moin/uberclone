import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

class RazorPayment extends StatefulWidget {
  final String Contact,Email;

  const RazorPayment({Key key, this.Contact, this.Email}) : super(key: key);
  @override
  _RazorPaymentState createState() => _RazorPaymentState();
}

class _RazorPaymentState extends State<RazorPayment> {
  int totalamount = 0;
  Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    String num = widget.Contact.toString();
    String email = widget.Email.toString();
    var options = {
      'key': 'rzp_test_Pk47p9DLmZjmFj',
      'amount': int.parse(amountController.text) * 100,
      'name': 'Karachi Cab',
      'description': 'Test payments',
      'prefill': {'contact': '${'+92' + num}', 'email': '$email'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: 'Success' + response.paymentId);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Error' + response.code.toString() + "." + response.message);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: 'External Wallet' + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Payment Mode',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              cursorColor: Colors.black,
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Container(
                  margin: EdgeInsets.only(left: 20, top: 5, bottom: 16),
                  width: 10,
                  height: 10,
                ),
                hintText: "Amount",
                contentPadding:
                EdgeInsets.only(left: 15.0, top: 16.0, bottom: 15),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              color: Colors.yellow,
              onPressed: () {
                openCheckout();
              },
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
