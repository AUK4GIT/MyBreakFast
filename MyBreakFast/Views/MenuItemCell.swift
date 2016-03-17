//
//  MenuItemCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class MenuItemCell: UICollectionViewCell {
    
    @IBOutlet var descButton: UIButton!
    @IBOutlet var descButtonView: UIView!
    @IBOutlet var cellBGView: UIView!
    @IBOutlet var cellBlackTape: UIView!
    @IBOutlet var decreaseButton: UIButton!
    @IBOutlet var increaseButton: UIButton!
    @IBOutlet var remainingLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cellDescriptionView: UIView!
    @IBOutlet  var vitaminQuantity: VitaminCollectionView!
    @IBOutlet  var productDescription: UILabel!
    @IBOutlet  var bestsuitedfor: UILabel!
    weak var orderItem : OrderItem?
    var quantity = 0;
    var item: Item?
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
            }
    
//    override var selected: Bool {
//        get {
//            return super.selected
//        }
//        set {
//            if newValue {
//                self.descButtonTapped(nil);
//            } else if newValue == false {
//            }
//        }
//    }

    @IBAction func decreaseAction(sender: UIButton) {
        print("Testing: ",self.orderItem?.itemId);
        if self.quantity == 0{
            return
        } else {
            --self.quantity;
        }
        self.orderItem?.quantity = String(self.quantity);
        self.orderItem?.itemPrice = String(self.quantity * Int((self.item?.price)!)!)
        self.quantityLabel.text = String(self.quantity)
        sender.sendAction("updateToolbar", to: nil, forEvent: nil)
    }
    
    @IBAction func increaseAction(sender: UIButton) {
        print("Testing: ",self.orderItem?.itemId);
        if self.quantity == Int((self.item?.maxlimit)!)!{
            UIAlertView(title: "First Eat", message: "Maximum order limit reached for the item.", delegate: nil, cancelButtonTitle: "OK").show()
            return
        } else {
            ++self.quantity;
        }
        self.orderItem?.quantity = String(self.quantity);
        self.orderItem?.itemPrice = String(self.quantity * Int((self.item?.price)!)!)
        self.quantityLabel.text = String(self.quantity)
        sender.sendAction("updateToolbar", to: nil, forEvent: nil)

    }
    
    func setItemContent() {       
        let url: String? = self.item!.imgurl
        (url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))
        self.imageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "menu_logo"), completed: nil)
        self.nameLabel.text = self.item!.itemname
        self.amountLabel.text = "₹ \(self.item!.price!)"
        self.quantityLabel.text = "0"
        self.productDescription.text = self.item!.itemdescription
        self.bestsuitedfor.text = self.item!.bestsuitedfor
        self.setFoodDetails(self.item!.fooddetails!)
        if let quan = self.orderItem?.quantity {
            self.quantity = Int(quan)!
        } else {
            self.quantity = 0
        }
        
        self.quantityLabel.text = String(self.quantity)

        switch self.item!.category!{
        case "0" :
            self.descButton.setImage(UIImage(named: "spinch-info.png"), forState: .Normal);
            break;
        case "2" :
            self.descButton.setImage(UIImage(named: "nonveg-info.png"), forState: .Normal);
            
            break;
        case "1" :
            self.descButton.setImage(UIImage(named: "egg-info.png"), forState: .Normal);
            
            break;
        default:
            break;
            
        }
        
        if self.item!.instock == "Yes" {
            self.remainingLabel.text = "Available"
            self.increaseButton.enabled = true;
            self.decreaseButton.enabled = true;
            self.cellBlackTape.hidden = true;
        } else {
            self.remainingLabel.text = "Sold out"
            self.increaseButton.enabled = false;
            self.decreaseButton.enabled = false;
            self.cellBlackTape.hidden = false;
        }
        
        self.orderItem?.itemId = self.item?.itemid
        
        //self.cellBGView.layer.masksToBounds = false
        //self.cellBGView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        //self.cellBGView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        //self.cellBGView.layer.shadowOpacity = 0.8;

    }
    
    func setFoodDetails(foodDetails: Fooddetails) {
        let arr: NSArray = Array(foodDetails.entity.attributesByName.keys);
//        let array: NSMutableArray = NSMutableArray(array: arr)
//        array.removeObject("offers");
        let dict: NSDictionary = foodDetails.dictionaryWithValuesForKeys(arr as! [String]);
        vitaminQuantity.setDataDictionary(dict);
    }
    
    @IBAction func descButtonTapped(sender: AnyObject?) {
        
        if(self.cellDescriptionView.hidden == false){
            self.hideDescription(sender);
            return;
        }
        
        self.cellDescriptionView.alpha = 0.0;
        self.cellDescriptionView.hidden = false;

        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            self.descButtonView.alpha = 0.0;
//            self.cellBlackTape.alpha = 0.0;
            self.cellDescriptionView.alpha = 1.0;
            }) { (Bool) -> Void in
                self.descButtonView.hidden = true;
//                self.cellBlackTape.hidden = true;
        }
        
        //        self.performSelector("hideDescription:", withObject: nil, afterDelay: 3.0)
    }
    
    @IBAction func hideDescription(sender: AnyObject?) {

        self.descButtonView.hidden = false;
//        self.cellBlackTape.hidden = false;
        self.descButtonView.alpha = 0.0;
//        self.cellBlackTape.alpha = 0.0;
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            self.descButtonView.alpha = 1.0;
//            self.cellBlackTape.alpha = 1.0;
            
            self.cellDescriptionView.alpha = 0.0;
            }) { (Bool) -> Void in
                self.cellDescriptionView.hidden = true;
        }
    }

    @IBAction func makeItemFavourite(sender: AnyObject) {
        Helper.sharedInstance.uploadFavouriteMenu((self.item?.itemid)!) { (response) -> () in
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        print(touch.locationInView(self),"    ",touch.locationInView(self.imageView))
        if CGRectContainsPoint(self.imageView.frame, touch.locationInView(self.imageView)){
            self.descButtonTapped(nil);
        }
    }

}
