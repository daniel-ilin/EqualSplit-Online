//
//  AuthServiceTest.swift
//  EqualSplitOnlineTests
//
//  Created by Daniel Ilin on 1/28/22.
//

import XCTest
@testable import EqualSplitOnline

class AuthServiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_user_can_register() throws {

        let expectation = XCTestExpectation(description: "User succesfuly registered")

        AuthService.registerUser(withCredentials: AuthCredentials(email: "testuser@test.test", name: "test", password: "test"), completion: { response in
            XCTAssertNotNil(response, "No response was received")
            
            XCTAssertNil(response.error, "Error was received")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_user_can_login() throws {
        
        let expectation = XCTestExpectation(description: "User succesfuly logged in")

        AuthService.loginUser(withEmail: "testuser@test.test", password: "test") { response in
            XCTAssertNotNil(response, "No response was received")
            XCTAssertNil(response.error, "Error was received")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_user_can_logout() throws {
        
        let expectation = XCTestExpectation(description: "User succesfuly logged out")

        AuthService.logout { response in
            XCTAssertNotNil(response, "No response was received")
            XCTAssertNil(response.error, "Error was received")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
}
