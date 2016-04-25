# MovingCells
This example project aims to get the same effect of what UIKit does when rearranging cells.

The following methods were introduced as of iOS9 so are unavailable for apps written in iOS7.x and iOS8.x 

```swift
    @available(iOS 9.0, *)
    optional public func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool

    @available(iOS 9.0, *)
    optional public func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    
    @available(iOS 9.0, *)
    public func beginInteractiveMovementForItemAtIndexPath(indexPath: NSIndexPath) -> Bool // returns NO if reordering was prevented from beginning - otherwise YES

    @available(iOS 9.0, *)
    public func updateInteractiveMovementTargetPosition(targetPosition: CGPoint)

    @available(iOS 9.0, *)
    public func endInteractiveMovement()

    @available(iOS 9.0, *)
    public func cancelInteractiveMovement()
```

which forces us to find a way to rearranage cells in a collection view with a smooth animation. 

![Screenshot of Rearranging cells](http://i.stack.imgur.com/AQaL6.gif)

Implemented based on the following Stackoverflow question:
http://stackoverflow.com/questions/36821289/reordering-uicollectionview-in-ios7
