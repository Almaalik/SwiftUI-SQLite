//
//  UserModel.swift
//  SQLite SwiftUI
//
//  Created by DB-MBP-012 on 25/12/23.
//

import Foundation

class UserModel: Identifiable {
    public var id: Int64 = 0
    public var name: String = ""
    public var email: String = ""
    public var age: Int64 = 0
}
