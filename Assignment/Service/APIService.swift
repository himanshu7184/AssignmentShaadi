//
//  APIService.swift
//  Assignment
//
//  Created by Himanshu Sonker on 05/02/21.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case dataNotFound = "Data Not Found"
    case jsonParsingError = "Json Parsing Error"
    case invalidStatusCode = "Invalid Status Code"
}

protocol APIServiceProtocol {
    func fetchUserList( complete: @escaping ( _ success: Bool, _ users: [User]?, _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    func fetchUserList( complete: @escaping ( _ success: Bool, _ users: [User]?, _ error: APIError? )->() ) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { data, response, error -> Void in
            
            guard let data = data else { return }
            do {
                let userObject = try JSONDecoder().decode(Array<User>.self, from: data)
                complete( true, userObject, nil )
                
            } catch {
                complete( true, nil, APIError.dataNotFound)
                print("error")
            }
        })

        task.resume()
    }
    
    
    
}
