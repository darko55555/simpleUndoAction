//
//  ItemsStack.swift
//  stackDeleteUndo
//
//  Created by Darko Dujmovic on 24/05/2019.
//  Copyright © 2019 Darko Dujmovic. All rights reserved.
//

import Foundation

struct DeletedItemsStack {
    fileprivate var array:[CustomObject] = []
    
    mutating func push(_ element: CustomObject){
        array.append(element)
    }
    
    mutating func pop()->CustomObject?{
        return array.popLast()
    }
    
}


struct CustomObject{
    let name:String
    let index:Int
}
