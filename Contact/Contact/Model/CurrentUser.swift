//
//  CurrentUser.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//

class CurrentUser {
    
    static let singleton = CurrentUser()
    init() {
        setInitialSetup()
        print("CurrentUser initiated")
    }
    
    private(set) var host : String = ""
    
    private func setInitialSetup() {
        host = Constants.BaseUrl
    }
}
