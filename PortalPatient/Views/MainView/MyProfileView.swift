//
//  MyProfileView.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import SwiftUI

struct MyProfileView: View {
    
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        NavigationView {
            ScrollView {
                
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Logout") {
                            
                        }
                        
                        Button("Delete Account") {
                            
                        }
                        
                        
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
