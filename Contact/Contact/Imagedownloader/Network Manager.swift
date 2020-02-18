//
//  Network Manager.swift
//  Contacts
//
//  Created by Vignesh Radhakrishnan on 06/02/20.
//

import Foundation

protocol NetworkManager {
    typealias resultHandler = (_ result: Data?, _ error: Error?) -> Void
    func configure(session: URLSession)
    func download(requestInfo: RequestInfo, completion: @escaping resultHandler)
}

struct RequestInfo {
    var path: String
    var parameters: [String: Any]?
    var method: HTTPMethod
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case update = "PUT"
    }
}

final class ContactsNetworkManager: NetworkManager {
    
    static let sharedNetworkManager: NetworkManager = ContactsNetworkManager()
    private var session: URLSession!
    
    private init() {
        configure()
    }
    
    func configure(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
   
    func download(requestInfo: RequestInfo, completion: @escaping (_ result: Data?, _ error: Error?) -> Void) {
        do {
            let urlRequest = try URLRequest.prepare(fromRequestInfo: requestInfo)
            session.downloadTask(with: urlRequest) { (url, response, error) in
                if let errorObj = error {
                    completion(nil,errorObj)
                } else {
                    if let url = url, let data = try? Data.init(contentsOf: url) {
                        completion(data,nil)
                    }
                }
                }.resume()
        } catch {
            completion(nil,error)
        }
    }
}

extension URLRequest {
    static func prepare(fromRequestInfo info: RequestInfo) throws -> URLRequest {
        guard let url = URL.init(string: info.path), url.isValidURL() else {
            throw NSError.init(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
        }
        switch info.method {
        case .get:
            var queryItems: [URLQueryItem] = []
            if let data = info.parameters as? [String: String] {
                for (key, value) in data {
                    let item = URLQueryItem(name: key, value: value)
                    queryItems.append(item)
                }
            }
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw NSError.init(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
            }
            if !queryItems.isEmpty {
                urlComponents.queryItems = queryItems
            }
            guard let resultURL = urlComponents.url else {
                throw NSError.init(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
            }
            var urlRequest = URLRequest(url: resultURL)
            urlRequest.httpMethod = info.method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
            return urlRequest
        case .post:
            fallthrough
        case .update:
            var urlRequest = URLRequest(url: url)
            if let parameters = info.parameters, let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
                urlRequest.httpBody = data
            }
            urlRequest.httpMethod = info.method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
            return urlRequest
        }
        
    }
}

extension URL {
    func isValidURL() -> Bool {
        return !(self.host?.isEmpty ?? true)
    }
}
