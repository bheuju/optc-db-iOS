//
//  ViewController.swift
//  OPTC
//
//  Created by Prashant on 2/16/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import JavaScriptCore

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let characters = List<OPTCCharacter>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RowCell.nib, forCellReuseIdentifier: RowCell.reuseIdentifier)
        RequestManager().prepareForPlainRequest(with: Router.units) { [weak self] (success, results, _) in
            if let wSelf = self {
                if success {
                    if let responseString = results as? String {
                        wSelf.parseJScript(responseString, objName: "units")
                    }
                } else {
                }
            }
        }
        //verifyCharactersFromRealm()
        tableView.reloadData()
    }
    
    func parseJScript(_ dump: String, objName: String) {
        
        guard let context = JSContext() else { return }
        //Execute javascript in swift
        //setup with objects
        context.evaluateScript("var window = { \(objName) : null };")
        //add data
        //context.evaluateScript("window.\(objName) = 5;")
        context.evaluateScript(dump)
        //get data
        guard let result = context.objectForKeyedSubscript("window").objectForKeyedSubscript(objName) else { fatalError() }
        if let charactersArray = result.toArray() as NSArray? {
            writeCharactersToDatabase(with: charactersArray, completion: {
                guard let realm = try? Realm() else { return }
                let charactersFromRealm = realm.objects(OPTCCharacter.self)
                self.characters.append(objectsIn: charactersFromRealm)
                self.tableView.reloadData()
            })
        }
    }
    
    func writeCharactersToDatabase(with result: NSArray, completion: () -> Swift.Void ) {
        guard let realm = try? Realm() else { return }
        let results = realm.objects(OPTCCharacter.self)
        try? realm.write {
            realm.delete(results)
        }
        for case let value as NSArray in result {
            let character = OPTCCharacter()
            character.id = character.incrementID()
            if let name = value[0] as? String {
                character.name = name
            }
            if let type = value[1] as? String {
                character.type = type
            } else if let typeArray = value[1] as? NSArray {
                character.type = typeArray.componentsJoined(by: ", ")
            }
            if let optcClass = value[2] as? String {
                character.optcClass = optcClass
            } else if let classArray = value[2] as? NSArray {
                character.optcClass = classArray.componentsJoined(by: ", ")
            }
            character.hp.value = value[12] as? Int
            character.atk.value = value[13] as? Int
            character.rcv.value = value[14] as? Int
            character.slot.value = value[6] as? Int
            if let stars = value[3] as? Int {
                character.stars = String(describing: stars)
            } else if let starString = value[3] as? String {
                character.stars = starString
            }
            character.cmb.value = value[5] as? Int
            character.maxEHP.value = value[8] as? Int
            try? realm.write {
                realm.add(character)
            }
        }
        completion()
    }
    
//    func verifyCharactersFromRealm() {
//        guard let realm = try? Realm() else { return }
//        self.characters = DBManager.sharedInstance.getOptcCharacterFromDatabase()
//        if let charactersFromRealm = try? realm.objects(OPTCCharacter.self).map { $0 } {
//            for character in characters {
//                if !(charactersFromRealm.contains(where: { $0.id == character.id})) {
//                    try? realm.write {
//                        realm.add(character)
//                    }
//                }
//            }
//        }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(characters.count)
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.reuseIdentifier, for: indexPath) as? RowCell else {
            fatalError("No cell with the identifier")
        }
        cell.configureTableCell(withCharacter: characters[indexPath.row])
        return cell
    }
}
