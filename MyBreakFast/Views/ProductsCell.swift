//
//  ProductsCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 31/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import CoreData

class ProductsCell: UICollectionViewCell {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet var decreaseButton: UIButton!
    @IBOutlet var increaseButton: UIButton!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descButton: UIButton!
    @IBOutlet  var offersTableView: UITableView!
    var selectedCellsIPaths : [NSIndexPath] = []
    var offersArray: [Offer] = []
    var quantity = 0;
    var item: Item?
    weak var orderItem : OrderItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func decreaseAction(sender: UIButton) {
        print("Testing: ",self.orderItem?.itemId);

        if self.quantity == 0{
            return
        } else {
            self.quantity -= 1;
        }
        self.orderItem?.quantity = String(self.quantity);
        self.orderItem?.itemPrice = String(self.quantity * Int((self.item?.price)!)!)
        self.quantityLabel.text = String(self.quantity)
        
        sender.sendAction(#selector(UserOrderDetails.updateCartToolbar), to: nil, forEvent: nil)
    }
    
    @IBAction func increaseAction(sender: UIButton) {
        print("Testing: ",self.orderItem?.itemId);

        if self.quantity == Int((self.item?.maxlimit)!)!{
            UIAlertView(title: "First Eat", message: "Maximum order limit reached for the item.", delegate: nil, cancelButtonTitle: "OK").show()
            return
        } else {
            self.quantity += 1;
        }
        self.orderItem?.quantity = String(self.quantity);
        self.orderItem?.itemPrice = String(self.quantity * Int((self.item?.price)!)!)
        self.quantityLabel.text = String(self.quantity)
        sender.sendAction(#selector(UserOrderDetails.updateCartToolbar), to: nil, forEvent: nil)
    }
    
    func setItemContent() {
        let url: String? = self.item!.imgurl
        self.imageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "menu_logo"), completed: nil)
        self.nameLabel.text = self.item!.itemname
        self.quantityLabel.text = "0"
        if let quan = self.orderItem?.quantity {
            self.quantity = Int(quan)!
        } else {
            self.quantity = 0
        }
        self.quantityLabel.text = String(self.quantity)
        self.priceLabel.text = "₹ "+self.item!.price!

        switch self.item!.category!{
        case "0" :
            self.descButton.setImage(UIImage(named: "spinch.png"), forState: .Normal);
            break;
        case "2" :
            self.descButton.setImage(UIImage(named: "nonveg.png"), forState: .Normal);
            
            break;
        case "1" :
            self.descButton.setImage(UIImage(named: "egg.png"), forState: .Normal);
            
            break;
        default:
            break;
        }
        
        if let offers = self.item?.fooddetails?.offers {
            self.offersArray = offers.allObjects as NSArray as! [Offer]
            self.offersArray = self.offersArray.filter({ $0.offeroftheday == "1" })

            self.offersTableView.reloadData()
        }
        self.orderItem?.itemId = self.item?.itemid
        self.imageView.layer.masksToBounds = true;
        self.imageView.layer.cornerRadius = 20.0
    }
    
    // MARK: UITableViewDelegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.offersArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:OffersCell = tableView.dequeueReusableCellWithIdentifier("offerscell")! as! OffersCell
        let offer = self.offersArray[indexPath.row] 
        cell.offerNameLbl.text = offer.offername;
        cell.offerPrice.text = offer.price!+" ₹";
        if self.selectedCellsIPaths.contains(indexPath) {
            cell.checkmarkImg.image = UIImage(named: "checkmark")
        }  else {
            cell.checkmarkImg.image = nil
        }
        cell.checkmarkImg.layer.masksToBounds = true;
        cell.checkmarkImg.layer.borderColor = UIColor.blackColor().CGColor
        cell.checkmarkImg.layer.borderWidth = 1.0
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let offersCell = tableView.cellForRowAtIndexPath(indexPath)! as! OffersCell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if self.selectedCellsIPaths.contains(indexPath) {
            offersCell.checkmarkImg.image = nil
            self.selectedCellsIPaths.removeAtIndex(self.selectedCellsIPaths.indexOf(indexPath)!)
            Helper.sharedInstance.order?.offers.removeAtIndex((Helper.sharedInstance.order?.offers.indexOf(self.offersArray[indexPath.row] ))!)

        }  else {
            self.selectedCellsIPaths.append(indexPath)
            offersCell.checkmarkImg.image = UIImage(named: "checkmark")
            Helper.sharedInstance.order?.offers.append(self.offersArray[indexPath.row] )
        }
        
        
        UIApplication.sharedApplication().sendAction(#selector(UserOrderDetails.updateCartToolbar), to: nil, from: self, forEvent: nil);
        
    }
    
    
}