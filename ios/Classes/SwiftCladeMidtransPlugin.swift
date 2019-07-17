import Flutter
import UIKit
import MidtransKit

public class SwiftCladeMidtransPlugin: NSObject, FlutterPlugin, MidtransUIPaymentViewControllerDelegate {
    var _registrar:FlutterPluginRegistrar
      var _methodChannel:FlutterMethodChannel

      init(registrar:FlutterPluginRegistrar, methodChannel:FlutterMethodChannel) {
          _registrar = registrar
          _methodChannel = methodChannel
      }
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ventures.clade.midtrans", binaryMessenger: registrar.messenger())
    let instance = SwiftCladeMidtransPlugin(registrar: registrar, methodChannel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! [String:Any]
            switch call.method {
            case "initMidtransSdk":
                let clientKey = args["clientKey"]! as! String
                let baseUrl = args["baseUrl"]! as! String
                let isSandbox = args["isSandbox"]! as! Bool
                initMidtransSdk(clientKey: clientKey, baseUrl: baseUrl, isSandbox: isSandbox)
                break
            case "startPayment":
                let snapToken = args["snapToken"]! as! String
                startPayment(token: snapToken)
                break
            case "startPaymentWithSpecificMethod":
                let snapToken = args["snapToken"]! as! String
                let paymentMethod = args["paymentMethod"]! as! Int
                startPaymentWithSpecificMethod(token: snapToken, paymentMethod: paymentMethod)
                break
            default:
                result(FlutterMethodNotImplemented)

            }
  }

   private func initMidtransSdk(clientKey: String, baseUrl: String, isSandbox: Bool) {
          let environment:MidtransServerEnvironment = isSandbox ? .sandbox : .production
          MidtransConfig.shared().setClientKey(clientKey, environment: environment, merchantServerURL: baseUrl)
          MidtransUIConfiguration.shared().hideDidYouKnowView = true
      }

      private func startPayment(token: String) {
          MidtransMerchantClient.shared().requestTransacation(withCurrentToken: token, completion: { regenerateToken, error in
              let paymentVC = MidtransUIPaymentViewController.init(token: regenerateToken)
              paymentVC?.paymentDelegate = self
              let uvc = UIApplication.shared.keyWindow?.rootViewController
              uvc!.present(paymentVC!, animated: true)
          })
      }

      private func startPaymentWithSpecificMethod(token: String, paymentMethod: Int) {
          MidtransMerchantClient.shared().requestTransacation(withCurrentToken: token, completion: { regenerateToken, error in
              guard let payMethod = self.convertPaymentMethod(paymentMethod: paymentMethod) else {
                  // TODO handle unknown payment method
                  return;
              }
              let paymentVC = MidtransUIPaymentViewController.init(token: regenerateToken, andPaymentFeature: payMethod)
              paymentVC?.paymentDelegate = self
              let uvc = UIApplication.shared.keyWindow?.rootViewController
              uvc!.present(paymentVC!, animated: true)
          })
      }

      private func convertPaymentMethod(paymentMethod: Int) -> MidtransPaymentFeature? {
          switch paymentMethod {
          case 1:
              return MidtransPaymentFeature.MidtransPaymentFeatureCreditCard
          case 2:
              return MidtransPaymentFeature.MidtransPaymentFeatureBankTransfer
          case 3:
              return MidtransPaymentFeature.MidtransPaymentFeatureBankTransferBCAVA
          case 4:
              return MidtransPaymentFeature.MidtransPaymentFeatureBankTransferMandiriVA
          case 5:
              return MidtransPaymentFeature.MidtransPaymentFeatureBankTransferPermataVA
          case 6:
              return MidtransPaymentFeature.MidtransPaymentFeatureBankTransferBNIVA
          case 7:
              return MidtransPaymentFeature.MidtransPaymentFeatureBankTransferOtherVA
          case 8:
              return MidtransPaymentFeature.MidtransPaymentFeatureGOPAY
          case 9:
              return MidtransPaymentFeature.midtranspaymentfeatureBCAKlikPay
          case 10:
              return MidtransPaymentFeature.MidtransPaymentFeatureKlikBCA
          case 11:
              return MidtransPaymentFeature.MidtransPaymentFeatureMandiriClickPay
          case 12:
              return MidtransPaymentFeature.MidtransPaymentFeatureMandiriEcash
          case 13:
              return MidtransPaymentFeature.MidtransPaymentFeatureBRIEpay
          case 14:
              return MidtransPaymentFeature.MidtransPaymentFeatureCIMBClicks
          case 15:
              return MidtransPaymentFeature.MidtransPaymentFeatureIndomaret
          case 16:
              return MidtransPaymentFeature.MidtransPaymentFeatureKiosON
              //case 17:
          //return Gift Card Indonesia
          case 18:
              return MidtransPaymentFeature.MidtransPaymentFeatureIndosatDompetku
          case 19:
              return MidtransPaymentFeature.MidtransPaymentFeatureTelkomselEcash
          case 20:
              return MidtransPaymentFeature.MidtransPaymentFeatureXLTunai
          case 21:
              return MidtransPaymentFeature.MidtransPyamentFeatureDanamonOnline
          default:
              return nil
          }
      }

      public func onTransactionFinishedHandler(result: String) {
          print("trx \(result)")
          _methodChannel.invokeMethod("onTransactionFinished", arguments: result)
      }

      public func paymentViewController(_ viewController: MidtransUIPaymentViewController!, save result: MidtransMaskedCreditCard!) {
          /// Unimplemented
      }

      public func paymentViewController(_ viewController: MidtransUIPaymentViewController!, saveCardFailed error: Error!) {
          /// Unimplemented
      }

      public func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
          onTransactionFinishedHandler(result: "pending")
      }

      public func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
          onTransactionFinishedHandler(result: "success")
      }

      public func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: Error!) {
          onTransactionFinishedHandler(result: "failed")
      }

      public func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
          onTransactionFinishedHandler(result: "cancelled")
      }
}
