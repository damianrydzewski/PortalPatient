//
//  LoginViewModel.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor
final class LoginViewModel: ObservableObject {
    //MARK: User properties
    @Published var emailID: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var lastName: String = ""
    
    //MARK: Error properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    //MARK: View properties
    @Published var createAccount: Bool = false
    @Published var isLoading: Bool = false
    
    let service: FirebaseService
    
    init() {
        service = FirebaseService()
    }
    
    func resetPassword() {
        isLoading = true
        Task {
            do {
                try await service.resetPasswordCall(emailID: emailID)
            } catch {
                await setError(error)
            }
        }
    }
    
    
    func loginUser() {        
        Task {
            do {
                //MARK: Authorization
                try await service.loginUserCall(email: emailID, password: password)
                print("User found in database")
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: If User has been found, fetch data from Firestore
    func fetchUser() async throws {
        let (userID, user) = try await service.fechUserCall()

        //MARK: Updating UI on Main Thread
        await MainActor.run(body: {
            //Settings UserDefaults data and changing App's Auth Status
            Settings.shared.userUIDStored = userID ?? ""
            Settings.shared.userNameStored = user?.username ?? ""
            Settings.shared.userLastNameStored = user?.lastName ?? ""
            Settings.shared.logStatus = true
        })
    }
    
    func registerUser(){
        isLoading = true
        
        Task {
            do {
                try await service.registerAccountCall(name: name, lastName: lastName, email: emailID, password: password)
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: Displaying erros via alerts
    func setError(_ error: Error) async {
        //MARK: UI must be updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}
