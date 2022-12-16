//
//  DashboardView.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            TabView {
                AppointmentsView()
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("Appointments")
                    }
                
                MyProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My Profile")
                    }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
