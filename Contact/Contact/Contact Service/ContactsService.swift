//
//  ContactsService.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 05/02/20.
//

import Foundation

protocol ContactsGetListService {
    func getContacts(onSuccess: @escaping (_ result: [Contact]?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
}

protocol ContactsGetDetailService {
    func getContactDetail(id : Int, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
}

protocol ContactsCreateService {
    func addNewContact(contact : Contact,formFields : [FormField],withSuccess onSuccess: @escaping (_ result: Contact?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
}

protocol ContactsUpdateService {
    func updateContact(_ contact: Contact,formFields : [FormField], withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
    func favorite(contact : Contact, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
}

struct ContactsService: ContactsGetListService, ContactsGetDetailService, ContactsCreateService, ContactsUpdateService {
    
    private let api: ContactAPI
    
    init(api: ContactAPI = ContactAPIService()) {
        self.api = api
    }
    
    func getContacts(onSuccess: @escaping (_ result: [Contact]?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        self.api.fetchContacts(withSuccess: { (contacts) in
            DispatchQueue.main.async {
                onSuccess(contacts)
            }
        }) { (error) in
            DispatchQueue.main.async {
                onFailure(error)
            }
        }
    }
    
    func getContactDetail(id : Int, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        self.api.fetchContactDetails(id: id, withSuccess: { (contact) in
            DispatchQueue.main.async {
                onSuccess(contact)
            }
        }) { (error) in
            DispatchQueue.main.async {
                onFailure(error)
            }
        }
    }
    
    func addNewContact(contact : Contact,formFields : [FormField],withSuccess onSuccess: @escaping (_ result: Contact?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        api.addNewContact(contact: contact, formFields: formFields, withSuccess: { (contact) in
            DispatchQueue.main.async {
                onSuccess(contact)
            }
        }) { (error) in
            DispatchQueue.main.async {
                onFailure(error)
            }
        }
    }
    
    func updateContact(_ contact: Contact,formFields : [FormField], withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        api.editContact(id: contact.id, formFields: formFields, withSuccess: { (contact) in
            DispatchQueue.main.async {
                onSuccess(contact)
            }
        }) { (error) in
            DispatchQueue.main.async {
                onFailure(error)
            }
        }
    }
    
    func favorite(contact : Contact, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        api.favorite(contact: contact, withSuccess: { (contact) in
            DispatchQueue.main.async {
                onSuccess(contact)
            }
        }) { (error) in
            DispatchQueue.main.async {
                onFailure(error)
            }
        }
    }
    
}
