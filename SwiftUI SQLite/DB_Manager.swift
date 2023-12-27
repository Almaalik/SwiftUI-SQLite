//
//  DB_Manager.swift
//  SQLite SwiftUI
//
//  Created by DB-MBP-012 on 25/12/23.
//

import Foundation
import SQLite

class DB_Manager {
    
    //SQlite instance
    private var db: Connection!
    //Table Instance
    private var users: Table!
    //Columns instance of table
    private var id: Expression<Int64>!
    private var name: Expression<String>!
    private var email: Expression<String>!
    private var age: Expression<Int64>!
    
    //Constructor of this class
    init() {
        //Exception handling
        do {
            //path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            //creating database connection
            db = try Connection("\(path)/my_users.sqlite3")
            //creating table object
            users = Table("users")
            //creating instance of each column
            id = Expression<Int64>("id")
            name = Expression<String>("name")
            email = Expression<String>("email")
            age = Expression<Int64>("age")
            
            //Check if the users table is already created
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                //if not then create the table
                try db.run(users.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(email, unique: true)
                    t.column(age)
                })
                //set the value to true so then it will not create a table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            //show error message if any
            print("\(error.localizedDescription)")
        }
    }
    
    public func addUser(nameValue: String, emailValue: String, ageValue: Int64) {
        do {
            try db.run(users.insert(name <- nameValue, email <- emailValue, age <- ageValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Return array of user model
    public func getUsers() -> [UserModel] {
        //Create an empty array
        var userModels: [UserModel] = []
        //Get all users in decending order
        users = users.order(id.desc)
        //Exception handling
        do {
            //loop throoug all users
            for user in try db.prepare(users) {
                //Create new model in each iteration
                let userModel: UserModel = UserModel()
                //set values in model from databse
                userModel.id = user[id]
                userModel.name = user[name]
                userModel.email = user[email]
                userModel.age = user[age]
                //Append in new array
                userModels.append(userModel)
            }
        } catch {
            print(error.localizedDescription)
        }
        return userModels
    }
    
    //Get single user data
    public func getUser(idValue: Int64) -> UserModel {
        //create an empty object
        let userModel: UserModel = UserModel()
        //Exception handling
        do {
            //get user using id
            let user: AnySequence<Row> = try db.prepare(users.filter(id == idValue))
            //get row
            try user.forEach({ (rowValue) in
                //set value in model
                userModel.id = try rowValue.get(id)
                userModel.email = try rowValue.get(email)
                userModel.name = try rowValue.get(name)
                userModel.age = try rowValue.get(age)
            })
        } catch {
            print(error.localizedDescription)
        }
        return userModel
    }
    
    //func to update user
    public func updateUser(idValue: Int64, nameValue: String, emailValue: String, ageValue: Int64) {
        do {
            //get user id using id
            let user: Table = users.filter(id == idValue)
            //run the updated query
            try db.run(user.update(name <- nameValue, email <- emailValue, age <- ageValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //func to delete user
    public func deleteUser(idValue: Int64) {
        do {
            //get user id using id
            let user: Table = users.filter(id == idValue)
            //run the delete query
            try db.run(user.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}
