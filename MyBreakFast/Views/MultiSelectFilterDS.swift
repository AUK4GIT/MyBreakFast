//
//  MultiSelectFilterDS.swift
//  MyBreakFast
//
//  Created by AUK on 04/07/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

@objc protocol FilterProtocol : class
{
    optional func didFilterWithString(searchString: Set<String>);
}
class MultiSelectFilterDS: NSObject, UICollectionViewDelegate, UICollectionViewDataSource{
    var filtersArray = Constants.StaticContent.Filters
    weak var delegate: FilterProtocol?
    var filters: Set<String> = []

    override init() {
        
    }
    //Mark: UICollectionViewDelegates
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(100, 44);
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filtersArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MultiSelCell = (collectionView.dequeueReusableCellWithReuseIdentifier("MultiSelCell", forIndexPath: indexPath) as? MultiSelCell)!
        
        cell.celllabel?.text = self.filtersArray[indexPath.row]["filterName"]
//        cell.imageView?.image = UIImage(named: (self.filtersArray[indexPath.row]["imageName"])!);
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.filters.insert((self.filtersArray[indexPath.row]["filtervalue"])!)
        self.delegate?.didFilterWithString!(self.filters)

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        self.filters.remove((self.filtersArray[indexPath.row]["filtervalue"])!)
        //        }
        self.delegate?.didFilterWithString!(self.filters)
        
    }
}