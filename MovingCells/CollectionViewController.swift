//
//  CollectionViewController.swift
//  MovingCells
//
//  Created by Ozgur Vatansever on 4/24/16.
//  Copyright © 2016 Ozgur Vatansever. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
  
  var images = ImageDataSource()
  
  var collectionViewFlowLayout: UICollectionViewFlowLayout! {
    return collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  private var snapshotView: UIView?
  private var snapshotIndexPath: NSIndexPath?
  private var snapshotPanPoint: CGPoint?
  
  private func configureUI() {
    collectionViewFlowLayout.minimumInteritemSpacing = 10.0
    collectionViewFlowLayout.minimumLineSpacing = 10.0
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    collectionView?.backgroundColor = .whiteColor()

    let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
    gestureRecognizer.minimumPressDuration = 0.2
    collectionView!.addGestureRecognizer(gestureRecognizer)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Images"
    edgesForExtendedLayout = .None
    view.backgroundColor = .whiteColor()
    
    configureUI()
  }
  
  func longPressRecognized(recognizer: UILongPressGestureRecognizer) {
    let location = recognizer.locationInView(collectionView)
    let indexPath = collectionView?.indexPathForItemAtPoint(location)
    
    switch recognizer.state {
    case UIGestureRecognizerState.Began:
      guard let indexPath = indexPath else { return }
      
      let cell = cellForRowAtIndexPath(indexPath)
      snapshotView = cell.snapshotViewAfterScreenUpdates(true)
      collectionView!.addSubview(snapshotView!)
      cell.contentView.alpha = 0.0
      
      UIView.animateWithDuration(0.2) {
        self.snapshotView?.transform = CGAffineTransformMakeScale(1.1, 1.1)
        self.snapshotView?.alpha = 0.9
      }
      
      snapshotPanPoint = location
      snapshotIndexPath = indexPath
    case UIGestureRecognizerState.Changed:
      guard let snapshotPanPoint = snapshotPanPoint else { return }
      
      let translation = CGPointMake(location.x - snapshotPanPoint.x, location.y - snapshotPanPoint.y)
      snapshotView?.center.x += translation.x
      snapshotView?.center.y += translation.y
      self.snapshotPanPoint = location
      
      guard let indexPath = indexPath else { return }
      
      images.exchangeImageAtIndex(snapshotIndexPath!.item, withImageAtIndex: indexPath.item)
      collectionView!.moveItemAtIndexPath(snapshotIndexPath!, toIndexPath: indexPath)
      snapshotIndexPath = indexPath
    default:
      guard let snapshotIndexPath = snapshotIndexPath else { return }
      let cell = cellForRowAtIndexPath(snapshotIndexPath)
      UIView.animateWithDuration(
        0.2,
        animations: {
          self.snapshotView?.center = cell.center
          self.snapshotView?.transform = CGAffineTransformIdentity
          self.snapshotView?.alpha = 1.0
        },
        completion: { finished in
          cell.contentView.alpha = 1.0
          self.snapshotView?.removeFromSuperview()
          self.snapshotView = nil
      })
      self.snapshotIndexPath = nil
      self.snapshotPanPoint = nil
    }
  }
}


// MARK: Helpers

extension CollectionViewController {
  
  private func cellForRowAtIndexPath(indexPath: NSIndexPath) -> CollectionViewCell! {
    return collectionView?.cellForItemAtIndexPath(indexPath) as? CollectionViewCell
  }
}

// MARK: UICollectionViewDelegate

extension CollectionViewController {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
    let totalInteritemSpacing = (3 * collectionViewFlowLayout.minimumInteritemSpacing)
    let totalSectionInset = collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right
    let size = (CGRectGetWidth(collectionView.bounds) - (totalSectionInset + totalInteritemSpacing)) / 4
    
    return CGSize(width: size, height: size)
  }
  
  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    print("Image selected at indexPath: \(indexPath)")
  }
}

// MARK: UICollectionViewDataSource

extension CollectionViewController {
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath)
    -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
      if let cell = cell as? CollectionViewCell {
        cell.imageView.image = images[indexPath.item]
      }
      return cell
  }
}
