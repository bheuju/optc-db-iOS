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
    
    var characters: [OPTCCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("ScreenSize: \(UIScreen.main.bounds.size)")
        
        tableView.register(RowCell.nib, forCellReuseIdentifier: RowCell.reuseIdentifier)

        Alamofire.request("https://optc-db.github.io/common/data/units.js").responseString { [weak self](response) in
            self?.parseJScript(response.result.value!, objName: "units")
        }
        
        print(UIDevice.current.orientation.isLandscape)
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
        print(result)
        
    }
    
    func verifyCharactersFromRealm() {
        guard let realm = try? Realm() else { return }
        self.characters = DBManager.sharedInstance.getOptcCharacterFromDatabase()
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
