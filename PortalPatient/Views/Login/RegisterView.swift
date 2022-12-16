//
//  RegisterView.swift
//  PortalPatient
//
//  Created by Damian on 15/12/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct RegisterView: View {
    
    //MARK: User info.
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var lastName: String = ""
    
    //MARK: View properties
    @State private var animate: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var isLoading: Bool = false
    
    //MARK: View properties Error Alerts
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    //MARK: UserDefaults
    @AppStorage("log_status") private var logStatus: Bool = false
    @AppStorage("user_name") private var userNameStored: String = ""
    @AppStorage("user_UID") private var userUIDStored: String = ""
    @AppStorage("last_name") private var userLastNameStored: String = ""

    var body: some View {
        VStack(spacing: 10){
            Spacer()
            Text("PortalPatient")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
                .frame(width: 250, height: 70)
                .background(Color.green)
                .cornerRadius(25)
                .onAppear{animate.toggle()}
                .offset(CGSize(width: 0, height: animate ? -0 : -100))
                .opacity(animate ? 1.0 : 0.0)
                .scaleEffect(x: animate ? 1.0 : 0.0,
                             y:animate ? 1.0 : 0.0,
                             anchor: .center)
                .animation(.spring())
                .padding(.bottom, 20)
                .shadow(radius: 5)
            
            
            Text("Sign Up")
                .font(.title).bold()
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
            
            VStack(spacing: 12){
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                TextField("Last Name", text: $lastName)
                    .textContentType(.name)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                Button("Reset password?") {
                    //
                }
                .foregroundColor(.black)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button(action: registerUser){
                    Text("Sign up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.top, 10)
                    
                }
                
            }
            .padding()
            
            //MARK: Register button
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Log in"){
                    dismiss()
                }
                .foregroundColor(.black)
                .font(.callout.bold())
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .overlay(LoadingView(show: $isLoading))
        .alert(isPresented: $showError) {
            Alert(title: Text("Ups.."), message: Text(errorMessage))
        }
    }
    
    func registerUser(){
        isLoading = true
        closeKeyboard()
        
        Task {
            do {
                //Step 1. Creating Firebase account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                //Step 2. Creating USER Firestore Object
                let user = User(username: name, lastName: lastName, userUID: userUID, userEmail: emailID)
                //Step 3. Saving USER Doc to Firestore Database
                try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil {
                        print("Saved successfully")
                        userNameStored = name
                        userLastNameStored = lastName
                        userUIDStored = userUID
                        logStatus = true
                    }
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
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


@available(iOS 14.0, *)
extension EnvironmentValues {
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}
