//
//  SessionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 02.01.2022.
//
import Foundation
import Alamofire

struct SessionService {
    
    static func addSession(withName name: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
        ]
        
        let request: [String: String] = [
            "name": name
        ]
        
        let callurl = API_URL + "/session"
        
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        addSession(withName: name) { response in
                            completion(response)
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
    
    
    
    
    static func deleteSession(withId id: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
        ]
        
        let request: [String: String] = [
            "sessionid": id
        ]
        
        let callurl = API_URL + "/session"
        
        AF.request(callurl, method: .delete, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        deleteSession(withId: id) { response in
                            completion(response)
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
    
    
    
    static func renameSession(withId id: String, toName name: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
        ]
        
        let request: [String: String] = [
            "sessionid": id,
            "name": name
        ]
        
        let callurl = API_URL + "/session"
        
        AF.request(callurl, method: .put, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        renameSession(withId: id, toName: name) { response in
                            completion(response)
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
    
    
    
    
    static func joinSession(withCode code: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
        ]
        
        let request: [String: String] = [
            "sessionCode": code
        ]
        
        let callurl = API_URL + "/session/join"
        
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        joinSession(withCode: code) { response in
                            completion(response)
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
    
    
    
    
    static func removeUser(withId userid: String, fromSessionWithId sessionid: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        guard let accessToken = KeychainService.getAccessToken() else { return }
        
        let headers: HTTPHeaders = [
            "x-auth-token": accessToken
        ]
        
        let request: [String: String] = [
            "sessionid": sessionid,
            "targetid": userid
        ]
        
        let callurl = API_URL + "/session/user"
        
        AF.request(callurl, method: .delete, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: 200..<300).response { response in
            switch response.result {
            case .success:
                completion(response)
            case .failure:
                if response.response?.statusCode == 401 {
                    AuthService.requestAccessToken {
                        removeUser(withId: userid, fromSessionWithId: sessionid) { response in
                            completion(response)
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
    
    
    
    
    
    //    static func addOfflineUser(toSession session: Session, completion: @escaping (AFDataResponse<Data?>)->Void) {
    //        let callurl = "\(API_URL)/addofflineuser"
    //
    //    }
    
}
