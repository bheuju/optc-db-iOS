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
        let characters = DBManager.sharedInstance.getOptcCharacterFromDatabase()
        let realm = try! Realm()
        for character in characters {
            try! realm.write {
                realm.add(character)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

