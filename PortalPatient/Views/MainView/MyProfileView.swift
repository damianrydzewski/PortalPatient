//
//  MyProfileView.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import SwiftUI

struct MyProfileView: View {
    
    @StateObject private var vm: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Group {
                        Text(vm.myProfile.username)
                        Text(vm.myProfile.lastName)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title2.bold())
                
                    Text(vm.myProfile.userEmail)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(20)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
                .padding(10)
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Logout", action: vm.logoutUser)
                        Button("Delete Account", action: vm.deleteAccount)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .onAppear {
            vm.fetchUser()
        }
        .alert(isPresented: $vm.showError){
            Alert(title: Text("Ups.."), message: Text(vm.errorMessage))
        }
        .overlay(LoadingView(show: $vm.isLoading))
    }
}

struct MyProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyProfileView()
    }
}
