//
//  MovieApi.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 05/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum MovieApi {
    case getGenreList()
    case getPopularMovies(page: Int)
    case getMovieDetails(id: String)
}

extension MovieApi {
    var baseUrl: String {
        return Constants.baseUrl
    }
    
    var path: String {
        switch self {
            
        case .getPopularMovies(let page):
            return "movie/popular?api_key=\(Constants.apiKey)&language=pt-BR&page=\(page)"
        case .getGenreList():
            return "genre/movie/list?api_key=\(Constants.apiKey)&language=pt-BR"
        case .getMovieDetails(let id):
            return "movie/\(id)?api_key=\(Constants.apiKey)&language=pt-BR"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
            
        default:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case _ where self.method == .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var headers: Alamofire.HTTPHeaders {
        var defaultHeaders = [String: String]()
        
        switch self {
        default:
            defaultHeaders["Content-Type"] = "application/json"
            return defaultHeaders
        }
    }
}

extension MovieApi {
    static func request<T: Mappable>(_ endpoint: MovieApi, completion: @escaping (_ result: Result<T>) -> Void) {
        
        Alamofire.request("\(endpoint.baseUrl)\(endpoint.path)", method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding, headers: endpoint.headers).responseJSON { (httpResponse: DataResponse<Any>) in
            
            
            print("response: \(httpResponse.response)")
            print("response status code: \(httpResponse.response?.statusCode)")
            print("response result value: \(httpResponse.result.value)")
            
            guard let response = httpResponse.response else {
                completion(Result.failure(MovieApiError.unknownResponse))
                return
            }
            
            completion(self.handler(statusCode: response.statusCode, dataResponse: httpResponse))
        }
    }
    
    private static func handler<T: Mappable>(statusCode: Int, dataResponse: DataResponse<Any>) -> Result<T> {
        let responseJson = dataResponse.result.value as? [String: Any]
        
        switch statusCode {
        case 200...299:
            return parseJson(responseJson)
        case 400:
            return Result.failure(MovieApiError.badRequest)
        case 401:
            return Result.failure(MovieApiError.unauthorized(parseErrorMessage(responseJson)))
        case 404:
            return Result.failure(MovieApiError.notFound(parseErrorMessage(responseJson)))
        default:
            return Result.failure(MovieApiError.unknownResponse)
        }
    }
    
    private static func parseJson<T: Mappable>(_ responseJson: [String: Any]?) -> Result<T> {
        if let json = responseJson {
            guard let object = T(JSON: json) else {
                return Result.failure(MovieApiError.invalidJson)
            }
            
            return Result.success(object)
        } else {
            guard let object = T(JSON: responseJson ?? [:]) else {
                return Result.failure(MovieApiError.invalidJson)
            }
            
            return Result.success(object)
        }
    }
    
    private static func parseErrorMessage(_ responseJson: [String: Any]?) -> GenericResponseString {
        let genericResponse = GenericResponseString()
        
        guard let response = responseJson else {
            return genericResponse
        }
        
        genericResponse.message = response["status_message"] as? String ?? ""
        genericResponse.errorCode = response["status_code"] as? String ?? ""
        
        return genericResponse
    }
}
