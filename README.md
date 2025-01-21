# Chapa Flutter SDK

The official **Chapa Flutter SDK** enables Flutter developers to integrate Chapa's Payment API seamlessly into their applications. It supports both native and web checkout, providing a robust and flexible solution for initiating and validating payments.

---

## **Features**

- 🌟 **Initiate Payment:** Easily facilitate transactions via four supported wallets telebirr,cbebirr,mpesa and ebirr.
- ✅ **Validate Payment Status:** Confirm payment completion and notify users instantly.
- 🌐 **Web Checkout Support:** Enable users to use the web checkout for additional payment options.

---
## **Preview**

<div style="display: flex; justify-content: space-between; align-items: center;">
  <div style="text-align: center;">
    <p>Payment Methods in Grid View</p>
    <img src="https://chapa-bucket.s3.us-east-1.amazonaws.com/chapa-flutter-sdk-assets/doc/gridview.png" alt="Payment Methods in Grid View" style="width: 200px;" />
  </div>
  <div style="text-align: center;">
    <p>Payment Methods in List View with Customized Button Color</p>
    <img src="https://chapa-bucket.s3.us-east-1.amazonaws.com/chapa-flutter-sdk-assets/doc/listview.png" alt="Payment Methods in List View" style="width: 200px;" />
  </div>
  <div style="text-align: center;">
    <p>Error</p>
    <img src="https://chapa-bucket.s3.us-east-1.amazonaws.com/chapa-flutter-sdk-assets/doc/error.png" alt="Error" style="width: 200px;" />
  </div>
  <div style="text-align: center;">
    <p>Successful Payment Receipt</p>
    <img src="https://chapa-bucket.s3.us-east-1.amazonaws.com/chapa-flutter-sdk-assets/doc/success.png" alt="Successful Payment Receipt" style="width: 200px;" />

    
  </div>
</div>



## **Getting Started**

### **Installation**

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  chapasdk: ^latest_version
```

Then, run the command:  

```bash
flutter pub get
```

---

## **Parameters**

| Parameter                  | Type              | Required  | Description                                                                                                   |
|----------------------------|-------------------|-----------|---------------------------------------------------------------------------------------------------------------|
| `context`                 | `BuildContext`   | **Yes**   | Context of the current widget.                                                                                |
| `publicKey`               | `String`         | **Yes**   | Your Chapa public key (use test key for testing and live key for production).                                 |
| `currency`                | `String`         | **Yes**   | Transaction currency (ETB for native checkout, ETB or USD for web checkout NB=> You can not use USD for Naive checkout is it is only available for Web checkout.).                                  |
| `amount`                  | `String`         | **Yes**   | The amount to be charged.                                                                                     |
| `email`                   | `String`         | **Yes**   | Customer’s email address.                                                                                     |
| `phone`                   | `String`         | **Yes**   | Customer’s phone number.                                                                                      |
| `firstName`               | `String`         | **Yes**   | Customer’s first name.                                                                                        |
| `lastName`                | `String`         | **Yes**   | Customer’s last name.                                                                                         |
| `txRef`                   | `String`         | **Yes**   | Unique reference for the transaction.                                                                         |
| `title`                   | `String`         | **Yes**   | Title of the payment modal.                                                                                   |
| `desc`                    | `String`         | **Yes**   | Description of the payment.                                                                                   |
| `namedRouteFallBack`      | `String`         | **Yes**   | Named route to redirect users to after payment events (success, failure, or cancellation).                    |
| `nativeCheckout`          | `bool`           | No        | Whether to use native checkout (`true`) or web checkout (`false`). Default is `true`.                         |
| `showPaymentMethodsOnGridView` | `bool`       | No        | Display payment methods in grid (`true`) or horizontal view (`false`). Default is `true`.                     |
| `availablePaymentMethods` | `List<String>`   | No        | List of allowed payment methods (`mpesa`, `cbebirr`, `telebirr`, `ebirr`). Defaults to all methods.           |
| `buttonColor`             | `Color`          | No        | Button color for native checkout. Defaults to the app’s primary theme color.                                  |

---

## **Usage**

```dart
import 'package:chapasdk/chapasdk.dart';

Chapa.paymentParameters(
  context: context,
  publicKey: 'CHAPUBK-@@@@',
  currency: 'ETB',
  amount: '1',
  email: 'fetanchapa.co',
  phone: '0911223344',
  firstName: 'Israel',
  lastName: 'Goytom',
  txRef: 'txn_12345',
  title: 'Order Payment',
  desc: 'Payment for order #12345',
  nativeCheckout: true,
  namedRouteFallBack: '/',
  showPaymentMethodsOnGridView: true,
  availablePaymentMethods: ['mpesa', 'cbebirr', 'telebirr', 'ebirr'],
);
```

---

## **Payment Responses from**

### For Native Checkout:

Transaction Reference Number in Native Checkout context is Chapa's Reference number for the Payment.
```json
{
  "message": "Any Descriptive message regarding the payment status",
  "transactionReference": "CHHhvtn7xLEkZ", 
  "paidAmount": "1.00"
}
```

### For Web Checkout:

Transaction Reference Number in Web Checkout context is The transaction reference number you generated for the payment.

Important Note:
If the web checkout is initiated from the native checkout page, the Transaction Reference for the web checkout will be generated by the app itself. This is because a single transaction reference cannot be used for both native and web checkout processes. Therefore, the app will generate a separate transaction reference for the web checkout.

#### Payment Canceled:
```json
{
  "message": "paymentCancelled",
  "transactionReference": "txn_12345",
  "paidAmount": "1.00"
}
```
#### Payment Successful:
```json
{
  "message": "paymentSuccessful",
  "transactionReference": "txn_12345" ,
  "paidAmount": "1.00"
}
```
#### Payment Failed:
```json
{
  "message": "paymentFailed",
  "transactionReference": "txn_12345",
  "paidAmount": "0.00"
}
```

---

## **FAQ**

### **1. Is the fallback route mandatory?**
Yes, `namedRouteFallBack` is required to handle post-payment events such as success, failure, or cancellation.  

### **2. What currencies are supported?**
- Native Checkout: ONLY **ETB**  
- Web Checkout: **ETB**, **USD**  

---

## **Support**  

For any questions or issues:  
- **Email:** [info@chapa.co](mailto:infot@chapa.co)  
- **Call Center:** [+251960724272](tel:+251960724272)  
- **Short Code:**  [8911](tel:8911) 
- **Documentation:** [Chapa Developer Docs](https://developer.chapa.co/)  

Start building seamless payment experiences today with the **Chapa Flutter SDK**! 🚀
