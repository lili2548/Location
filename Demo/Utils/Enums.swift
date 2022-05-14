

import Foundation

//MARK: Api error
enum ApiError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Error)
    case invalidParameters(Error)
    case badUrl
    case invalidHttpCode
}

enum Result<T> {
    case success(T)
    case failure(ApiError)
}

//MARK: Http Methods
enum HttpMethods: String {
    case get
    case post
    case put
    case delete
}

//MARK: Encoding
enum Encoding {
    case json
    case data
    case string
}
