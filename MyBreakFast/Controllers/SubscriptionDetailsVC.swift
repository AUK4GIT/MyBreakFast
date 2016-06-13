//
//  SubscriptionDetailsVC.swift
//  MyBreakFast
//
//  Created by AUK on 12/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class SubscriptionDetailsVC: UIViewController {
    @IBOutlet var calendarCollectionView: UICollectionView!
    var calendarModelSource = CalendarModelDataSource();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarCollectionView.delegate = self.calendarModelSource
        self.calendarCollectionView.dataSource = self.calendarModelSource
    }
    
}

class CalendarModelDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override init() {
        super.init();
    }
    
    // MARK: UICollectionView delegates and datasources
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 75.0
        let height: CGFloat = collectionView.bounds.size.height
        
        return CGSizeMake(width, height);
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarcell", forIndexPath: indexPath)
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
}