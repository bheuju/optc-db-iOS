//
//  RealmHelper.swift
//  OPTC
//
//  Created by Prashant on 2/16/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

infix operator <-

/// Object of Realm's RealmOptional type
public func <- <T>(left: RealmOptional<T>, right: Map) {
    var optional: T?
    
    if right.mappingType == .toJSON {
        optional = left.value
    }
    
    optional <- right
    
    if right.mappingType == .fromJSON {
        if let theOptional = optional {
            left.value = theOptional
        }
    }
}
