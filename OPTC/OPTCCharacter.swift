//
//  OPTCCharacter.swift
//  OPTC
//
//  Created by Prashant on 2/16/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class OPTCCharacter: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var type = ""
    @objc dynamic var optcClass = ""
    let hp = RealmOptional<Int>()
    let atk = RealmOptional<Int>()
    let rcv = RealmOptional<Int>()
    @objc dynamic var slot = 0
    @objc dynamic var stars = 0
    @objc dynamic var cmb = 0
    @objc dynamic var maxEHP = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        type        <- map["type"]
        optcClass   <- map["optcClass"]
        hp          <- map["hp"]
        atk         <- map["atk"]
        rcv         <- map["rcv"]
        slot        <- map["slot"]
        stars       <- map["stars"]
        cmb         <- map["cmb"]
        maxEHP      <- map["maxEHP"]
    }
    
}
