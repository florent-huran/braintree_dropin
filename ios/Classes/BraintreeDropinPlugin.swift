import Flutter
import UIKit
import BraintreeDropIn
import Braintree

var viewController: UIViewController
var FlutterResult _flutterResult;

public class SwiftBraintreeDropinPlugin: NSObject, FlutterPlugin {
    var _viewController: UIViewController
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "braintree_dropin", binaryMessenger: registrar.messenger())
        viewController = UIApplication.shared.keyWindow!.rootViewController!
        let instance = SwiftBraintreeDropinPlugin.initWithViewController(viewController: viewController)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func initWithViewController(viewController: UIViewController) {
        self = super.init();
        
        if (self) {
            _viewController = viewController;
        }
        
        return self;
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //result("iOS " + UIDevice.current.systemVersion)
        if call.method == "showDropIn" {
            let arguments = call.arguments as? NSDictionary
            let _token = arguments?["token"] as? String
            let _amount = arguments?["amount"] as? Double
            let _email = arguments?["email"] as? String
            guard let token = _token, let amount = _amount, let email = _email else {
                result(nil)
                return
            }
            showDropIn(clientTokenOrTokenizationKey: token, amount: amount, email: email, withResult: result)
            result(nil)
        } else {
            result(FlutterMethodNotImplemented);
        }
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String, amount: Double, email: String, withResult flutterResult: FlutterResult) {
        let request = BTDropInRequest()
        request.threeDSecureVerification = true
        
        let threeDSecureRequest = BTThreeDSecureRequest()
        threeDSecureRequest.threeDSecureRequestDelegate = self
        
        threeDSecureRequest.amount = amount
        threeDSecureRequest.email = email
        threeDSecureRequest.requested = .version2
        
        /*let address = BTThreeDSecurePostalAddress()
         address.givenName = "Jill"
         address.surname = "Doe"
         address.phoneNumber = "5551234567"
         address.streetAddress = "555 Smith St"
         address.extendedAddress = "#2"
         address.locality = "Chicago"
         address.region = "IL"
         address.postalCode = "12345"
         address.countryCodeAlpha2 = "US"
         threeDSecureRequest.billingAddress = address*/
        
        // Optional additional information.
        // For best results, provide as many of these elements as possible.
        /*let additionalInformation = BTThreeDSecureAdditionalInformation()
         additionalInformation.shippingAddress = address
         threeDSecureRequest.additionalInformation = additionalInformation*/
        
        request.threeDSecureRequest = threeDSecureRequest
        
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                FlutterResult("error")
            } else if (result?.isCancelled == true) {
                FlutterResult("cancelled")
            } else if let result = result {
                flutterResult(result.paymentMethod.nonce);
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    
}
