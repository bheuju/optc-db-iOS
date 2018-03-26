//
//  CharacterViewModel.swift
//  OPTC
//
//  Created by Mac on 3/26/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation

class CharacterViewModel {
    
    var id: Int {
        return character.id
    }
    
    var imageUrl: URL {
        let id = String(format: "%04d", arguments: [character.id])
        let imageUrl = URL(string: "http://onepiece-treasurecruise.com/wp-content/uploads/f\(id).png")!
        return imageUrl
    }
    
    var name: String {
        return character.name
    }
    
    var type: String {
        return character.type
    }
    
    var rarity: String {
        return character.stars
    }
    
    var hp: Int {
        return character.hp.value!
    }
    var atk: Int {
        return character.atk.value!
    }
    
    var rcv: Int {
        return character.rcv.value!
    }
    
    // MARK: - Injections
    var character: Character
    
    init(_ character: Character) {
        self.character = character
    }
}
