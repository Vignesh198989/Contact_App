//
//  EditContactViewModel.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation

final class EditContactViewModel : BaseFormViewModel {
    
    private let service: ContactsUpdateService
    
    override init(contact : Contact) {
        self.service =  ContactsService()
        super.init(contact: contact)
    }
    
    func editContact(withSuccess onSuccess: @escaping () -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        if let error = valiate() {
            onFailure(error)
        } else {
            service.updateContact(contact, formFields: self.formFields, withSuccess: { (contact) in
                onSuccess()
            }) { (error) in
                onFailure(error)
            }
        }
    }
}
