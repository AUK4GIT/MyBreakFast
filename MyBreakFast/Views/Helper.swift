//
//  Helper.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 13/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import Reachability

@objc public enum PaymentType: NSInteger {
    case COD
    case NB
    case CARDS
    case PAYTM
    case CITRUS
    case NONE
}
@objc class Helper : NSObject{
    static let sharedInstance = Helper()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var actView : ActivityIndicator?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var reach: Reachability?
    var userLocation: String?
    var order: Order?
    var quantities: String?
    var orderDate: String?
    var currenttimeSlot = ""
    var isOrderForTomorrow = false;
    var redeemValue: Double = 0.5;
    var kitchen = "";

    func setUpReachability(){
    
        self.reach = Reachability.reachabilityForInternetConnection()
        
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(Helper.reachabilityChanged(_:)),
            name: kReachabilityChangedNotification,
            object: nil)
        
        self.reach!.startNotifier()
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() || self.reach!.isReachable(){
            print("Service avalaible!!!")
        } else {
            print("No service avalaible!!!")
        }
    }
    
    
    func isvalidaEmailId(emailId: String)-> Bool {
        
        let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        
        let isValid : Bool = emailTest.evaluateWithObject(emailId)
        
        print(isValid)
        if isValid {
            return true;
        } else {
            return false;
        }
    }

    
    func saveToUserDefaults(forKey key: String, value: AnyObject){
        print("************--->: "+key+" : ", value);
        userDefaults.setObject(value, forKey: key);
        userDefaults.synchronize();
    }
    
    func getDataFromUserDefaults(forKey key: String)->AnyObject?{
        if let obj = userDefaults.objectForKey(key) {
            return obj;
        } else {
            return nil;
        }
    }
    
    func showActivity() {
        let mainView : UIWindow = ((UIApplication.sharedApplication().delegate?.window)!)!
        guard let _ = self.actView else {
            self.actView = ActivityIndicator(onView: mainView);
            mainView.addSubview(self.actView!);
            mainView.bringSubviewToFront(self.actView!)
            return
        }
        mainView.addSubview(self.actView!);
        mainView.bringSubviewToFront(self.actView!)
    }
    
    func hideActivity() {
        if let _ = self.actView {
            self.actView!.removeFromSuperview();
            self.actView = nil;
        }
    }
    
    //MARK: DataBase methods
    
    func saveLocations(locations: AnyObject) {
        self.deleteData("Locations");
        self.saveContext()
        for location in locations as! [AnyObject] {
            let locationObj: Locations = NSManagedObject(entity: NSEntityDescription.entityForName("Locations",
                inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! Locations
            locationObj.saveData(location as! NSDictionary);
        }
    }
    
    func saveMenuItems(items: AnyObject) {
        for item in items as! [AnyObject] {
            let itemObj: Item = NSManagedObject(entity: NSEntityDescription.entityForName("Item",
                inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! Item
            itemObj.saveData(item as! NSDictionary);
        }
        self.saveContext();
    }
    
    func saveKitchens(items: AnyObject) {
        for item in items as! [AnyObject] {
            let itemObj: Kitchens = NSManagedObject(entity: NSEntityDescription.entityForName("Kitchens",
                inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! Kitchens
            itemObj.saveData(item as! NSDictionary);
        }
        self.saveContext();
    }
    
//    func saveMenuOrders(myOrders: AnyObject) {
//        self.deleteData("MyOrder");
//        for order in myOrders as! [AnyObject] {
//            let orderObj: MyOrder = NSManagedObject(entity: NSEntityDescription.entityForName("MyOrder",
//                inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! MyOrder
//            orderObj.saveData(order as! NSDictionary);
//        }
//    }
    
    func saveUserDetailsFromFaceBook(userDetails: NSDictionary) {
        self.deleteData("UserDetails");
        self.saveContext();
        let userObj: UserDetails = NSManagedObject(entity: NSEntityDescription.entityForName("UserDetails",
                inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! UserDetails
        userObj.userName = userDetails.objectForKey("name") as? String
        userObj.emailId = userDetails.objectForKey("email") as? String
        self.saveContext();
    }
    
    // MARK: Getters
    func getFoodDetailsObject()->NSManagedObject {
        let foodObj: Fooddetails = NSManagedObject(entity: NSEntityDescription.entityForName("Fooddetails",
            inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! Fooddetails
        return foodObj;
    }
    
    func getUserAddressObject()->NSManagedObject {
        let userAddrObj: UserAddress = NSManagedObject(entity: NSEntityDescription.entityForName("UserAddress",
            inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! UserAddress
        return userAddrObj;
    }
    
    func getTimeSlotsObject()->NSManagedObject {
        let timeSlotsrObj: TimeSlots = NSManagedObject(entity: NSEntityDescription.entityForName("TimeSlots",
            inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! TimeSlots
        return timeSlotsrObj;
    }
    
    func getOfferssObject()->Offer {
        let offerObj: Offer = NSManagedObject(entity: NSEntityDescription.entityForName("Offer",
            inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! Offer
        return offerObj;
    }

    func getUserDetailsObj()->NSManagedObject {
        
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        var usdObjs: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        if(usdObjs?.count>0) {
            return usdObjs![0]
        }
        
        let usdObj: UserDetails = NSManagedObject(entity: NSEntityDescription.entityForName("UserDetails",
            inManagedObjectContext:appDelegate.managedObjectContext)!, insertIntoManagedObjectContext: appDelegate.managedObjectContext) as! UserDetails
        return usdObj;
    }
    
    /*
    returns dictionary of userdata for Citrus PG
    */
    func getUserDetailsDict()-> NSDictionary? {
        
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        var usdObjs: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if(usdObjs?.count>0) {
            let userDetails: UserDetails = usdObjs![0] as! UserDetails;
            let userDict: NSMutableDictionary = NSMutableDictionary();
            userDict.setObject(userDetails.userName!, forKey: "firstName");
            userDict.setObject(userDetails.emailId!, forKey: "email");
            userDict.setObject(userDetails.phoneNumber!, forKey: "mobile");
            userDict.setObject(userDetails.address  ?? "", forKey: "address");
            
            
            return userDict;
        }
        
        return nil;
    }
    
    func getUserNameandUserPhoneNumber()->UserDetails? {
        
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        var usdObjs: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if(usdObjs?.count>0) {
            return usdObjs![0] as? UserDetails
        } else {
            return nil;
        }
    }
    
    func getCommaSeparatedMenuIdsandQuantities() -> String {
        
        let orders = self.order?.orders.filter(){ $0.quantity > "0" };
        var menuids: String = ""
        var quantities: String = ""

        for (index, order) in (orders?.enumerate())! {
            let ord = order as OrderItem;
            if index == 0 {
                menuids = ord.itemId!
                quantities = ord.quantity!
                let qnty = Int(quantities)! - 1
                if qnty>0 {
                    for _ in  1...qnty{
                        menuids = menuids+","+ord.itemId!
                        quantities = quantities+","+ord.quantity!
                    }
                }
            } else {
                let qnty = Int(ord.quantity!)! - 1
                for _ in  0...qnty {
                    menuids = menuids+","+ord.itemId!
                    quantities = quantities+","+ord.quantity!
                }
            }
        }
        self.quantities = quantities;
        return menuids;
    }
    
    func getCommaSeparatedMenuIdsandQuantitiesForOrder() -> String {
        let orders = self.order?.orders
        var menuids: String = ""
        var quantities: String = ""
        
        for (index, order) in (orders?.enumerate())! {
            let ord = order as OrderItem;
            if index == 0 {
                menuids = ord.itemId!
                quantities = ord.quantity!
            } else {
                menuids = menuids+","+ord.itemId!
                quantities = quantities+","+ord.quantity!
            }
        }
        self.quantities = quantities;
        return menuids;

    }

    
    func getCommaSeparatedOfferIds() -> String {
        
        let offers = self.order?.offers
        var offerids: String = ""
        
        for (index, offer) in (offers?.enumerate())! {
            let offe = offer as Offer;
            if index == 0 {
                offerids = offe.offerid!
            } else {
                offerids = offerids+","+offe.offerid!
            }
        }
        return offerids;
    }
    
    
    func getOrderItems()->[NSManagedObject] {        
        Helper.sharedInstance.order?.orders = (Helper.sharedInstance.order?.orders.filter() { $0.quantity > "0" })!
        var predicatesArray: [NSPredicate] = [];
        for orderitem in (Helper.sharedInstance.order?.orders)! {
            let predicate :NSPredicate = NSPredicate(format: "itemid == %d",Int(orderitem.itemId!)!)
            predicatesArray.append(predicate)
        }
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let predicate:NSPredicate  = NSCompoundPredicate(orPredicateWithSubpredicates: predicatesArray )
        let sortDescriptor = NSSortDescriptor(key: "stockid", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate;
        
        var items: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return items!
    }
    
    func getOfferoftheDay()-> Offer? {
        
        let fetchRequest = NSFetchRequest(entityName: "Offer")
        let predicate :NSPredicate = NSPredicate(format: "offeroftheday == 0")
        
        fetchRequest.predicate = predicate;
        
        var items: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if items?.count > 0{
            let offer = items![0] as? Offer
            return offer
        }
        return nil;
    }

    
    func getTodaysItems() -> [Item] {
        
        let fetchRequest = NSFetchRequest(entityName: "Item")
        let sortDescriptor = NSSortDescriptor(key: "stockid", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        var items: [Item]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [Item]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return items!
    }
    
    func getLocations() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "Locations")
        var locations: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            locations = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return locations!
    }
    
    func getLocationsForSearchString(searchStr: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "Locations")
        let predicate :NSPredicate = NSPredicate(format: "locationName CONTAINS[cd] %@",searchStr)
        fetchRequest.predicate = predicate;
        var locations: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            locations = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return locations!
    }
    
    func getLocationsForLocationId(searchStr: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "Locations")
        let predicate :NSPredicate = NSPredicate(format: "locationId == %@",searchStr)
        fetchRequest.predicate = predicate;
        var locations: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            locations = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return locations!
    }
    
    func getMyOrders() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: "MyOrder")
        var orders: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            orders = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return orders!
    }
    
    func getWeekDates() -> [AnyObject] {
        var datesArray: [AnyObject] = []
        let today = NSDate();
        for i in 0...6 {
            datesArray.append(today.dateByAddingTimeInterval(NSTimeInterval(60*60*24*i)))
        }
        return datesArray;
    }
    
    func getUserId() -> String {
        
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        var items: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        var userId = "";
        if items?.count>0{
            let userDetails = items![0] as! UserDetails
            userId = userDetails.userId ?? "";
//            print(" userDetails.userName!: ",userDetails.userName!);
        }
        return userId;
    }

    
    func getUserEmailId() -> String {
        
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        var items: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        var emailId = "";
        if items?.count>0{
            let userDetails = items![0] as! UserDetails
            emailId = userDetails.emailId ?? "";
            print(" userDetails.emailId!: ",emailId);
        }
        return emailId;
    }
    
    func getUserName() -> String {
        
        let fetchRequest = NSFetchRequest(entityName: "UserDetails")
        var items: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        var userName = "Guest";
        if items?.count>0{
            let userDetails = items![0] as! UserDetails
            userName = userDetails.userName!;
            print(" userDetails.userName!: ",userDetails.userName!);
        }
        return userName;
    }
    
    func getUserAddresses() -> [NSManagedObject]? {
        
        let fetchRequest = NSFetchRequest(entityName: "UserAddress")
        var items: [NSManagedObject]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            items = results as? [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if items?.count>0{
            return items;
        }
        return nil;
    }
    
    
    func getOrderCountandPrice(completionHandler: (Int, Int) -> ()) {
        
        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(backgroundQueue) { () -> Void in
            let ordersArray = Helper.sharedInstance.order?.orders.filter({ $0.quantity > "0" })
            let offersArray = Helper.sharedInstance.order?.offers

            var count = 0//ordersArray!.count
            var price = 0;
            var offerPrice = 0;
            for order in ordersArray! {
                let order = order as OrderItem
                price += Int((order.itemPrice)!)!
                count += Int((order.quantity)!)!
            }
            for offer in offersArray! {
                let offer = offer as Offer
                offerPrice += Int((offer.price)!)!
            }
            price += offerPrice
            Helper.sharedInstance.order?.totalAmount = String(price)

            if self.order?.hasRedeemedPoints == true {
                price = price - Int((self.order?.discount)!)!
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(count, price)
            }
        }
        
    }
    
    func getTotalPrice(completionHandler: (Int) -> ()) {
        self.getOrderCountandPrice { (count, price) -> () in
            
            var totalAmount = price;
            var actualDiscount = 0;
            
            //Note: Either Redeem or Coupon but not both can be applied per order.
            if self.order?.couponsApplied.count > 0 {
                for couponObj in (self.order?.couponsApplied)! {
                    let coupon = couponObj as Coupon
                    actualDiscount += Int((coupon.actualDiscount))!
                }
            }
            totalAmount -= actualDiscount;
            if totalAmount < 0 {
                totalAmount = 0;
            }
            let vatPercent = 0.125;
            let scPercent = 0.05;
            let vatAmount = Double(totalAmount) * vatPercent
            let scAmount = vatAmount * scPercent
//            let totalPayableAmount = totalAmount+Int(ceil(vatAmount+scAmount))-Int(Double((self.order?.pointsToRedeem)!)! * Double(self.redeemValue))
            let totalPayableAmount = totalAmount+Int(ceil(vatAmount+scAmount))
            self.order?.totalAmountPayable = String(totalPayableAmount);
            self.order?.vatAmount = String(vatAmount);
            self.order?.serviceChargeAmount = String(scAmount);
            completionHandler(totalPayableAmount)
        }
        
    }
    
        
    func deleteData(entityName: String) {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.includesPropertyValues = false // Only fetch the managedObjectID (not the full object structure)
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.appDelegate.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.appDelegate.managedObjectContext)
            } catch let error as NSError {
                print("ERROR: \(error)")
            }
        } else {
            // Fallback on earlier versions
            do {
                let results =
                try self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                for result in results! {
                    self.appDelegate.managedObjectContext.deleteObject(result)
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    

    func fetchTimeSlotObjectForId()->TimeSlots? {
        let predicate :NSPredicate = NSPredicate(format: "slotid == %@",(Helper.sharedInstance.order?.timeSlotId)!)
        let fetchRequest = NSFetchRequest(entityName: "TimeSlots")
        fetchRequest.predicate = predicate;
        var usdObjs: [TimeSlots]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [TimeSlots]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if(usdObjs?.count>0) {
            return usdObjs![0]
        }
        
        return nil;
    }
    
    func fetchLastUserAddressesForId(addrId: String)->UserAddress? {
        let predicate :NSPredicate = NSPredicate(format: "addressId == %@",addrId)
        let fetchRequest = NSFetchRequest(entityName: "UserAddress")
        fetchRequest.predicate = predicate;
        var usdObjs: [UserAddress]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [UserAddress]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if(usdObjs?.count>0) {
            return usdObjs![0]
        }
        
        return nil;
    }

    func fetchKitchens()->[Kitchens]? {
        let fetchRequest = NSFetchRequest(entityName: "Kitchens")
        var usdObjs: [Kitchens]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [Kitchens]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if(usdObjs?.count>0) {
            return usdObjs!
        }
        
        return nil;
    }

    func fetchClusterFromLocationForId(locId: String)->String? {
        let predicate :NSPredicate = NSPredicate(format: "locationId == %@",locId)
        let fetchRequest = NSFetchRequest(entityName: "Locations")
        fetchRequest.predicate = predicate;
        var usdObjs: [Locations]?
        do {
            let results =
            try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
            usdObjs = results as? [Locations]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        var cluster = "";
        if(usdObjs?.count>0) {
             let locObj = usdObjs![0]
            cluster = (locObj.cluster! ?? "");
            return cluster;
        }
        
        return "";
    }
    
    // MARK: Service APIs
    
    func doGCMRegistration(completionHandler: (AnyObject) -> ()) {
        
        let values = ["devid":self.userDefaults.objectForKey("DeviceId")!,"dev":UIDevice.currentDevice().model,
            "gcm":self.appDelegate.registrationToken!,
            "email":self.getUserEmailId()]
        
        Alamofire.request(.GET, Constants.API.GCMRegistration, parameters: values)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                // do whatever you want here
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Helper.sharedInstance.hideActivity()
                    switch response.result {
                    case .Failure(let error):
                        print(error)
                        completionHandler("ERROR")
                    case .Success(let responseObject):
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            print(responseObject)
                            completionHandler(JSON.objectForKey("data")!)
                        }
                        
                    }
                }
        }
    }
    
//    func doUserRegistration(userObject: UserDetails, password: String, referralId: String, completionHandler: (AnyObject) -> ()) {
//        
//        let gcmId = (self.appDelegate.registrationToken ?? self.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.GCMRegistrationToken) ?? "")
//        let useraddress = userObject.address ?? ""
//        let values: [String: String] = ["devid":self.userDefaults.objectForKey("DeviceId")! as! String,"devtype":UIDevice.currentDevice().model, "gcm": gcmId as! String, "email":userObject.emailId!,"mobile":userObject.phoneNumber!,"name":userObject.userName!,"pwd":password,"address":useraddress,"ref":referralId];
//        Helper.sharedInstance.showActivity()
//        Alamofire.request(.GET, Constants.API.UserRegistration, parameters: values)
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
////                //print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                // do whatever you want here
//                switch response.result {
//                case .Failure(let error):
//                    print(error)
//                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                        print(response.result.value)
//                        Helper.sharedInstance.hideActivity()
//                        completionHandler("ERROR")
//                    }
//                case .Success( _):
//                    if let JSON = response.result.value {
//                        print("JSON: \(JSON)")
//                        if let jData =  JSON.objectForKey("data") as? NSDictionary{
//                            if let userid = jData.objectForKey("user_id") as? NSNumber {
//                                userObject.userId = userid.stringValue
//                            } else {
//                                userObject.userId = jData.objectForKey("user_id") as? String
//                            }
//                            if let keys = jData.objectForKey("keys"){
//                                if keys is NSNull {
//                                    userObject.referralCode = ""
//                                } else {
//                                    userObject.referralCode = keys.objectForKey("referal_code") as? String
//                                }
//                            }
//                            self.saveContext();
//                        }
//                    }
//                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                        print(response.result.value)
//                        Helper.sharedInstance.hideActivity()
//                        completionHandler("SUCCESS")
//
//                    }
//            }
//        }
//    }
    
    func registerUser(userObject: UserDetails, password: String, referralId: String, completionHandler: (AnyObject) -> ()) {
        
        let gcmId = (self.appDelegate.registrationToken ?? self.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.GCMRegistrationToken) ?? "")
        let useraddress = userObject.address ?? ""
        let values: [String: String] = ["devid":self.userDefaults.objectForKey("DeviceId")! as! String,"devtype":UIDevice.currentDevice().model, "gcm": gcmId as! String, "email":userObject.emailId!,"mobile":userObject.phoneNumber!,"name":userObject.userName!,"pwd":password,"address":useraddress,"ref":referralId];
        Helper.sharedInstance.showActivity()
        Alamofire.request(.GET, Constants.API.UserRegistration, parameters: values)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(error)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        print(response.result.value)
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                case .Success( _):
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        if let jData =  JSON.objectForKey("data") as? NSDictionary{
                            if let userid = jData.objectForKey("user_id") as? NSNumber {
                                userObject.userId = userid.stringValue
                            } else {
                                userObject.userId = jData.objectForKey("user_id") as? String
                            }
                            if let keys = jData.objectForKey("keys"){
                                if keys is NSNull {
                                    userObject.referralCode = ""
                                } else {
                                    userObject.referralCode = keys.objectForKey("referal_code") as? String
                                }
                            }
                            self.saveContext();
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        print(response.result.value)
                        Helper.sharedInstance.hideActivity()
                        completionHandler("SUCCESS")
                        
                    }
                }
        }
    }
    
    func doUserLogin(userEmail: String, password: String, completionHandler: (AnyObject) -> ()) {
        
        let gcmId = (self.appDelegate.registrationToken ?? self.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.GCMRegistrationToken) ?? "")
        let values: [String: String] = ["devid":self.userDefaults.objectForKey("DeviceId")! as! String,"devtype":UIDevice.currentDevice().model, "gcm": gcmId as! String, "email":userEmail, "pwd":password];
        Helper.sharedInstance.showActivity()
        Alamofire.request(.GET, Constants.API.UserLogin, parameters: values)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                // do whatever you want here
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Helper.sharedInstance.hideActivity()
                    switch response.result {
                    case .Failure(let error):
                        print(error)
                        completionHandler("ERROR")
                    case .Success(let responseObject):
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            print(responseObject)
                            completionHandler(JSON.objectForKey("data")!)
                        }

                    }
                }
        }
    }
    
    func validatePhoneNumber(phonenumber: String, completionHandler: (AnyObject) -> ()) {
        
        let values: [String: String] = ["mobile":phonenumber];
        Helper.sharedInstance.showActivity()
        Alamofire.request(.GET, Constants.API.ValidatePhonenumber, parameters: values)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                // do whatever you want here
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Helper.sharedInstance.hideActivity()
                    switch response.result {
                    case .Failure(let error):
                        print(error)
                        completionHandler("ERROR")
                    case .Success(let responseObject):
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                            print(responseObject)
                            completionHandler(JSON)
                        }
                        
                    }
                }
        }
    }
    
    func VerifyOTP(otp: String,userObject: UserDetails, completionHandler: (AnyObject) -> ()) {
        let values: [String: String] = ["otp":otp, "user_id":userObject.userId!];
        Helper.sharedInstance.showActivity()
        Alamofire.request(.GET, Constants.API.VerifyOTP, parameters: values)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                // do whatever you want here
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Helper.sharedInstance.hideActivity()
                    switch response.result {
                    case .Failure(let error):
                        print(error)
                        completionHandler("ERROR")
                    case .Success(let responseObject):
                        if let JSON = response.result.value {
                            self.saveContext();
                            print("JSON: \(JSON)")
                            print(responseObject)
                            completionHandler(JSON)
                        }
                        
                    }
                }
        }
    }
    
    func fetchLocations(completionHandler: () -> Void) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        Alamofire.request(.GET, Constants.API.DeliveryLocationsURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.saveLocations(JSON.objectForKey("data")!)
                    self.saveContext();
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    completionHandler()
                }
        }
    }
    
    func fetchUserAddressess(completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            Helper.sharedInstance.hideActivity()
            return
        }
        let userId = self.getUserId()
        let completeURL = Constants.API.UserAddresses+userId
        Alamofire.request(.GET, completeURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    completionHandler(JSON.objectForKey("data")!)
                    } else {
                        completionHandler("ERROR")
                    }
                    Helper.sharedInstance.hideActivity()

        }
        
        }
    }
    
    func fetchKitchenAddressess(completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let completeURL = Constants.API.URL_KITCHENS
        Alamofire.request(.GET, completeURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        self.deleteData("Kitchens");
                        self.saveContext();
                        self.saveKitchens(JSON.objectForKey("data")!);
                        completionHandler("SUCCESS")
                    } else {
                        completionHandler("ERROR")
                    }
                }
        }
    }
    
    func fetchKitchenDistance(origin: String, destinations: String, completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let completeURL = Constants.API.GOOGLE_DISTENCE_MATRIX
        Alamofire.request(.GET, completeURL, parameters: ["origins":origin, "destinations":destinations, "language":"en-EN", "key":Constants.API.GOOGLE_BROWSER_KEY])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completionHandler(JSON)
                    } else {
                        completionHandler("ERROR")
                    }
                }
        }
    }

    
    func fetchUserRedeemPoints(completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            Helper.sharedInstance.hideActivity()
            return
        }
        let userId = self.getUserId()
        let completeURL = Constants.API.GETRedeemPoints+userId

        Alamofire.request(.GET, completeURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completionHandler(JSON.objectForKey("data")!)
                    } else {
                        completionHandler("ERROR")
                    }
                }
                
        }
    }

    /*
    func redeemPoints(points: String, completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let userId = self.getUserId()
        let completeURL = Constants.API.RedeemPoints+userId
        
        Alamofire.request(.GET, completeURL, parameters: ["points":points])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completionHandler(JSON.objectForKey("data")!)
                    } else {
                        completionHandler("ERROR")
                    }
                }
                
        }
    }
*/
    
    func validateCoupon(couponcode: String, completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let userId = self.getUserId()
        let completeURL = Constants.API.ValidateCoupon+couponcode
        
        Alamofire.request(.GET, completeURL, parameters: ["user":userId, "amt":(self.order?.totalAmount)!, "menu":self.getCommaSeparatedMenuIdsandQuantities(),"qty":self.quantities!])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completionHandler(JSON.objectForKey("data")!)
                    } else {
                        completionHandler("ERROR")
                    }
                }
                
        }
    }


    
    func fetchTimeSolts(forDate date: NSDate, completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringFromDate = dateFormatter.stringFromDate(date);
        Alamofire.request(.GET, Constants.API.TimeSlots, parameters: ["d":stringFromDate, "kitchen":Helper.sharedInstance.kitchen])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        if let curTimeSlot = JSON.objectForKey("now") {
                            self.currenttimeSlot = curTimeSlot as! String
                        }
                        completionHandler(JSON.objectForKey("data")!)
                    } else {
                        completionHandler("ERROR")
                    }
                }
                
        }
    }
    
    func uploadAddress(address: [String: String],completionHandler: (AnyObject) -> ()) {
        
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        var dict = address//["user": self.getUserId()];
        dict.updateValue(self.getUserId(), forKey: "user")
        Alamofire.request(.GET, Constants.API.UpdateUserAddress, parameters: dict)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completionHandler(JSON.objectForKey("data")!)
                    } else {
                        completionHandler("ERROR")
                    }
                }
                
        }
    }

    func getUserDetails(userid: String, completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        if !self.reach!.isReachable() {
            UIAlertView(title: "No Internet Connection!", message: "Please connect to internet and try again", delegate: nil, cancelButtonTitle: "OK").show()
            Helper.sharedInstance.hideActivity()
            return
        }
        let url: String = Constants.API.UserDetails+userid;
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                Helper.sharedInstance.hideActivity()
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        let data: NSArray = JSON.objectForKey("data")! as! NSArray
                        completionHandler(data[0]);
                    } else {
                        completionHandler("ERROR")
                    }
                }
                
        }
    }

/*
    func getMenuFor(date: NSDate, completionHandler: () -> Void) {
        
        Helper.sharedInstance.showActivity()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringFromDate = "?d=\(dateFormatter.stringFromDate(date))";
        self.orderDate = dateFormatter.stringFromDate(date);// This is very important
        let url = "\(Constants.API.MenuonDate)\(stringFromDate)"
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.deleteData("Offer");
                    self.deleteData("Fooddetails");
                    self.deleteData("Item");
                    self.saveContext();
                    if let jData =  JSON.objectForKey("data") as? Array<AnyObject>{
                        var numPoints = 2;
                        var pointsVal = 1;
                        if let pointsT = JSON.objectForKey("num_points") as? NSNumber{
                            numPoints = Int(pointsT);
                        } else {
                            numPoints = Int(JSON.objectForKey("num_points") as! String)!
                        }
                        if let pointsV = JSON.objectForKey("point_value") as? NSNumber{
                            pointsVal = Int(pointsV);
                        } else {
                            pointsVal = Int(JSON.objectForKey("point_value") as! String)!
                        }
                        Helper.sharedInstance.redeemValue = Double(pointsVal)/Double(numPoints);
                        self.saveMenuItems(jData)
                        self.saveContext();
                    }
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Helper.sharedInstance.hideActivity()
                    completionHandler()
                }
        }
    }
    */
    
    func getMenuFor(date: NSDate, completionHandler: () -> Void) {
        
        Helper.sharedInstance.showActivity()
        let locId = self.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedLocationId) as? String ?? ""
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringFromDate = "?d=\(dateFormatter.stringFromDate(date))";

        self.orderDate = dateFormatter.stringFromDate(date);// This is very important
        let url = "\(Constants.API.MenuonDateLocation)\(locId)\(stringFromDate)"
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.deleteData("Offer");
                    self.deleteData("Fooddetails");
                    self.deleteData("Item");
                    self.saveContext();
                    if let jData =  JSON.objectForKey("data") as? Array<AnyObject>{
                        var numPoints = 2;
                        var pointsVal = 1;
                        if let pointsT = JSON.objectForKey("num_points") as? NSNumber{
                            numPoints = Int(pointsT);
                        } else {
                            numPoints = Int(JSON.objectForKey("num_points") as! String)!
                        }
                        if let pointsV = JSON.objectForKey("point_value") as? NSNumber{
                            pointsVal = Int(pointsV);
                        } else {
                            pointsVal = Int(JSON.objectForKey("point_value") as! String)!
                        }
                        Helper.sharedInstance.redeemValue = Double(pointsVal)/Double(numPoints);
                        Helper.sharedInstance.kitchen = (JSON.objectForKey("kitchen") as? NSNumber)!.stringValue
                        self.saveMenuItems(jData)
                        self.saveContext();
                    }
                }
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    Helper.sharedInstance.hideActivity()
                    completionHandler()
                }
        }
    }
    
    func getItemDetailsForId(itemId: String, completionHandler: (AnyObject) -> Void) {
        
        
        let url = "\(Constants.API.OrderDetails)\(itemId)"
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(JSON)
                    }
                } else {
                    
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }

        }
    }

    
    
    func getAboutusText(completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        Alamofire.request(.GET, Constants.API.AboutUs, parameters: nil)
        .responseString { response in
        print(response.request)  // original URL request
        print(response.response) // URL response
        //print(response.data)     // server data
        print(response.result)   // result of response serialization
            
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                Helper.sharedInstance.hideActivity()
                completionHandler(JSON)
            }
        } else {
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                Helper.sharedInstance.hideActivity()
                completionHandler("ERROR")
            }
            }
        }
        
    }
    
    func getDeliveryLocations(completionHandler: (AnyObject) -> ()) {
        
        Alamofire.request(.GET, Constants.API.LocationsURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        completionHandler(JSON)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        completionHandler("ERROR")
                    }
                }
        }
    }


    
    func sendUserQuery(message: String, completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()

        let request = NSMutableURLRequest(URL: NSURL(string: Constants.API.ContactUsMessage)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let values = ["user_id": self.getUserEmailId(), "query" : message]
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(values, options: [])
        
        Alamofire.request(request)
            .responseJSON { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(error)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                case .Success(let responseObject):
                    print(responseObject)
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(responseObject)
                    }
                }
        }
    }
    
    
    func getMyOrders(completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        let completeURL = Constants.API.MyOrders+self.getUserId()
        Alamofire.request(.GET, completeURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
//                    if let jData =  JSON.objectForKey("data") as? Array<AnyObject>{
//                        self.saveMenuOrders(jData)
//                        self.saveContext();
//                    }
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(JSON)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }
        }
    }

    func placeOrder(paymentMode: String, completionHandler: (AnyObject) -> ()) {
        
        
        Helper.sharedInstance.showActivity()
        let completeURL = Constants.API.PlaceOrder+self.getUserId()
        let change = Helper.sharedInstance.order?.change ?? "100"
        let coupon = Helper.sharedInstance.order?.couponsApplied.count>0 ? Helper.sharedInstance.order?.couponsApplied[0]: nil;
        var couponId = "";
        if coupon != nil {
            couponId = (coupon?.couponid)!;
        }
        let postParams: [String : AnyObject] = ["change":change as String,
            "coupon":couponId,
            "kitchen":Helper.sharedInstance.kitchen,
            "address":(self.order?.addressId!)!,
            "slot":(self.order?.timeSlotId)!,
            "points":0,
            "menu":self.getCommaSeparatedMenuIdsandQuantitiesForOrder(),
            "qty":self.quantities!,
            "offers":self.getCommaSeparatedOfferIds(),
            "subtotal":(self.order?.totalAmount!)!,
            "paymentmode":paymentMode,
            "discount":(Helper.sharedInstance.order?.discount)!,
            "vat":(Helper.sharedInstance.order?.vatAmount)!,
            "surcharge":(Helper.sharedInstance.order?.serviceChargeAmount)!,
            "total":(self.order?.totalAmountPayable!)!,
            "d":self.orderDate!]
        
        Alamofire.request(.GET, completeURL, parameters: postParams)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if let jData =  JSON as? NSDictionary{
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            Helper.sharedInstance.hideActivity()
                            completionHandler(jData)
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            Helper.sharedInstance.hideActivity()
                            completionHandler("ERROR")
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }
        }
    }
    
    func verifyPaymentForTransaction(transactionDict: NSDictionary, completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        let completeURL = Constants.API.VerifyPayment+(self.order?.orderId)!
        
        Alamofire.request(.GET, completeURL, parameters: transactionDict as? [String : AnyObject])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(JSON)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }
        }
    }
    
    func uploadFavouriteMenu(menuId: String, completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        let completeURL = Constants.API.UploadFavouritesMenu+self.getUserId()
        
        Alamofire.request(.GET, completeURL, parameters: ["menu":menuId])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(JSON)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }
        }
    }
    
    func getSpecialNotificationOffers(completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        let completeURL = Constants.API.SpecialNotifications
        
        Alamofire.request(.GET, completeURL, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(JSON)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }
        }
    }

    
    func sendUserFeedback(message: String, rating: String , completionHandler: (AnyObject) -> ()) {
        
        Helper.sharedInstance.showActivity()
        let completeURL = Constants.API.UserFeedback+self.getUserId()
        
        Alamofire.request(.GET, completeURL, parameters: ["msg":message,"rating":rating])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler(JSON)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        Helper.sharedInstance.hideActivity()
                        completionHandler("ERROR")
                    }
                }
        }

    }
    
    
    func saveContext() {
        do {
            try self.appDelegate.managedObjectContext.save()
            print("Success")
            
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    // MARK: Order Items
    
}