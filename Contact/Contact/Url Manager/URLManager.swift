//
//  URLManager.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//

struct URLManager {
    
    static func getContactListUrl() -> String {
        return "/contacts.json"
    }
    
    static func getContactUrl() -> String {
        return "/contacts/%d.json"
    }
    
}
