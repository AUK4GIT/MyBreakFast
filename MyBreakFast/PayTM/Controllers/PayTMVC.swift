//
//  PayTMVC.swift
//  MyBreakFast
//
//  Created by AUK on 23/05/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class PayTMVC: UIViewController, PGTransactionDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PAYTM";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(PayTMVC.cancelAction(_:)))
        self.testPayment(nil);
        }

    func cancelAction(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func showController(controller: PGTransactionViewController)
    {
        if (self.navigationController != nil) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            self.presentViewController(controller, animated: true, completion: nil);
        }
    }
    
    func removeController(controller: PGTransactionViewController)
    {
        if (self.navigationController != nil) {
            self.navigationController?.popViewControllerAnimated(true);
        }
        else {
            controller.dismissViewControllerAnimated(true, completion: nil);
        }
    }

    /*
    func generateOrderIDWithPrefix(prefix: String) -> String
    {
        srand(UInt32(time(nil)))
        let randomNo: Int32  = rand(); //just randomizing the number
        let orderID: String = prefix+String(randomNo);
        return orderID;
    }
 */
    
    func generateOrderIDWithPrefix(prefix: String) -> String
    {
        //        srand(UInt32(time(nil)))
        let randomNo: UInt32  = arc4random(); //just randomizing the number
        let orderID: String = prefix+String(randomNo);
        return orderID;
    }

    
    func testPayment(sender: AnyObject?)
    {
    //Step 1: Create a default merchant config object
        let mc: PGMerchantConfiguration = PGMerchantConfiguration.defaultConfiguration()
    
    //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
    
    
    mc.checksumGenerationURL = PayTMConstants.CheckSumGenURL
    mc.checksumValidationURL = PayTMConstants.CheckSumValidURL
    
    //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
        var orderDict: [NSObject : AnyObject] = [:]
    //Merchant configuration in the order object
    orderDict["MID"] = PayTMConstants.MID;
    orderDict["CHANNEL_ID"] = PayTMConstants.ChannelID;
    orderDict["INDUSTRY_TYPE_ID"] = PayTMConstants.IndustryTypeID;
    orderDict["WEBSITE"] = PayTMConstants.Website;
    //Order configuration in the order object
    let randomOrderCusId = self.generateOrderIDWithPrefix("");
    orderDict["TXN_AMOUNT"] = Helper.sharedInstance.order?.totalAmountPayable
    orderDict["ORDER_ID"] = randomOrderCusId;
    orderDict["REQUEST_TYPE"] = "DEFAULT";
    orderDict["CUST_ID"] = randomOrderCusId;
    
        let order: PGOrder = PGOrder.init(params: orderDict as [NSObject : AnyObject]);
    
    //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
    //PGTransactionViewController and set the serverType to eServerTypeProduction
        
            let txnController: PGTransactionViewController = PGTransactionViewController(transactionForOrder: order);
        let type = PayTMConstants.ServerType == "staging" ? eServerTypeStaging : eServerTypeProduction;
            if type != eServerTypeNone {
                txnController.serverType = type;
                txnController.merchant = mc;
                txnController.delegate = self;
                self.showController(txnController);
            }
        
    }
    
    //MARK : Transaction Delegates
    
    //Called when a transaction has completed. response dictionary will be having details about Transaction.
    func didSucceedTransaction(controller: PGTransactionViewController, response: [NSObject : AnyObject]) {
        print("ViewController::didSucceedTransactionresponse= %@", response);
//        let title = "Your order placed successfully. \n \(response["ORDERID"]!)"
        
//        UIAlertView(title: title, message: response.description, delegate: nil, cancelButtonTitle: "OK").show()
        
        NSNotificationCenter.defaultCenter().postNotificationName("PaymentFinished", object: nil, userInfo: response)
        
        self.removeController(controller);
    }
    
    //Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
    func didFailTransaction(controller: PGTransactionViewController!, error: NSError?, response: [NSObject : AnyObject]?) {
        print("ViewController::didFailTransaction error = %@ response= %@", error, response);
        if ((response) != nil)
        {
            UIAlertView(title: error!.localizedDescription, message: response!.description, delegate: nil, cancelButtonTitle: "OK").show()

        }
        else if ((error) != nil)
        {
            UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()

        }
        NSNotificationCenter.defaultCenter().postNotificationName("PaymentFinished", object: nil, userInfo: nil)

        self.removeController(controller);
    }
    
    //Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
    func didCancelTransaction(controller: PGTransactionViewController, error: NSError?, response: [NSObject : AnyObject]?) {
        print("ViewController::didCancelTransaction error = %@ response= %@", error, response);
//        var msg = "";
//        if ((error == nil)){
//            msg = "Successful";
//        }
//        else {
//            msg = "UnSuccessful";
//        }
        
        UIAlertView(title: "Transaction Cancelled", message: "", delegate: nil, cancelButtonTitle: "OK").show()
//        NSNotificationCenter.defaultCenter().postNotificationName("PaymentFinished", object: nil, userInfo: nil)

        controller.dismissViewControllerAnimated(true, completion: nil);

//        self.removeController(controller);
    }
    
//    //Called when CHeckSum HASH Generation completes either by PG_Server Or Merchant server.
    func didFinishCASTransaction(controller: PGTransactionViewController, response: [NSObject : AnyObject]?) {
        print("ViewController::didFinishCASTransaction:response = %@", response);

    }

}
