//
//  ContentView.swift
//  PortalPatient
//
//  Created by Damian on 15/12/2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") private var logStatus: Bool = false

    var body: some View {
        //MARK: Redirecting User based on UserDefaults
        if logStatus {
            DashboardView()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

