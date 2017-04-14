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
  
  fileprivate var snapshotView: UIView?
  fileprivate var snapshotIndexPath: IndexPath?
  fileprivate var snapshotPanPoint: CGPoint?
  
  fileprivate func configureUI() {
    collectionViewFlowLayout.minimumInteritemSpacing = 10.0
    collectionViewFlowLayout.minimumLineSpacing = 10.0
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
    collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    collectionView?.backgroundColor = .white

    let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
    gestureRecognizer.minimumPressDuration = 0.2
    collectionView!.addGestureRecognizer(gestureRecognizer)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Images"
    edgesForExtendedLayout = UIRectEdge()
    collectionView?.backgroundColor = .white
    
    configureUI()
  }
  
  func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
    let location = recognizer.location(in: collectionView)
    let indexPath = collectionView?.indexPathForItem(at: location)
    
    switch recognizer.state {
    case UIGestureRecognizerState.began:
      guard let indexPath = indexPath else { return }
      
      let cell = cellForRow(at: indexPath)
      snapshotView = cell.snapshotView(afterScreenUpdates: true)
      collectionView!.addSubview(snapshotView!)
      cell.contentView.alpha = 0.0
      
      UIView.animate(withDuration: 0.2, animations: {
        self.snapshotView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.snapshotView?.alpha = 0.9
      }) 
      
      snapshotPanPoint = location
      snapshotIndexPath = indexPath
    case UIGestureRecognizerState.changed:
      guard let snapshotPanPoint = snapshotPanPoint else { return }
      
      let translation = CGPoint(x: location.x - snapshotPanPoint.x, y: location.y - snapshotPanPoint.y)
      snapshotView?.center.x += translation.x
      snapshotView?.center.y += translation.y
      self.snapshotPanPoint = location
      
      guard let indexPath = indexPath else { return }
      
      images.exchangeImageAtIndex(snapshotIndexPath!.item, withImageAtIndex: indexPath.item)
      collectionView!.moveItem(at: snapshotIndexPath!, to: indexPath)
      snapshotIndexPath = indexPath
    default:
      guard let snapshotIndexPath = snapshotIndexPath else { return }
      let cell = cellForRow(at: snapshotIndexPath)
      UIView.animate(
        withDuration: 0.2,
        animations: {
          self.snapshotView?.center = cell.center
          self.snapshotView?.transform = CGAffineTransform.identity
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
  
  fileprivate func cellForRow(at indexPath: IndexPath) -> CollectionViewCell {
    return collectionView?.cellForItem(at: indexPath) as! CollectionViewCell
  }
}

// MARK: UICollectionViewDelegate

extension CollectionViewController {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    
    let totalInteritemSpacing = (3 * collectionViewFlowLayout.minimumInteritemSpacing)
    let totalSectionInset = collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right
    let size = (collectionView.bounds.width - (totalSectionInset + totalInteritemSpacing)) / 4
    
    return CGSize(width: size, height: size)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Image selected at indexPath: \(indexPath)")
  }
}

// MARK: UICollectionViewDataSource

extension CollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
      if let cell = cell as? CollectionViewCell {
        cell.imageView.image = images[indexPath.item]
      }
      return cell
  }
}
