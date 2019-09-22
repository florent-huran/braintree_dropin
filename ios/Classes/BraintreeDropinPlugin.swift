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
            if let appearance = arguments?["appearance"] as? [String: Any] {
                customizeAppearance(appearance: appearance)
            }
            _flutterResult = result;
            clientToken = token
            self.merchantName = merchantName
            showDropIn(clientTokenOrTokenizationKey: token, amount: amount, email: email, withResult: result)
        } else {
            result(FlutterMethodNotImplemented);
        }
    }
    
    func customizeAppearance(appearance: [String: Any]) {
        // Sets window theme
        if let useSystemTheme = appearance["useSystemTheme"] as? Bool,
            useSystemTheme == true {
            if #available(iOS 12.0, *) {
                if UIApplication.shared.keyWindow!.rootViewController!.traitCollection.userInterfaceStyle == .dark {
                    BTUIKAppearance.darkTheme()
                } else {
                    BTUIKAppearance.lightTheme()
                }
            } else {
                if let isDarkTheme = appearance["isDarkTheme"] as? Bool,
                    isDarkTheme == true {
                    BTUIKAppearance.darkTheme()
                } else {
                    BTUIKAppearance.lightTheme()
                }
            }
        } else {
            if let isDarkTheme = appearance["isDarkTheme"] as? Bool,
                isDarkTheme == true {
                BTUIKAppearance.darkTheme()
            } else {
                BTUIKAppearance.lightTheme()
            }
        }
        
        if let overlayColorHex = appearance["overlayColorHex"] as? String {
            let overlayColor = UIColor.init(hexString: overlayColorHex)
            BTUIKAppearance().overlayColor = overlayColor
        }
        
        if let tintColorHex = appearance["tintColorHex"] as? String {
            let tintColor = UIColor.init(hexString: tintColorHex)
            BTUIKAppearance().tintColor = tintColor
        }
        
        if let barBackgroundColorHex = appearance["barBackgroundColorHex"] as? String {
            let barBackgroundColor = UIColor.init(hexString: barBackgroundColorHex)
            BTUIKAppearance().barBackgroundColor = barBackgroundColor
        }
        /*
        if let fontFamily {
            let barBackgroundColor = UIColor.init(hexString: barBackgroundColor)
            BTUIKAppearance().tintColor = barBackgroundColor
        }*/
        /*
        if let boldFontFamily {
            let barBackgroundColor = UIColor.init(hexString: barBackgroundColor)
            BTUIKAppearance().tintColor = barBackgroundColor
        }*/
        if let formBackgroundColorHex = appearance["formBackgroundColorHex"] as? String {
            let formBackgroundColor = UIColor.init(hexString: formBackgroundColorHex)
            BTUIKAppearance().formBackgroundColor = formBackgroundColor
        }
        
        if let formFieldBackgroundColorHex = appearance["formFieldBackgroundColorHex"] as? String {
            let formFieldBackgroundColor = UIColor.init(hexString: formFieldBackgroundColorHex)
            BTUIKAppearance().formFieldBackgroundColor = formFieldBackgroundColor
        }
        
        if let primaryTextColorHex = appearance["primaryTextColorHex"] as? String {
            let primaryTextColor = UIColor.init(hexString: primaryTextColorHex)
            BTUIKAppearance().primaryTextColor = primaryTextColor
        }
        
        if let navigationBarTitleTextColorHex = appearance["navigationBarTitleTextColorHex"] as? String {
            let navigationBarTitleTextColor = UIColor.init(hexString: navigationBarTitleTextColorHex)
            BTUIKAppearance().navigationBarTitleTextColor = navigationBarTitleTextColor
        }
        
        if let secondaryTextColorHex = appearance["secondaryTextColorHex"] as? String {
            let secondaryTextColor = UIColor.init(hexString: secondaryTextColorHex)
            BTUIKAppearance().secondaryTextColor = secondaryTextColor
        }
        
        if let disabledColorHex = appearance["disabledColorHex"] as? String {
            let disabledColor = UIColor.init(hexString: disabledColorHex)
            BTUIKAppearance().disabledColor = disabledColor
        }
        
        if let placeholderTextColorHex = appearance["placeholderTextColorHex"] as? String {
            let placeholderTextColor = UIColor.init(hexString: placeholderTextColorHex)
            BTUIKAppearance().placeholderTextColor = placeholderTextColor
        }
        
        if let lineColorHex = appearance["lineColorHex"] as? String {
            let lineColor = UIColor.init(hexString: lineColorHex)
            BTUIKAppearance().lineColor = lineColor
        }
        
        if let errorForegroundColorHex = appearance["errorForegroundColorHex"] as? String {
            let errorForegroundColor = UIColor.init(hexString: errorForegroundColorHex)
            BTUIKAppearance().errorForegroundColor = errorForegroundColor
        }
        
        if let blurStyleRawValue = appearance["blurStyleRawValue"] as? Int,
            let blurStyle = UIBlurEffectStyle.init(rawValue: blurStyleRawValue) {
            BTUIKAppearance().blurStyle = blurStyle
        }
        
        if let activityIndicatorViewStyleRawValue = appearance["activityIndicatorViewStyleRawValue"] as? Int,
            let activityIndicatorViewStyle = UIActivityIndicatorViewStyle.init(rawValue: activityIndicatorViewStyleRawValue) {
            BTUIKAppearance().activityIndicatorViewStyle = activityIndicatorViewStyle
        }
        
        if let useBlurs = appearance["useBlurs"] as? Bool {
            BTUIKAppearance().useBlurs = useBlurs
        }
        
        if let switchOnTintColorHex = appearance["switchOnTintColorHex"] as? String {
            let switchOnTintColor = UIColor.init(hexString: switchOnTintColorHex)
            BTUIKAppearance().switchOnTintColor = switchOnTintColor
        }
        
        if let switchThumbTintColorHex = appearance["switchThumbTintColorHex"] as? String {
            let switchThumbTintColor = UIColor.init(hexString: switchThumbTintColorHex)
            BTUIKAppearance().switchThumbTintColor = switchThumbTintColor
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
        controller.dismiss(animated: true, completion: nil)
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
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
