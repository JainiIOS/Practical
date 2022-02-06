//
//  AnalyticsViewController.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit

class AnalyticsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var heightGraphView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Analytics"
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
