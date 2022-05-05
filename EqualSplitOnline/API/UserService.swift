//
//  SessionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 01.01.2022.
//

import Alamofire

typealias AuthCompletion = (DataResponse<UserData, AFError>)->Void

struct UserService {
    
    static func fetchUserData(completion: @escaping AuthCompletion) {
        guard let accessToken = KeychainService.getAccessToken() else { return }
         
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
          ]
        
        let request = [String: String]()
        
        let callurl = "\(API_URL)/users"
                
        AF.request(callurl, method: .post, parameters: request, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: UserData.self) { response in
            
            switch response.result {
            case .success:
                SessionViewController.sessions = response.value!.sessions
                AuthService.activeUser = response.value!.activeUser
                completion(response)
                
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        fetchUserData { response in
                            completion(response)
                        }
                    } errorHandler: {
                        print("Error")
                    }

                }
            }
        }
    }
    
    static func changeUserName(to newname: String, completion: @escaping ()->()) {
        guard let accessToken = KeychainService.getAccessToken() else { return }
         
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
          ]
        
        let request: [String: String] = [
            "newname": newname
        ]
        
        let callurl = "\(API_URL)/users"
                
        AF.request(callurl, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion()
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        changeUserName(to: newname) {
                            completion()
                        }
                    } errorHandler: {
                        print("Error")
                    }
                } else {
                    print("Request failed")
                }
            }
        }
    }
    
    
    
    
    static func deleteAccount(completion: @escaping ()->(), errorhandler: @escaping ()->()) {
        guard let accessToken = KeychainService.getAccessToken() else { return }
         
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
          ]
        
        let callurl = "\(API_URL)/users"
                
        AF.request(callurl, method: .delete, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion()
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        deleteAccount {
                            completion()
                        } errorhandler: {
                            errorhandler()
                        }

                    } errorHandler: {
                        errorhandler()
                    }
                } else {
                    print("Request failed")
                }
            }
        }
    }
    
    
    
}
