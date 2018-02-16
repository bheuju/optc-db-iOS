//
//  ViewController.swift
//  OPTC
//
//  Created by Prashant on 2/16/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        verifyCharactersFromRealm()
    }
    
    func verifyCharactersFromRealm() {
        guard let realm = try? Realm() else { return }
        let characters = DBManager.sharedInstance.getOptcCharacterFromDatabase()
        if let charactersFromRealm = try? realm.objects(OPTCCharacter.self).map { $0 } {
            for character in characters {
                if !(charactersFromRealm.contains(where: { $0.id == character.id})) {
                    try? realm.write {
                        realm.add(character)
                    }
                }
            }
        }
    }

}
