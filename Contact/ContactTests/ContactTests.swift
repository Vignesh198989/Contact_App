//
//  ContactTests.swift
//  ContactTests
//
//  Created by Vignesh Radhakrishnan on 17/02/20.
//  Copyright © 2020 Sample. All rights reserved.
//

import XCTest
@testable import Parser

class ParserTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParserDecode() {
        let inputFileURL = Bundle.init(for: self.classForCoder).url(forResource: "Sample", withExtension: "json")
        let data = try! Data.init(contentsOf: inputFileURL!)
        let contact = try? Parser<Contact>().decode(data: data)
        XCTAssert(contact != nil)
        let expectedContact = Contact(id: 2750, firstName: "Rahul", lastName: "Pradeep", profilePicture: "/images/missing.png", favourite: true, email: nil, phoneNumber: nil, url: "http://gojek-contacts-app.herokuapp.com/contacts/2750.json")
        XCTAssertEqual(contact!, expectedContact)
        XCTAssertEqual(contact!.firstName, expectedContact.firstName)
        XCTAssertEqual(contact!.lastName, expectedContact.lastName)
        XCTAssertEqual(contact!.profilePicture, expectedContact.profilePicture)
        XCTAssertEqual(contact!.favourite, expectedContact.favourite)
        XCTAssertEqual(contact!.email, expectedContact.email)
        XCTAssertEqual(contact!.phoneNumber, expectedContact.phoneNumber)
        XCTAssertEqual(contact!.url, expectedContact.url)
    }
    
    func testParserDecodeWithInvalidJSON() {
        let inputFileURL = Bundle.init(for: self.classForCoder).url(forResource: "InvalidSample", withExtension: "json")
        let data = try! Data.init(contentsOf: inputFileURL!)
        let contact = try? Parser<Contact>().decode(data: data)
        XCTAssert(contact == nil, "Problem in parser it is working even required value passed as nil")
    }
    
    func testParserEncode() {
        let contact = Contact(id: 2750, firstName: "Rahul", lastName: "Pradeep", profilePicture: "/images/missing.png", favourite: true, email: nil, phoneNumber: nil, url: "http://gojek-contacts-app.herokuapp.com/contacts/2750.json")
        let data = try? Parser<Contact>().encode(model: contact)
        XCTAssert(data != nil)
        
        let model = try? Parser<Contact>().decode(data: data!)
        
        XCTAssert(model != nil)
        XCTAssert(model!.id == 2750)
        
    }
    
}
