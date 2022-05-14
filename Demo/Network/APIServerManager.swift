

import Foundation

class APIServerManager: NSObject, URLSessionDelegate{
    
    private override init() {}
    
    public static let shared = APIServerManager()
    
    typealias CompletionHandler<T> = (Result<T>) -> ()
    
    private let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    private let timeoutInterval: TimeInterval = 180.0
    
    func request<T: Decodable>(with url: String,
                               type: T.Type,
                               _ method: HttpMethods = .get,
                               _ headers: [String: String] = [:],
                               _ parameters: Any? = nil,
                               _ encoding: Encoding = .json,
                               completion: @escaping CompletionHandler<T>) {
        guard let url = URL(string: url) else {
            completion(.failure(.badUrl))
            return
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters,options: [])
                debugPrint(parameters)
                
            } catch let error {
                completion(.failure(.invalidParameters(error)))
                return
            }
        }
        
        headers.forEach({ (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        })
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
       
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                    completion(.failure(.networkError(error!)))
                    return
            }
            
            guard let data = data else {
                    completion(.failure(.dataNotFound))
                    return
            }
            do {
                let resp = response as! HTTPURLResponse
                
                guard (200...299).contains(resp.statusCode) else {
                    completion(.failure(.networkError(ApiError.invalidHttpCode)))
                    return
                }
                
                debugPrint("\(String(describing: resp.url))")
                let decodedObject = try JSONDecoder().decode(type, from: data)
                completion(.success(decodedObject))
                
            }catch let error {
                debugPrint("\(error)")
                completion(.failure(.jsonParsingError(error)))
            }
        }
        task.resume()
    }
}

extension APIServerManager{
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
