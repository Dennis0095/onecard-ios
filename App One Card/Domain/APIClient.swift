//
//  APIClient.swift
//  App One Card
//
//  Created by Paolo Arambulo on 24/06/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

struct CustomError: LocalizedError {
    let title: String
    let description: String
    var timeExpired: Bool = false
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol BaseRequest: Codable { }

class APIClient {
    private var cancellable: AnyCancellable?
    
//    static func callAPI<T: Decodable>(route: Route, method: Method, parameters: [String : Any]? = nil, request: BaseRequest? = nil, completion: @escaping (Result<T, Error>) -> Void) {
//
//        let urlString = Environment().configuration(.baseUrl) + route.description
//        guard let url = urlString.asUrl else {
//            return completion(.failure(APIError.invalidURL))
//        }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        //        if let token = SessionManager.shared.getToken() {
//        //            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        //        }
//        urlRequest.httpMethod = method.rawValue
//
//        switch method {
//        case .get:
//            if let params = parameters {
//                var urlComponent = URLComponents(string: urlString)
//                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
//                urlRequest.url = urlComponent?.url
//            }
//        default:
//            if let request = request {
//                let encoder = JSONEncoder()
//                encoder.outputFormatting = .prettyPrinted
//
//                let jsonData = try? encoder.encode(request)
//                urlRequest.httpBody = jsonData
//            }
//        }
//
//        let session = URLSession.shared
//
//        session.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                completion(.failure(APIError.requestFailed))
//                return
//            }
//
//            guard let responseData = data else {
//                completion(.failure(APIError.invalidResponse))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let decodedResponse = try decoder.decode(T.self, from: responseData)
//                completion(.success(decodedResponse))
//            } catch {
//                completion(.failure(APIError.decodingError))
//            }
//        }.resume()
//    }
    
    static func callAPI<T: Decodable>(route: Route, method: Method, parameters: [String : Any]? = nil, request: BaseRequest? = nil, showLoading: Bool = false) -> AnyPublisher<T, Error> {
        
        if showLoading {
            Loading.shared.show()
        }
        
        let urlString = Environment().configuration(.baseUrl) + route.description
        guard let url = urlString.asUrl else {
            if showLoading {
                Loading.shared.hide()
            }
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        if let token = SessionManager.shared.getToken() {
        //            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        //        }
        urlRequest.httpMethod = method.rawValue
        
        switch method {
        case .get:
            if let params = parameters {
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            }
        default:
            if let request = request {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let jsonData = try? encoder.encode(request)
                urlRequest.httpBody = jsonData
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    if showLoading {
                        Loading.shared.hide()
                    }
                    throw APIError.invalidResponse
                }
                if showLoading {
                    Loading.shared.hide()
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    if showLoading {
                        Loading.shared.hide()
                    }
                    return apiError
                } else {
                    if showLoading {
                        Loading.shared.hide()
                    }
                    return APIError.decodingError
                }
            }
            .eraseToAnyPublisher()
    }
}
