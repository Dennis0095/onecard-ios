//
//  APIClient.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation
import Combine
import SystemConfiguration

enum APIError: Error {
    case networkError
    case invalidURL
    case requestFailed
    case invalidResponse
    case expiredSession
    case decodingError
    case defaultError
    case custom(String, String)
    
    func error() -> CustomError {
        var title = ""
        var description = ""
        
        switch self {
        case .networkError:
            title = "Lo sentimos"
            description = "Hubo un problema de conexión, Por favor, inténtalo nuevamente"
        case .custom(let t, let d):
            title = t
            description = d
        case .expiredSession:
            title = "Sesión expirada"
            description = "Por favor, vuelva a iniciar sesión"
        default:
            title = "Algo salió mal"
            description = "Por favor, inténtelo nuevamente"
        }
        
        return CustomError(title: title, description: description)
    }
}

struct CustomError: LocalizedError {
    let title: String
    let description: String
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol BaseRequest: Codable { }

class APIClient {
    static func callAPI<T: Decodable>(baseUrl: String? = nil, route: Route, method: Method, parameters: [String : Any]? = nil, request: BaseRequest? = nil) -> AnyPublisher<T, APIError> {
        if APIClient.isInternetAvailable() {
            let urlString = (baseUrl != nil ? baseUrl! : Environment().configuration(.baseUrl)) + route.description
            
            guard let url = urlString.asUrl else {
                return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = UserSessionManager.shared.getToken() {
                urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            urlRequest.httpMethod = method.rawValue
            
            switch method {
            case .get:
                if let params = parameters {
                    var urlComponent = URLComponents(string: urlString)
                    urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                    urlRequest.url = urlComponent?.url
                    APIClient.generateCurlRequest(urlString: urlRequest.url?.absoluteString ?? "", httpMethod: method.rawValue, headers: urlRequest.allHTTPHeaderFields ?? [:], body: nil)
                } else {
                    APIClient.generateCurlRequest(urlString: urlString, httpMethod: method.rawValue, headers: urlRequest.allHTTPHeaderFields ?? [:], body: nil)
                }
            default:
                if let request = request {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = .prettyPrinted
                    
                    let jsonData = try? encoder.encode(request)
                    urlRequest.httpBody = jsonData
                    APIClient.generateCurlRequest(urlString: urlString, httpMethod: method.rawValue, headers: urlRequest.allHTTPHeaderFields ?? [:], body: jsonData)
                }
            }
            
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          401 != httpResponse.statusCode else {
                        print("Expired Session")
                        throw APIError.expiredSession
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          200..<300 ~= httpResponse.statusCode else {
                        print("Invalid Response")
                        throw APIError.invalidResponse
                    }
                    
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .subscribe(on: RunLoop.main)
                .mapError { error -> APIError in
                    print(error.localizedDescription)
                    if let apiError = error as? APIError {
                        return apiError
                    } else {
                        print("Decoding Error")
                        return APIError.decodingError
                    }
                }.eraseToAnyPublisher()
        } else {
            return Fail(error: APIError.networkError).eraseToAnyPublisher()
        }
    }
    
    static func generateCurlRequest(urlString: String, httpMethod: String, headers: [String: String], body: Data?) {
        var curlCommand = "curl -X \(httpMethod)"

        // Append URL
        curlCommand += " '\(urlString)'"

        // Append headers
        for (key, value) in headers {
            curlCommand += " -H '\(key): \(value)'"
        }

        // Append body if present
        if let requestBody = body, let bodyString = String(data: requestBody, encoding: .utf8) {
            curlCommand += " -d '\(bodyString)'"
        }

        print(curlCommand)
    }
    
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
