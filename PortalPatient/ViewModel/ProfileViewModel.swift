//
//  ProfileViewModel.swift
//  PortalPatient
//
//  Created by Damian on 19/12/2022.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    
    //MARK: User Model
    @Published var myProfile: User = User(username: "", lastName: "", userUID: "", userEmail: "")
    
    //MARK: Error properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    
    private let service: FirebaseService
    
    init() {
        service = FirebaseService()
    }
    
    deinit{
        print("Profile View Model has been destroyed")
    }
    
    //MARK: Logout user
    func logoutUser() {
        service.logOutUserCall()
        Settings.shared.logStatus = false
    }
    
    //MARK: Delete user account
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                try await service.deleteAccount()
                Settings.shared.logStatus = false
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: Fetch user data from Firebase
    func fetchUser() {
        Task {
            do {
                guard let user = try await service.fechUserCall() else {return}
                await MainActor.run(body: {
                    myProfile = user
                })
            } catch {
                await setError(error)
            }
        }
    }

    //MARK: Displaying erros via alerts
    func setError(_ error: Error) async {
        //MARK: UI must be updated on Main Thread
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}
