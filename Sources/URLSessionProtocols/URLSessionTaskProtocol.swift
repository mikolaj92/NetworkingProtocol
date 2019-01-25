//
//  URLSessionTaskProtocol.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation


public protocol URLSessionTaskProtocol {
    var taskIdentifier: Int { get }

    var originalRequest: URLRequest? { get }

    var currentRequest: URLRequest? { get }

    var response: URLResponse? { get }

    @available(iOS 11.0, tvOS 11.0, *)
    var progress: Progress { get }

    @available(iOS 11.0, tvOS 11.0, *)
    var earliestBeginDate: Date? { get set }

    @available(iOS 11.0, tvOS 11.0, *)
    var countOfBytesClientExpectsToSend: Int64 { get set }

    @available(iOS 11.0, tvOS 11.0, *)
    var countOfBytesClientExpectsToReceive: Int64 { get set }

    var countOfBytesReceived: Int64 { get }

    var countOfBytesSent: Int64 { get }

    var countOfBytesExpectedToSend: Int64 { get }

    var countOfBytesExpectedToReceive: Int64 { get }

    var taskDescription: String? { get set }

    func cancel()

    var state: URLSessionTask.State { get }

    var error: Error? { get }

    func suspend()

    func resume()

    var priority: Float { get set }
}

extension URLSessionTask: URLSessionTaskProtocol { }
