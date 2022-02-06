//
//  Constant.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import Foundation
import Auth0
import CoreLocation

let allowedCharacterForHeight = "0123456789."

let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate

//Cred manager
let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

enum CredentialsManagerError {
    case noCredentials
}

let sbObj = UIStoryboard(name: "Main", bundle: nil)

var currentLocation = CLLocation(latitude: 0.0, longitude: 0.0)
