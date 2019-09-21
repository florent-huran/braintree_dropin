import Flutter
import UIKit
import BraintreeDropIn
import Braintree
import PassKit

public class SwiftBraintreeDropinPlugin: NSObject, FlutterPlugin, PKPaymentAuthorizationViewControllerDelegate {
    
    var clientToken: String?
    var _flutterResult: FlutterResult?
    var merchantName: String?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "braintree_dropin", binaryMessenger: registrar.messenger())
        let instance = SwiftBraintreeDropinPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //result("iOS " + UIDevice.current.systemVersion)
        if call.method == "showDropIn" {
            let arguments = call.arguments as? NSDictionary
            let _token = arguments?["clientToken"] as? String
            let _amount = arguments?["amount"] as? String
            let _email = arguments?["clientEmail"] as? String
            let _merchantName = arguments?["merchantName"] as? String
            guard let token = _token, let amount = _amount, let email = _email, let merchantName = _merchantName else {
                result(nil)
                return
            }
            _flutterResult = result;
            clientToken = token
            self.merchantName = merchantName
            showDropIn(clientTokenOrTokenizationKey: token, amount: amount, email: email, withResult: result)
        } else {
            result(FlutterMethodNotImplemented);
        }
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String, amount: String, email: String, withResult flutterResult: @escaping FlutterResult) {
        let request = BTDropInRequest()
        request.threeDSecureVerification = true
        
        let threeDSecureRequest = BTThreeDSecureRequest()
        threeDSecureRequest.amount = NSDecimalNumber(string: amount)
        threeDSecureRequest.email = email
        threeDSecureRequest.versionRequested = .version2
        
        /*let address = BTThreeDSecurePostalAddress()
         address.givenName = "Jill" // ASCII-printable characters required, else will throw a validation error
         address.surname = "Doe" // ASCII-printable characters required, else will throw a validation error
         address.phoneNumber = "5551234567"
         address.streetAddress = "555 Smith St"
         address.extendedAddress = "#2"
         address.locality = "Chicago"
         address.region = "IL"
         address.postalCode = "12345"
         address.countryCodeAlpha2 = "US"
         threeDSecureRequest.billingAddress = address
         
         // Optional additional information.
         // For best results, provide as many of these elements as possible.
         let info = BTThreeDSecureAdditionalInformation()
         info.shippingAddress = address
         threeDSecureRequest.additionalInformation = info*/
        
        // TODO handle gestion of additionnal informations in order to improve 3D secure
        
        let dropInRequest = BTDropInRequest()
        dropInRequest.threeDSecureVerification = true
        dropInRequest.threeDSecureRequest = threeDSecureRequest
        
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: dropInRequest) { (controller, result, error) in
            if (error != nil) {
                flutterResult("error")
            } else if (result?.isCancelled == true) {
                flutterResult("cancelled")
            } else if result?.paymentOptionType == .applePay {
                self.setupPaymentRequest(amount: amount, clientToken: clientTokenOrTokenizationKey, completion: { (paymentRequest, error) in
                    if let error = error {
                        flutterResult(error)
                    } else if let paymentRequest = paymentRequest {
                        let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)!
                        vc.delegate = self
                        UIApplication.shared.keyWindow!.rootViewController!.present(vc, animated: true, completion: nil)
                    } else {
                        flutterResult("error")
                    }
                })
            } else if let result = result {
                flutterResult(result.paymentMethod!.nonce);
            }
            controller.dismiss(animated: true, completion: nil)
        }
        UIApplication.shared.keyWindow!.rootViewController!.present(dropIn!, animated: true, completion: nil)
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        let braintreeClient = BTAPIClient(authorization: clientToken!)
        
        let applePayClient = BTApplePayClient(apiClient: braintreeClient!)
        
        applePayClient.tokenizeApplePay(payment) { (tokenizedApplePayPayment, error) in
            if let tokenizedApplePayPayment = tokenizedApplePayPayment {
                self._flutterResult!(tokenizedApplePayPayment.nonce);
                completion(PKPaymentAuthorizationStatus.success);
            } else {
                // TODO check "error" to know why it failed
                self._flutterResult!("error")
                completion(PKPaymentAuthorizationStatus.failure);
            }
        }
    }
    
    func setupPaymentRequest(amount: String, clientToken: String, completion: @escaping ((PKPaymentRequest?, Error?) -> ())) {
        let braintreeClient = BTAPIClient(authorization: clientToken)
        
        let applePayClient = BTApplePayClient(apiClient: braintreeClient!)
        
        applePayClient.paymentRequest { (paymentRequest, error) in
            if let error = error {
                completion(nil, error)
            } else if let paymentRequest = paymentRequest {
                // TODO get billing information
                // We recommend collecting billing address information, at minimum
                // billing postal code, and passing that billing postal code with all
                // Apple Pay transactions as a best practice.
                
                //paymentRequest.requiredBillingContactFields = [NSSet setWithObject:PKContactFieldPostalAddress];
                
                paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
                paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "MysteryTea", amount: NSDecimalNumber(string: amount))]
                completion(paymentRequest, nil)
            }
        }
    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        UIApplication.shared.keyWindow!.rootViewController!.dismiss(animated: true, completion: nil)
    }

}
