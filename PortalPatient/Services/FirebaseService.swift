//
//  FirebaseService.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import Foundation
import Firebase
import FirebaseFirestore

final class FirebaseService {
    
    //MARK: RestPassword call
    func resetPasswordCall(emailID: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: emailID)
        print("Reset password sended")
    }
    
    //MARK: Login user send
    func loginUserCall(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    //MARK: Fetch user data from firebase
    func fechUserCall() async throws -> (String?, User?){
        guard let userID = Auth.auth().currentUser?.uid else {return (nil,nil)}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        
        return (userID,user)
    }
    
    //MARK: Register Account
    func registerAccountCall(name: String, lastName: String, email: String, password: String) async throws{
        
        try await Auth.auth().createUser(withEmail: email, password: password)
        
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        
        let user = User(username: name, lastName: lastName, userUID: userUID, userEmail: email)
        
        try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
            if error == nil {
                print("Saved successfully")
                Settings.shared.userNameStored = user.username
                Settings.shared.userLastNameStored = user.lastName
                Settings.shared.userUIDStored = userUID
                Settings.shared.logStatus = true
            }
        })
    }
}
