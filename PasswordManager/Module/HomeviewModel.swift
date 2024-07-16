//
//  HomeviewModel.swift
//  PasswordManager
//
//  Created by GWL on 14/07/24.
//

import Foundation
// Data Model
struct DataModel: Identifiable, Codable {
    var id: UUID
    var accountName: String
    var username: String
    var password: String
}
