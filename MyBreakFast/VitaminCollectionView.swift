//
//  VitaminCollectionView.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 06/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class VitaminCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var dict: NSDictionary?
    var keysarray: NSMutableArray?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let collectionViewLayoutHorizantal = UICollectionViewFlowLayout()
        collectionViewLayoutHorizantal.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        collectionViewLayoutHorizantal.minimumLineSpacing = 30;
//        collectionViewLayoutHorizantal.minimumInteritemSpacing = 10;

        collectionViewLayoutHorizantal.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        self.setCollectionViewLayout(collectionViewLayoutHorizantal, animated: true)
        
        self.registerNib(UINib.init(nibName: "VitaminCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "VitaminCell")
        self.dataSource = self;//VitaminCollectionViewDataSource();
        self.delegate = self

    }
    
    func setDataDictionary(dataDict: NSDictionary){
        self.dict = dataDict;
        self.keysarray = NSMutableArray(array: dataDict.allKeys);
        self.keysarray!.removeObject("offers");
        self.reloadData();
    }
    
    
    // MARK: UICollectionView delegates and datasources
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return (self.bounds.size.width-50*5)/5;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let width: CGFloat = ((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width-10 : 600.0);
//        let height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 320.0 : 400.0;
    
        return CGSizeMake(50, 70);
    }
        
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = dict?.count ?? 0
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: VitaminCell = (collectionView.dequeueReusableCellWithReuseIdentifier("VitaminCell", forIndexPath: indexPath) as? VitaminCell)!
//        cell.circleView.layer.cornerRadius = 24.0;
//        cell.circleView.layer.borderWidth = 1.0;
//        cell.circleView.layer.borderColor = UIColor(red: 255.0/255.0, green: 0, blue: 0, alpha: 1.0).CGColor;
        let key: String = (self.keysarray![indexPath.row] as? String)!
        cell.label.text = key;
        let vitamin = self.dict?.valueForKey(key) as! String
        if key == "calories"{
            cell.calValue.text = vitamin
        } else {
            cell.calValue.text = vitamin + " g"
        }
        
        return cell;
    }
}

//class VitaminCollectionViewDataSource: NSObject, UICollectionViewDataSource {
//    
//}