//
//  CommonMethods.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit
import Auth0
import MBProgressHUD

class CommonMethods: NSObject {
    class func checkLoginToken(_ completion : @escaping (_ error : CredentialsManagerError?) -> ()) {
        guard credentialsManager.hasValid() else {
            // No valid credentials exist, present the login page
            return completion(.noCredentials)
        }
        return completion(nil)
    }
    
    class func rootViewSetup() {
        CommonMethods.checkLoginToken({ error in
            
            var navigationController = UINavigationController.init()
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                fatalError("could not get scene delegate ")
            }
            
            if let _ = error {
                //no cred available, present login
                print("no cred available, present login")
                
                guard let rootVC = sbObj.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController else { return }
                
                navigationController = UINavigationController.init(rootViewController: rootVC)
                
            } else {
                //cred available, present home
                print("cred available, present home")
                
                guard let rootVC = sbObj.instantiateViewController(withIdentifier: "DashboardTabBarController") as? DashboardTabBarController else { return }
                
                navigationController = UINavigationController.init(rootViewController: rootVC)
            }
            
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        })
    }
    
    class func logout() {
        Auth0
            .webAuth()
            .clearSession(federated: false) { result in
                if result {
                    // Session cleared
                    credentialsManager.revoke { error in
                        if let aErrorObj = error {
                            print("error = \(aErrorObj)")
                        } else {
                            CommonMethods.rootViewSetup()
                        }
                    }
                }
            }
    }
    
    //MARK: - Start Stop Pregress
    class func startProgressBarOnWindow(message : String?) {
        DispatchQueue.main.async {
            
            if #available(iOS 13.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        let hud = MBProgressHUD.showAdded(to: sceneDelegate.window!, animated: true)
                        hud.isSquare = false
                        hud.mode = MBProgressHUDMode.indeterminate
                        hud.contentColor = UIColor.black //loader color
                        hud.backgroundColor = UIColor.gray // entire view bg color
                        hud.bezelView.backgroundColor = UIColor.lightGray //bezel color
                        hud.animationType = MBProgressHUDAnimation.zoomOut
                        
                        if message?.count ?? 0 > 0 {
                            hud.label.text = message
                            hud.label.textColor = UIColor.black
                            hud.label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                        }
                        
                        hud.show(animated: true)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    class func stopProgressBarOnWindow() {
        DispatchQueue.main.async {
            
            if #available(iOS 13.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        MBProgressHUD.hide(for: sceneDelegate.window!, animated: true)
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
