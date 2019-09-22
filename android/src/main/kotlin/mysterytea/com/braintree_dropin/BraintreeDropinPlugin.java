package mysterytea.com.braintree_dropin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.braintreepayments.api.dropin.DropInActivity;
import com.braintreepayments.api.dropin.DropInRequest;
import com.braintreepayments.api.dropin.DropInResult;
import com.braintreepayments.api.models.GooglePaymentRequest;

import com.google.android.gms.wallet.TransactionInfo;
import com.google.android.gms.wallet.WalletConstants;

import java.util.HashMap;

public class BraintreeDropinPlugin implements MethodCallHandler, ActivityResultListener{
    private Activity activity;
    private Context context;
    Result activeResult;
    private static final int REQUEST_CODE = 0x1337;
    String clientToken = "";
    String amount = "";
    String googleMerchantId = "";
    boolean inSandbox;
    boolean enableGooglePay;
    String clientEmail = "";
    String merchantName = "";
    String currencyCode = "EUR";

    public BraintreeDropinPlugin(Registrar registrar) {
        activity = registrar.activity();
        context = registrar.context();
        registrar.addActivityResultListener(this);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "braintree_dropin");
        channel.setMethodCallHandler(new BraintreeDropinPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("showDropIn")) {
            this.activeResult = result;
            this.clientToken = call.argument("clientToken");
            this.amount = call.argument("amount");
            this.inSandbox = call.argument("inSandbox");
            this.googleMerchantId = call.argument("googleMerchantId");
            this.enableGooglePay = call.argument("enableGooglePay");
            this.clientEmail = call.argument("clientEmail");
            this.merchantName = call.argument("merchantName");
            this.currencyCode = call.argument("currencyCode");
            payNow();
        } else {
            result.notImplemented();
        }
    }

    void payNow(){
        DropInRequest dropInRequest = new DropInRequest().clientToken(clientToken);
        if(enableGooglePay){
            enableGooglePay(dropInRequest);
        }
        activity.startActivityForResult(dropInRequest.getIntent(context), REQUEST_CODE);
    }

    private void enableGooglePay(DropInRequest dropInRequest){
        if(inSandbox){
            GooglePaymentRequest googlePaymentRequest = new GooglePaymentRequest()
                    .transactionInfo(TransactionInfo.newBuilder()
                            .setTotalPrice(amount)
                            .setTotalPriceStatus(WalletConstants.TOTAL_PRICE_STATUS_FINAL)
                            .setCurrencyCode(currencyCode)
                            .build())
                    .googleMerchantName(merchantName)
                    .billingAddressRequired(false);
            dropInRequest.googlePaymentRequest(googlePaymentRequest);
        }else{
            GooglePaymentRequest googlePaymentRequest = new GooglePaymentRequest()
                    .transactionInfo(TransactionInfo.newBuilder()
                            .setTotalPrice(amount)
                            .setTotalPriceStatus(WalletConstants.TOTAL_PRICE_STATUS_FINAL)
                            .setCurrencyCode(currencyCode)
                            .build())
                    .billingAddressRequired(false)
                    .googleMerchantName(merchantName)
                    .googleMerchantId(googleMerchantId);
            dropInRequest.googlePaymentRequest(googlePaymentRequest);
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data)  {
        switch (requestCode) {
            case REQUEST_CODE:
                if (resultCode == Activity.RESULT_OK) {
                    DropInResult result = data.getParcelableExtra(DropInResult.EXTRA_DROP_IN_RESULT);
                    String paymentNonce = result.getPaymentMethodNonce().getNonce();
                    if(paymentNonce == null && paymentNonce.isEmpty()){
                        activeResult.success("error");
                    }
                    else{
                        activeResult.success(paymentNonce);
                    }
                } else if (resultCode == Activity.RESULT_CANCELED) {
                    activeResult.success("cancelled");
                } else {
                    activeResult.success("error");
                }
                return true;
            default:
                return false;
        }
    }
}
