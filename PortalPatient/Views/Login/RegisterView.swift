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
    
    //MARK: ViewModel
    @StateObject var vm: LoginViewModel
    
    //MARK: View properties
    @State private var animate: Bool = false
    @Environment(\.dismiss) var dismiss

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
                TextField("Name", text: $vm.name)
                    .textContentType(.name)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                TextField("Last Name", text: $vm.lastName)
                    .textContentType(.name)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                TextField("Email", text: $vm.emailID)
                    .textContentType(.emailAddress)
                    .padding(10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                
                
                SecureField("Password", text: $vm.password)
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
                
                Button{
                    vm.isLoading = true
                    closeKeyboard()
                    vm.registerUser()
                }label:{
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
        .overlay(LoadingView(show: $vm.isLoading))
        .alert(isPresented: $vm.showError) {
            Alert(title: Text("Ups.."), message: Text(vm.errorMessage))
        }
    }
}




