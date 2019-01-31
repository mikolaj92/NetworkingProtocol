//
//  ServiceProtocol.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

public protocol ServiceProtocol {
    var session: URLSessionProtocol { get }
    
    @discardableResult
    func dataTask<T>(withRequest request: ServiceRequestProtocol,
                     completion: @escaping (Result<T>) -> Void) -> URLSessionTaskProtocol where T: Decodable
    @discardableResult
    func dataTask(withRequest request: ServiceRequestProtocol,
                  completion: @escaping (Result<Void>) -> Void) -> URLSessionTaskProtocol
    
    @discardableResult
    func uploadTask(withRequest request: ServiceRequestProtocol,
                    fromFile fileURL: URL,
                    completion: @escaping (Result<Void>) -> Void) -> URLSessionTaskProtocol
    @discardableResult
    func uploadTask(withRequest request: ServiceRequestProtocol,
                    from data: Data,
                    completion: @escaping (Result<Void>) -> Void) -> URLSessionTaskProtocol
    
    @discardableResult
    func downloadTask(withRequest request: ServiceRequestProtocol,
                      completionHandler: @escaping (Result<URL>) -> Void) -> URLSessionTaskProtocol
    @discardableResult
    func downloadTask(withResumeData resumeData: Data,
                      completionHandler: @escaping (Result<URL>) -> Void) -> URLSessionTaskProtocol
}

public extension ServiceProtocol {
    @discardableResult
    public func dataTask<T>(withRequest request: ServiceRequestProtocol, completion: @escaping (Result<T>) -> Void) -> URLSessionTaskProtocol where T: Decodable {
        let task = session.dataTask(with: request.request) { (data, resposne, error) in
            completion(self.handleResponse(responseData: data, response: resposne, responseError: error))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func dataTask(withRequest request: ServiceRequestProtocol, completion: @escaping (Result<Void>) -> Void) -> URLSessionTaskProtocol {
        let task = session.dataTask(with: request.request) { (_, resposne, error) in
            completion(self.handleVoidResponse(response: resposne, responseError: error))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func uploadTask(withRequest request: ServiceRequestProtocol, fromFile fileURL: URL, completion: @escaping (Result<Void>) -> Void) -> URLSessionTaskProtocol {
        let task = session.uploadTask(with: request.request, fromFile: fileURL) { (_, resposne, error) in
            completion(self.handleVoidResponse(response: resposne, responseError: error))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func uploadTask(withRequest request: ServiceRequestProtocol, from data: Data, completion: @escaping (Result<Void>) -> Void) -> URLSessionTaskProtocol {
        let task = session.uploadTask(with: request.request, from: data) { (_, resposne, error) in
            completion(self.handleVoidResponse(response: resposne, responseError: error))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func downloadTask(withRequest request: ServiceRequestProtocol, completionHandler: @escaping (Result<URL>) -> Void) -> URLSessionTaskProtocol {
        let task = session.downloadTask(with: request.request) { (url, response, error) in
            completionHandler(self.handleOptionalResponse(value: url, response: response, responseError: error))
        }
        task.resume()
        return task
    }

    @discardableResult
    public func downloadTask(withResumeData resumeData: Data, completionHandler: @escaping (Result<URL>) -> Void) -> URLSessionTaskProtocol {
        let task = session.downloadTask(withResumeData: resumeData) { (url, response, error) in
            completionHandler(self.handleOptionalResponse(value: url, response: response, responseError: error))
        }
        task.resume()
        return task
    }

    private func handleVoidResponse(response: URLResponse?, responseError: Error?) -> Result<Void> {
        if let error = responseError {
            return .error(error)
        }
        if let code = (response as? HTTPURLResponse)?.statusCode,
            validate(code: code) {
            return .value(())
        }
        return .error(NSError(domain: "NetworkingError", code: 400, userInfo: nil))
    }

    private func handleOptionalResponse<T>(value: T?, response: URLResponse?, responseError: Error?) -> Result<T> {
        if let error = responseError {
            return .error(error)
        }
        if let value = value,
            let code = response?.httpCode,
            validate(code: code) {
            return .value(value)
        }
        return .error(NSError(domain: "NetworkingError", code: 400, userInfo: nil))
    }


    private func handleResponse<T>(responseData: Data?, response: URLResponse?, responseError: Error?) -> Result<T> where T: Decodable {
        if let error = responseError {
            return .error(error)
        }
        guard let jsonData = responseData else {
            let error = NSError(domain: "NetworkingError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Data was not retrieved from request"])
            return .error(error)
        }
        do {
            return .value(try jsonData.decode(T.self))
        } catch {
            return .error(error)
        }
    }

    private func validate(code: Int) -> Bool {
        return (200..<300).contains(code)
    }
}
