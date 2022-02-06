//
//  InitialViewController.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit
import Auth0

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - IBAction
extension InitialViewController {
    @IBAction func loginClick(_ sender : UIButton){
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://dev-za31ta-p.us.auth0.com/userinfo")
            .start { result in
                switch result {
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                case .success(let credentials):
                    // Do something with credentials e.g.: save them.
                    // Auth0 will automatically dismiss the login page
                    print("Credentials: \(credentials)")
                    _ = credentialsManager.store(credentials: credentials)
                    CommonMethods.rootViewSetup()
                }
        }
    }
}
