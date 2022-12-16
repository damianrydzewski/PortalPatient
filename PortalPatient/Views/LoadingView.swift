//
//  LoadingView.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            if show {
                Group {
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(25)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}
