//
//  ExtensionView.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import SwiftUI

extension View {
    //MARK: Close keyboard
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    //MARK: Disabling with opacity
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .opacity(condition ? 0.5 : 1.0)
            .disabled(condition)
    }
    
    //MARK: Custom Border
    func border(_ witdh: CGFloat, _ height: CGFloat) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .cornerRadius(10)
    }
}


@available(iOS 14.0, *)
extension EnvironmentValues {
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}
