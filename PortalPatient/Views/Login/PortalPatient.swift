//
//  PortalPatient.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import SwiftUI

struct PortalPatient: View {
    @State private var animate: Bool = false
    
    var body: some View {
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
    }
}
