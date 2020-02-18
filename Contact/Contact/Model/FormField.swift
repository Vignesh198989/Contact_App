//
//  FormField.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation

enum Field: Int {
    case firstName
    case lastName
    case email
    case phone
}

protocol ConfigureCellProtocol {
    func getFieldName() -> String
    func getFieldValue() -> String
    func getPlaceHolder() -> String
}

class FormField : ConfigureCellProtocol {
    
    private var field : Field?
    private var fieldName: String?
    private var fieldValue: String?
    private var placeHolder : String?
    
    init(withFieldName name : String,value : String,field : Field,placeHolder : String) {
        self.fieldName = name
        self.fieldValue = value
        self.field = field
        self.placeHolder = placeHolder
    }
    
    func getFieldName() -> String {
        return fieldName ?? ""
    }
    
    func getFieldValue() -> String {
        return fieldValue ?? ""
    }
    
    func getField() -> Field {
        return field ?? .firstName
    }
    
     func setFieldName(name : String)  {
        self.fieldName = name
    }
    
     func setFieldValue(value : String)  {
        self.fieldValue = value
    }
    
    func getPlaceHolder() -> String {
        return self.placeHolder ?? ""
    }
}
