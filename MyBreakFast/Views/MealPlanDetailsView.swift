//
//  MealPlanDetailsView.swift
//  MyBreakFast
//
//  Created by AUK on 26/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MealPlanDetailsView: UIView {
    
    @IBOutlet var descrMaskView: UIView!
    @IBOutlet var descrBGView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var bestSuitedFor: UILabel!
    @IBOutlet var descrLbl: UILabel!
    @IBOutlet var caloriesLbl: UILabel!
    @IBOutlet var fibreLbl: UILabel!
    @IBOutlet var carbohydratesLbl: UILabel!
    @IBOutlet var proteinsLbl: UILabel!
    @IBOutlet var fatLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.caloriesLbl.layer.cornerRadius = 2.0;
        self.fibreLbl.layer.cornerRadius = 2.0;
        self.carbohydratesLbl.layer.cornerRadius = 2.0;
        self.proteinsLbl.layer.cornerRadius = 2.0;
        self.fatLbl.layer.cornerRadius = 2.0;
        
        self.fatLbl.layer.borderColor = UIColor.whiteColor().CGColor;
        self.fatLbl.layer.borderWidth = 1.0;
        
        self.caloriesLbl.layer.borderColor = UIColor.whiteColor().CGColor;
        self.caloriesLbl.layer.borderWidth = 1.0;
        
        self.carbohydratesLbl.layer.borderColor = UIColor.whiteColor().CGColor;
        self.carbohydratesLbl.layer.borderWidth = 1.0;
        
        self.fibreLbl.layer.borderColor = UIColor.whiteColor().CGColor;
        self.fibreLbl.layer.borderWidth = 1.0;
        
        self.proteinsLbl.layer.borderColor = UIColor.whiteColor().CGColor;
        self.proteinsLbl.layer.borderWidth = 1.0;

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.descrBGView.hidden {
            self.showDescription()
        } else {
            self.hideDescription();
        }
    }
    func setMealDetails(mealObj: AnyObject?){
        self.hideDescription()
        if let meal = mealObj as? PlannedMeals{
            var url: String? = meal.imgURL
            url = Constants.API.SubscrImgBaseURL+(url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))!
            self.imgView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "menu_logo"), completed: nil)
            self.nameLbl.text = meal.name
            self.descrLbl.text = meal.mealDescription
            
            self.caloriesLbl.text = meal.calories!+" "+"Cal."
            self.carbohydratesLbl.text = meal.carbohydrates!+" "+"Carb."
            self.proteinsLbl.text = meal.proteins!+" "+"Protein"
            self.fibreLbl.text = meal.fibre!+" "+"Fibre"
            self.fatLbl.text = meal.fats!+" "+"Fat"
            self.bestSuitedFor.text = meal.bestSuitedfor
        }
    }
    
    func showDescription(){
        self.descrBGView.hidden = false
        self.descrBGView.alpha = 0.0;
        self.descrMaskView.hidden = false
        self.descrMaskView.alpha = 0.0;
        UIView.animateWithDuration(0.3, animations: {
            self.descrBGView.alpha = 1.0;
            self.descrMaskView.alpha = 0.3;
            }, completion: { (completion) in
        })
    }
    
    func hideDescription(){
        UIView.animateWithDuration(0.3, animations: {
            self.descrBGView.alpha = 0.0;
            self.descrMaskView.alpha = 0.0;
            }, completion: { (completion) in
                self.descrBGView.hidden = true
                self.descrMaskView.hidden = true
        })
    }
}