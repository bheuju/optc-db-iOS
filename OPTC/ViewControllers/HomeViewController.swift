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

class HomeViewController: UIViewController, Alertable {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let characters = List<Character>()
    var filteredCharacters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CharacterTableViewCell.nib, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        
        guard let realm = try? Realm() else { return }
        let results = realm.objects(Character.self)
        
        if results.count > 0 {
            characters.append(objectsIn: results)
            filteredCharacters.append(contentsOf: characters)
            tableView.reloadData()
            print("Loaded \(characters.count) characters from realm")
        } else {
            reloadCharactersData {
                DispatchQueue.main.async {
                    guard let realm = try? Realm() else { return }
                    let results = realm.objects(Character.self)
                    self.characters.append(objectsIn: results)
                    self.filteredCharacters.append(contentsOf: self.characters)
                    self.tableView.reloadData()
                    print("Loaded \(self.characters.count) characters from syncing")
                }
            }
        }
    }
    
    func reloadCharactersData(_ completion: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            RequestManager().prepareForPlainRequest(with: Router.units) { [weak self] (success, results, _) in
                if success {
                    if let responseString = results as? String {
                        self?.parseJScript(responseString, objName: "units")
                        completion?()
                    }
                }
            }
        }
    }
    
    func parseJScript(_ dump: String, objName: String) {
        
        guard let context = JSContext() else { return }
        //Execute javascript in swift
        //setup with objects
        context.evaluateScript("var window = { \(objName) : null };")
        //add data
        context.evaluateScript(dump)
        //get data
        guard let result = context.objectForKeyedSubscript("window").objectForKeyedSubscript(objName) else { fatalError() }
        if let charactersArray = result.toArray() as NSArray? {
            writeCharacterToRealm(with: charactersArray)
        }
    }
    
    func writeCharacterToRealm(with result: NSArray) {
        self.characters.removeAll()
        guard let realm = try? Realm() else { return }
        let results = realm.objects(Character.self)
        try? realm.write {
            realm.delete(results)
        }
        for case let value as NSArray in result {
            let character = Character()
            character.id = character.incrementID()
            if let name = value[0] as? String {
                character.name = name
            }
            if let type = value[1] as? String {
                character.type = type
            } else if let typeArray = value[1] as? NSArray {
                character.type = typeArray.componentsJoined(by: ",")
            }
            if let optcClass = value[2] as? String {
                character.optcClass = optcClass
            } else if let classArray = value[2] as? NSArray {
                character.optcClass = classArray.componentsJoined(by: ",")
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
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }
    
}

// MARK: - TableView datasource
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return characters.count
        return filteredCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else {
            fatalError("No cell with the identifier \(CharacterTableViewCell.reuseIdentifier)")
        }
        
        let character = filteredCharacters[indexPath.row]
        let cViewModel = CharacterViewModel(character)
        cell.configureTableCell(with: cViewModel)
        
        return cell
    }
}

// MARK: - SearchBar Delegates
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("String: #\(searchText)#")
        if searchText.isEmpty {
            filteredCharacters.append(contentsOf: characters)
        } else {
            filteredCharacters = characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
