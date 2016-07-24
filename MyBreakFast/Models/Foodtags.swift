//
//  Foodtags.swift
//  MyBreakFast
//
//  Created by AUK on 23/07/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class Foodtags: NSObject {
    
    var tagId: String?
    var tagCategory: String?
    var tagName: String?

    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("id") as? NSNumber{
            self.tagId = obj.stringValue
        } else {
            self.tagId = dict.objectForKey("id") as? String;
        }
        
        if let obj = dict.objectForKey("tag_category") as? String{
            self.tagCategory = obj
        }
        
        if let obj = dict.objectForKey("tag_name") as? String{
            self.tagName = obj
        }
    }
}