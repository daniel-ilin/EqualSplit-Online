//
//  SessionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 01.01.2022.
//

import Alamofire

struct UserService {
    
    static func fetchUserData(completion: @escaping AuthCompletion) {
        
        let request: [String: String] = [:]
        
        let callurl = "\(API_URL)/userdata"
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default).validate().responseDecodable(of: Sessions.self) { response in
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                print("DEBUG - status: \(String(describing: response.response?.statusCode))")
            }
        }
    }
    
}
