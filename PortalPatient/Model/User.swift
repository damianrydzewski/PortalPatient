//
//  User.swift
//  PortalPatient
//
//  Created by Damian on 15/12/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var lastName: String
    var userUID: String
    var userEmail: String
    
    enum keys: CodingKey {
        case id
        case username
        case lastname
        case userID
        case userEmail
    }
}
