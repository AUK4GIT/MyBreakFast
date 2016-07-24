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
    optional func didFilterWithTag(searchTags: Foodtags);
}
class MultiSelectFilterDS: NSObject, UICollectionViewDelegate, UICollectionViewDataSource{
    var filtersArray: [Foodtags] = []
    weak var delegate: FilterProtocol?
    var filters: Set<String> = []

    override init() {
        
    }
    //Mark: UICollectionViewDelegates
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(75, 44);
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filtersArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MultiSelCell = (collectionView.dequeueReusableCellWithReuseIdentifier("MultiSelCell", forIndexPath: indexPath) as? MultiSelCell)!
        let foodTag = self.filtersArray[indexPath.row]
        cell.celllabel?.text = foodTag.tagName
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
   
        let foodtag: Foodtags = self.filtersArray[indexPath.row]
        self.delegate?.didFilterWithTag!(foodtag)

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        self.filters.remove((self.filtersArray[indexPath.row]["filtervalue"])!)
        //        }
//        self.delegate?.didFilterWithTag!(self.filters)
    }
}