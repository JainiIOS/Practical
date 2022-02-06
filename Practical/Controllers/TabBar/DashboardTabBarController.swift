//
//  DashboardTabBarController.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit

class DashboardTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
        
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

// MARK: - Initial Setups
extension DashboardTabBarController {
    func initialSetup() {
        let button = UIButton(type: .custom)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.addTarget(self, action: #selector(logoutClick), for: .touchUpInside)
        let leftButtonBar = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [leftButtonBar]
    }
}

// MARK: - IBAction
extension DashboardTabBarController {
    @IBAction func logoutClick(_ sender : UIButton){
        CommonMethods.logout()
    }
}
