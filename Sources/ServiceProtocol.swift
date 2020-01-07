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
	func dataTask<Value>(
		withRequest request: ServiceRequestProtocol,
		completion: @escaping (Result<Value, Error>) -> Void
		) -> URLSessionTaskProtocol where Value: Decodable
	
	@discardableResult
	func dataTask(
		withRequest request: ServiceRequestProtocol,
		completion: @escaping (Result<Void, Error>) -> Void
		) -> URLSessionTaskProtocol
	
	@discardableResult
	func uploadTask(
		withRequest request: ServiceRequestProtocol,
		fromFile fileURL: URL,
		completion: @escaping (Result<Void, Error>) -> Void
		) -> URLSessionTaskProtocol
	@discardableResult
	func uploadTask(
		withRequest request: ServiceRequestProtocol,
		from data: Data,
		completion: @escaping (Result<Void, Error>) -> Void
		) -> URLSessionTaskProtocol
	
	@discardableResult
	func downloadTask(
		withRequest request: ServiceRequestProtocol,
		completionHandler: @escaping (Result<URL, Error>) -> Void
		) -> URLSessionTaskProtocol
	@discardableResult
	func downloadTask(
		withResumeData resumeData: Data,
		completionHandler: @escaping (Result<URL, Error>) -> Void
		) -> URLSessionTaskProtocol
}

public extension ServiceProtocol {
	@discardableResult
	func dataTask<Value>(
		withRequest request: ServiceRequestProtocol,
		completion: @escaping (Result<Value, Error>) -> Void
		) -> URLSessionTaskProtocol where Value: Decodable {
		let task = session.dataTask(
			with: request.request
		) { (data, resposne, error) in
			completion(self.handleResponse(
				responseData: data,
				response: resposne,
				responseError: error
			))
		}
		task.resume()
		return task
	}
	
	@discardableResult
	func dataTask(
		withRequest request: ServiceRequestProtocol,
		completion: @escaping (Result<Void, Error>) -> Void
		) -> URLSessionTaskProtocol {
		let task = session.dataTask(
			with: request.request
		) { (_, resposne, error) in
			completion(self.handleVoidResponse(
				response: resposne,
				responseError: error
			))
		}
		task.resume()
		return task
	}
	
	@discardableResult
	func uploadTask(
		withRequest request: ServiceRequestProtocol,
		fromFile fileURL: URL,
		completion: @escaping (Result<Void, Error>) -> Void
		) -> URLSessionTaskProtocol {
		let task = session.uploadTask(
		with: request.request, fromFile: fileURL) { (_, resposne, error) in
			completion(self.handleVoidResponse(
				response: resposne,
				responseError: error
			))
		}
		task.resume()
		return task
	}
	
	@discardableResult
	func uploadTask(
		withRequest request: ServiceRequestProtocol,
		from data: Data,
		completion: @escaping (Result<Void, Error>) -> Void
		) -> URLSessionTaskProtocol {
		let task = session.uploadTask(
			with: request.request, from: data
		) { (_, resposne, error) in
			completion(self.handleVoidResponse(
				response: resposne,
				responseError: error
			))
		}
		task.resume()
		return task
	}
	
	@discardableResult
	func downloadTask(
		withRequest request: ServiceRequestProtocol,
		completionHandler: @escaping (Result<URL, Error>) -> Void
		) -> URLSessionTaskProtocol {
		let task = session.downloadTask(
			with: request.request
		) { (url, response, error) in
			completionHandler(self.handleOptionalResponse(
				value: url,
				response: response,
				responseError: error
			))
		}
		task.resume()
		return task
	}
	
	@discardableResult
	func downloadTask(
		withResumeData resumeData: Data,
		completionHandler: @escaping (Result<URL, Error>) -> Void
		) -> URLSessionTaskProtocol {
		let task = session.downloadTask(
			withResumeData: resumeData
		) { (url, response, error) in
			completionHandler(self.handleOptionalResponse(
				value: url,
				response: response,
				responseError: error
			))
		}
		task.resume()
		return task
	}
	
	/// MARK: - Implementations
	
	private func handleVoidResponse(
		response: URLResponse?,
		responseError: Error?
		) -> Result<Void, Error> {
		if let error = responseError {
			return .failure(error)
		}
		do {
			_ = try code(from: response)
		} catch {
			return .failure(error)
		}
		return .success(())
	}
	
	private func handleOptionalResponse<Value>(
		value: Value?,
		response: URLResponse?,
		responseError: Error?
		) -> Result<Value, Error> {
		
		if let error = responseError {
			return .failure(error)
		}
		
		let statusCode: Int
		do {
			statusCode = try code(from: response)
		} catch {
			return .failure(error)
		}
		
		guard let value = value else {
			return .failure(NSError(
				domain: errorDomain,
				code: statusCode,
				userInfo: [NSLocalizedDescriptionKey: ErrorMessages.couldNotGetValue.rawValue]
			))
		}
		return .success(value)
	}
	
	private func handleResponse<Value>(
		responseData: Data?,
		response: URLResponse?,
		responseError: Error?
		) -> Result<Value, Error> where Value: Decodable {
		
		if let error = responseError {
			return .failure(error)
		}
		let statusCode: Int
		do {
			statusCode = try code(from: response)
		} catch {
			return .failure(error)
		}
		
		guard let jsonData = responseData else {
			return .failure(NSError(
				domain: errorDomain,
				code: statusCode,
				userInfo: [NSLocalizedDescriptionKey: ErrorMessages.couldNotGetData.rawValue]
			))
		}
		
		do {
			return .success(try jsonData.decode(Value.self))
		} catch {
			return .failure(error)
		}
	}
	
	private func code(
		from response: URLResponse?
		) throws -> Int {
		guard let code = response?.httpCode else {
			throw NSError(
				domain: errorDomain,
				code: 400,
				userInfo: [NSLocalizedDescriptionKey: ErrorMessages.noStatusCode.rawValue]
			)
		}
		guard validate(code: code) else {
			throw NSError(
				domain: errorDomain,
				code: code,
				userInfo: [NSLocalizedDescriptionKey: ErrorMessages.invalidStatusCode.rawValue]
			)
		}
		return code
	}
	
	private func validate(
		code: Int
		) -> Bool {
		return (200..<300).contains(code)
	}
}

private enum ErrorMessages: String {
	case noStatusCode = "Could not get status code from urlresponse"
	case invalidStatusCode = "Status code indicates error"
	case couldNotGetData = "Could not get data from the response"
	case couldNotGetValue = "Could not get value"
}

private let errorDomain = "NetworkingError"
