//
//  Util.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation
import UIKit.UIApplication

struct Util {
    static func openEmail(withTo to: String, completion: ((Bool) -> Void)? = nil) {
        let email = to
        if let url = URL(string: "mailto:\(email)") , UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: { (_) -> Void in
              completion?(true)
            })
        } else {
            completion?(false)
        }
    }

    static func openDialler(withNumber number: String, completion: ((Bool) -> Void)? = nil) {
        if let url = URL(string: "tel://\(number)") , UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: { (_) -> Void in
                completion?(true)
            })
        } else {
            completion?(false)
        }
    }
    
    static func openMessages(withNumber number: String, completion: ((Bool) -> Void)? = nil) {
        if let url = URL(string: "sms:\(number)") , UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: { (_) -> Void in
                completion?(true)
            })
        } else {
            completion?(false)
        }
    }
}
