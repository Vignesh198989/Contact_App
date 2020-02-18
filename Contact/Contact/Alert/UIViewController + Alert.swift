//
//  UIViewController + Alert.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import UIKit

extension UIViewController {
    func showAlert(_ message: String, completion: (() -> Void)? = nil) {
        let alert: UIAlertController = UIAlertController.init(title: "Contacts", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true,completion: nil)
    }
    
    func showActionAlert(_ message: String, title: String) {
        let alert: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            self?.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true,completion: nil)
    }
}
