//
//  DBManager.swift
//  OPTC
//
//  Created by Prashant on 2/16/18.
//  Copyright © 2018 Prashant. All rights reserved.
//

import Foundation
import FMDB
import ObjectMapper

class DBManager{
    
    var database : FMDatabase = FMDatabase()
    //let queue : FMDatabaseQueue?
    static let sharedInstance = DBManager()
    let databaseName : String = "OPTC.db"
    
    init() {
        
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(databaseName)
        print(fileURL)
        self.database = FMDatabase(url: fileURL)
        
        database.open()
        
        let query1 : String = "CREATE TABLE IF NOT EXISTS OPTC (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT, optcClass TEXT, hp INT, atk INT, rcv INT, cost INT, slots INT, stars INT, maxEXP INT)"
        
        do{
            try database.executeUpdate(query1, values: nil)
        } catch {
            print("Unable to create table")
        }
        database.close()
    }
    
}

extension DBManager {
    
    func getOptcCharacterFromDatabase() -> [OPTCCharacter] {
        
        var characters : [OPTCCharacter] = [OPTCCharacter]()
        database.open()
        do{
            let results = try database.executeQuery("Select * from OPTC", values: nil)
            while results.next() {
                if let character = Mapper<OPTCCharacter>().map(JSONObject: results.resultDictionary) {
                    characters.append(character)
                }
            }
            
        } catch{
            print("Error retrieving characters from database")
        }
        database.close()
        return characters
    }
}
