//
//  CenterSpinnerProtocol.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation
import UIKit

protocol CentralSpinnerProtocol: class {
    var centralSpinner:  UIActivityIndicatorView? {get set}
}

extension CentralSpinnerProtocol where Self: UIViewController {
    
    func initCenterSpinner() {
        centralSpinner = UIActivityIndicatorView.init(style: .gray)
        if let centralSpinner = centralSpinner {
            centralSpinner.hidesWhenStopped = true
            centralSpinner.accessibilityIdentifier = "centralSpinner"
            self.view.addSubview(centralSpinner)
            
            let center_X = NSLayoutConstraint(item: centralSpinner, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            let center_Y = NSLayoutConstraint(item: centralSpinner, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            centralSpinner.translatesAutoresizingMaskIntoConstraints = false
            self.view .addConstraints([center_X,center_Y])
            self.view .layoutIfNeeded()
        }
    }
    
    func animateCentralSpinner() {
        centralSpinner?.startAnimating()
    }
    
    func stopAnimatingCentralSpinner() {
        centralSpinner? .stopAnimating()
    }
}
