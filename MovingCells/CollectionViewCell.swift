//
//  CollectionViewCell.swift
//  MovingCells
//
//  Created by Ozgur Vatansever on 4/24/16.
//  Copyright © 2016 Ozgur Vatansever. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  let imageView = UIImageView(frame: CGRectZero)
  
  private func configureUI() {
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 5.0
    imageView.contentMode = UIViewContentMode.ScaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false    

    contentView.addSubview(imageView)
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[imageView]|",
      options: NSLayoutFormatOptions.AlignAllCenterY,
      metrics: nil,
      views: ["imageView": imageView])
    )
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[imageView]|",
      options: NSLayoutFormatOptions.AlignAllCenterX,
      metrics: nil,
      views: ["imageView": imageView])
    )
  }
  
  override func snapshotViewAfterScreenUpdates(afterUpdates: Bool) -> UIView {
    let snapshot = super.snapshotViewAfterScreenUpdates(afterUpdates)
    snapshot.center = center
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
