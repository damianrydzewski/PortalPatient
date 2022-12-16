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
    //MARK: ViewModel
    @StateObject private var vm: LoginViewModel = LoginViewModel()    
    
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
                TextField("Email", text: $vm.emailID)
                    .textContentType(.emailAddress)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)

                
                SecureField("Password", text: $vm.password)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                Button("Reset password?") {
                    vm.resetPassword()
                }
                .foregroundColor(.black)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button{
                    vm.isLoading = true
                    closeKeyboard()
                    vm.loginUser()
                } label:{
                    Text("Sign in")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.top, 10)
                }
                .disabled(vm.emailID == "" || vm.password == "")
            }
            .padding()
            
            //MARK: Register button
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now"){
                    vm.createAccount.toggle()
                }
                .foregroundColor(.black)
                .font(.callout.bold())
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
        }
        //MARK: RegisterView via sheet
        .fullScreenCover(isPresented: $vm.createAccount){
            RegisterView(vm: vm)
        }
        //MARK: Display alert
        .alert(isPresented: $vm.showError){
            Alert(title: Text("Ups.."), message: Text(vm.errorMessage))
        }
        .overlay(LoadingView(show: $vm.isLoading))
    }
    
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


