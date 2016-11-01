//
//  CollectionViewDataProvider.swift
//  NineGagTest
//
//  Created by Ben Fowler on 2/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import UIKit

protocol contentScrollDelegate
{
    func contentViewDidScroll(_ contentView: UIScrollView, contentOffset: CGPoint)
}

class CollectionViewDataProvider: NSObject
{
    internal var data: CellContentDataProvider?
    var contentScrollDelegate: contentScrollDelegate?
    internal let imageCache: NSCache = NSCache<NSString, UIImage>()
}
