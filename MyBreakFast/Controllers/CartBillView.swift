//
//  CartBillView.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 02/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class CartBillView: UITableViewHeaderFooterView {
    @IBOutlet var tableView: UITableView!
    
    override func awakeFromNib() {
        self.tableView.registerNib(UINib(nibName: "AddOnsTableCell", bundle: nil), forCellReuseIdentifier: "AddOnsCell")
    }
    
    // MARK: UITableViewDelegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("AddOnsCell")! as UITableViewCell
        return cell
    }

}