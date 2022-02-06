//
//  UIViewController.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func displayAlert(title: String?, message: String?, completion: (()->())?)
    {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            completion?()
        }
        controller.addAction(actionButton)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
        }
    }
    
    func displayAlertWithATextField(title: String?, placeholder: String?, tag : Int, completion: ((_ tf : UITextField)->())?, buttonCompletion: (()->())?)
    {
        let controller = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Add", style: .default) { (action) in
            buttonCompletion?()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        controller.addTextField { (textfield) in
            textfield.placeholder = placeholder
            textfield.keyboardType = .decimalPad
            if tag == 1 {
                textfield.keyboardType = .numberPad
            }
            textfield.tag = tag
            completion?(textfield)
        }
        okButton.isEnabled = false
        controller.addAction(cancelButton)
        controller.addAction(okButton)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
        }
    }
}
