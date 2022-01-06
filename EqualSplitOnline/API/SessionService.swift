//
//  SessionService.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 02.01.2022.
//

import Alamofire

struct SessionService {
    
    static func addSession(withName name: String, completion: @escaping (AFDataResponse<Data?>)->Void) {
        
        let request: [String: String] = [
            "name": name
        ]
        
        let callurl = "\(API_URL)/session"
        
        AF.request(callurl, method: .post, parameters: request, encoder: JSONParameterEncoder.default).response { response in
            if response.response?.statusCode == 200 {
                completion(response)
            } else {
                print("DEBUG - status: \(String(describing: response.error?.localizedDescription))")
            }
        }
    }
    
}
