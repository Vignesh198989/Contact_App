//
//  AddContactViewModel.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation

final class AddContactViewModel : BaseFormViewModel {
    
    private let service: ContactsCreateService
    
   override init(contact : Contact) {
        self.service = ContactsService()
        super.init(contact: contact)
    }
    
    func createContact(withSuccess onSuccess: @escaping () -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        if let error = valiate() {
            onFailure(error)
        } else {
            self.service.addNewContact(contact: self.contact, formFields: self.formFields, withSuccess: { (contact) in
                onSuccess()
            }) { (error) in
                onFailure(error)
            }
        }
    }
}
