//
//  ContentSelectionManager.swift
//  NineGagTest
//
//  Created by Ben Fowler on 29/10/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation

@objc protocol ContentSelectedDelegate: NSObjectProtocol
{
    func selectContent(forIndex: Int)
}

class ContentSelectionManager
{
    private var contentSelectionDelegates: [ContentSelectedDelegate] = []
    
    func contentSelectionDelegate(add contentSelectionDelegate: ContentSelectedDelegate) {
        contentSelectionDelegates.append(contentSelectionDelegate)
    }
    
    func contentSelectionDelegate(remove contentSelectionDelegate: ContentSelectedDelegate) {
    contentSelectionDelegates = contentSelectionDelegates.filter {!$0.isEqual(contentSelectionDelegate)}
    }

    func contentSelected(atIndex: Int) {
        for contentSelectionDelegate in contentSelectionDelegates {
            contentSelectionDelegate.selectContent(forIndex: atIndex)
        }
    }
}
