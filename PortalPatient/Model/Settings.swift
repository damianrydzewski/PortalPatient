//
//  Settings.swift
//  PortalPatient
//
//  Created by Damian on 16/12/2022.
//

import Foundation
import SwiftUI

final class Settings{
    static let shared = Settings()
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("last_name") var userLastNameStored: String = ""
    @AppStorage("user_UID") var userUIDStored: String = ""
}
