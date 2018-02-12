//
//  Service.swift
//  Top Games
//
//  Created by Leonardo Oliveira on 2/10/18.
//  Copyright © 2018 Leonardo Oliveira. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT"
}

struct ServiceConfiguration {
    
    static let `default` = ServiceConfiguration(baseURL: URL(string: "https://api.twitch.tv/kraken/")!,headers: ["Client-ID": "i25lvnenp51613ti2rpvot4y8pcmvx"], session: .shared, decoder: JSONDecoder(), encoder: JSONEncoder())
    
    let baseURL: URL
    let headers: [String : String]
    let session: URLSession
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
}

protocol Service {
    
    var configuration: ServiceConfiguration { get }
    var endpoint: String { get }
    
    func request(method: HTTPMethod, parameters: [String: Any]) -> URLRequest
    
}

extension Service {
    
    func request(method: HTTPMethod = .get, parameters: [String : Any]) -> URLRequest {
        let url = configuration.baseURL.appendingPathComponent(endpoint)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        configuration.headers.forEach { (header) in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
    
}
