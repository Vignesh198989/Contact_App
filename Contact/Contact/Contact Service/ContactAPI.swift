//
//  ContactAPI.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
 
//

protocol ContactAPI {
    func fetchContacts(withSuccess onSuccess: @escaping (_ result: [Contact]?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
    func fetchContactDetails(id : Int, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
    func favorite(contact : Contact, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
    func editContact(id : Int,formFields : [FormField], withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
    func addNewContact(contact : Contact,formFields : [FormField],withSuccess onSuccess: @escaping (_ result: Contact?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void)
}
struct ContactAPIService : ContactAPI {
    
     func fetchContacts(withSuccess onSuccess: @escaping (_ result: [Contact]?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        let requestURL = URLManager .getContactListUrl()
        let url = CurrentUser.singleton.host + requestURL
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.get(url, parameters: nil, success: { (operation, responseObject) in
            if let responseData = operation.responseData {
                do {
                    let contacts = try Parser<[Contact]>().decode(data: responseData)
                    onSuccess(contacts)
                } catch {
                    onFailure(error)
                }
            }
        }) { (operation, error) in
            onFailure(error)
        }
    }
    
     func fetchContactDetails(id : Int, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        
        let requestURL = CurrentUser.singleton.host +  String(format: URLManager .getContactUrl(),id)
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.get(requestURL, parameters: nil, success: { (operation, responseObject) in
            if let responseData = operation.responseData {
                do {
                    let contact = try Parser<Contact>().decode(data: responseData)
                    onSuccess(contact)
                } catch {
                    onFailure(error)
                }
            }
        }) { (operation, error) in
            onFailure(error)
        }
    }
    
     func favorite(contact : Contact, withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        
        let requestURL = CurrentUser.singleton.host +  String(format: URLManager .getContactUrl(),contact.id)
        let isContactFavourted: Bool = contact.favourite 
        let isContactFavouretdInvert = !isContactFavourted
        let param = ["favorite": isContactFavouretdInvert, "id": contact.id] as [String : Any]
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer .setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        manager.put(requestURL, parameters: param, success: { (operation, responseObject) in
            if let responseData = operation.responseData {
                do {
                    let contact = try Parser<Contact>().decode(data: responseData)
                    onSuccess(contact)
                } catch {
                    onFailure(error)
                }
            }
        }) { (operation, error) in
            onFailure(error)
        }
    }
    
     func addNewContact(contact : Contact,formFields : [FormField],withSuccess onSuccess: @escaping (_ result: Contact?) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        
        let requestURL = CurrentUser.singleton.host + URLManager .getContactListUrl()
        let params = Contact .formFieldJsonRepresentation(formfields: formFields)
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
    //    manager.requestSerializer .setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        manager.post(requestURL, parameters: params, success: { (oper,obj) -> Void in
            if let responseData = oper.responseData {
                do {
                    let contact = try Parser<Contact>().decode(data: responseData)
                    onSuccess(contact)
                } catch {
                    onFailure(error)
                }
            }
        }) { (oper, error) -> Void in
            onFailure(error)
        }
    }
    
     func editContact(id : Int,formFields : [FormField], withSuccess onSuccess: @escaping (_ result: Contact) -> Void, andError onFailure: @escaping (_ error: Error?) -> Void) {
        
        let requestURL = CurrentUser.singleton.host +  String(format: URLManager .getContactUrl(),id)
        let params = Contact .formFieldJsonRepresentation(formfields: formFields)
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer .setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        manager.put(requestURL, parameters: params, success: { (operation, responseObject) in
            if let responseData = operation.responseData {
                do {
                    let contact = try Parser<Contact>().decode(data: responseData)
                    onSuccess(contact)
                } catch {
                    onFailure(error)
                }
            }
        }) { (operation, error) in
            onFailure(error)
        }
    }
}
