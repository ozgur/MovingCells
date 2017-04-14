//
//  CollectionViewCell.swift
//  MovingCells
//
//  Created by Ozgur Vatansever on 4/24/16.
//  Copyright © 2016 Ozgur Vatansever. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  let imageView = UIImageView(frame: CGRect.zero)
  
  fileprivate func configureUI() {
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 5.0
    imageView.contentMode = UIViewContentMode.scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false    

    contentView.addSubview(imageView)
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[imageView]|",
      options: NSLayoutFormatOptions.alignAllCenterY,
      metrics: nil,
      views: ["imageView": imageView])
    )
    contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[imageView]|",
      options: NSLayoutFormatOptions.alignAllCenterX,
      metrics: nil,
      views: ["imageView": imageView])
    )
  }
  
  override func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
    let snapshot = super.snapshotView(afterScreenUpdates: afterUpdates)

    snapshot?.layer.masksToBounds = false
    snapshot?.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
    snapshot?.layer.shadowRadius = 5.0
    snapshot?.layer.shadowOpacity = 0.4
    snapshot?.center = center
    
    return snapshot
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureUI()
  }
}
