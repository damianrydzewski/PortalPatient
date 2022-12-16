//
//  LoginView.swift
//  PortalPatient
//
//  Created by Damian on 15/12/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct LoginView: View {
    
    //MARK: User info.
    @State private var emailID: String = ""
    @State private var password: String = ""
    
    //MARK: View properties
    @State private var createAccount: Bool = false
    @State private var isLoading: Bool = false
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    //MARK: UserDefaults
    @AppStorage("log_status") private var logStatus: Bool = false
    @AppStorage("user_name") private var userNameStored: String = ""
    @AppStorage("last_name") private var userLastNameStored: String = ""
    @AppStorage("user_UID") private var userUIDStored: String = ""
    
    
    
    var body: some View {
        VStack(spacing: 10){
            Spacer()
            
            PortalPatient()
            
            Text("Log in")
                .font(.title).bold()
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                
            VStack(spacing: 12){
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)

                
                SecureField("Password", text: $password)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                Button("Reset password?") {
                    resetPassword()
                }
                .foregroundColor(.black)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button(action: loginUser) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.top, 10)
                }
                .disabled(emailID == "" || password == "")
            }
            .padding()
            
            //MARK: Register button
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    createAccount.toggle()
                }
                .foregroundColor(.black)
                .font(.callout.bold())
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
        }
        //MARK: RegisterView via sheet
        .fullScreenCover(isPresented: $createAccount){
            RegisterView()
        }
        //MARK: Display alert
        .alert(isPresented: $showError){
            Alert(title: Text("Ups.."), message: Text(errorMessage))
        }
        .overlay(LoadingView(show: $isLoading))
    }
    
    
    func resetPassword() {
        isLoading = true
        Task {
            do {
                //MARK: Resting password
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Reset password sended")
            } catch {
                await setError(error)
            }
        }    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        
        Task {
            do {
                //MARK: Authorization
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User found in database")
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: If User has been found, fetch data from Firestore
    func fetchUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        
        //MARK: Updating UI on Main Thread
        await MainActor.run(body: {
            //Settings UserDefaults data and changing App's Auth Status
            userUIDStored = userID
            userNameStored = user.username
            userLastNameStored = user.lastName
            logStatus = true

        })
            
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


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


