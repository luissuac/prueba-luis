//
//  DBHelper.swift
//  Pokedex-Luis
//
//  Created by LUIS SUAREZ on 15/11/20.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "PokedexDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS POKEDEX(Id TEXT,name TEXT, image TEXT, url TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("POKEDEX table created.")
            } else {
                print("POKEDEX table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:String, name:String, image:String, url:String)
    {
   
        let insertStatementString = "INSERT INTO POKEDEX (id, name, image, url) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (image as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (url as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Pokemon] {
        let queryStatementString = "SELECT * FROM POKEDEX ;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Pokemon] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                //let user = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                psns.append(Pokemon(id: String(cString: sqlite3_column_text(queryStatement, 0)),
                                    name: String(cString: sqlite3_column_text(queryStatement, 1)),
                                    image: String(cString: sqlite3_column_text(queryStatement, 2)),
                                    url: String(cString: sqlite3_column_text(queryStatement, 3))
                                )
                            )
                //print("Query Result:")
                //dump(psns)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)

        return psns
    }
    
    func readforId(Id:String) -> [Pokemon] {
        let queryStatementString = "SELECT * FROM POKEDEX where id = '\(Id)';"
        var queryStatement: OpaquePointer? = nil
        var psns : [Pokemon] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                //let user = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                psns.append(Pokemon(id: String(cString: sqlite3_column_text(queryStatement, 0)),
                                    name: String(cString: sqlite3_column_text(queryStatement, 1)),
                                    image: String(cString: sqlite3_column_text(queryStatement, 2)),
                                    url: String(cString: sqlite3_column_text(queryStatement, 3))
                                )
                            )
                //print("Query Result:")
                //dump(psns)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)

        return psns
    }
    
    func update(updateStatementString:String) {
      var updateStatement: OpaquePointer?
      if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
        if sqlite3_step(updateStatement) == SQLITE_DONE {
          print("\nSuccessfully updated row.")
        } else {
          print("\nCould not update row.")
        }
      } else {
        print("\nUPDATE statement is not prepared")
      }
      sqlite3_finalize(updateStatement)
    }
    
    
}
