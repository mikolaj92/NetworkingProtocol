//
//  URLSessionProtocol.swift
//  NetworkingProtocol
//
//  Created by patrykmikolajczyk on 1/25/19.
//  Copyright © 2019 mikolaj92. All rights reserved.
//

import Foundation

public typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
public typealias DownloadTaskResult = (URL?, URLResponse?, Error?) -> Void

public protocol URLSessionProtocol {

    var delegateQueue: OperationQueue { get }

    var configuration: URLSessionConfiguration { get }

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol

    func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol

    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol

    func downloadTask(with request: URLRequest, completionHandler: @escaping DownloadTaskResult) -> URLSessionTaskProtocol

    func downloadTask(withResumeData resumeData: Data, completionHandler: @escaping DownloadTaskResult) -> URLSessionTaskProtocol

    func finishTasksAndInvalidate()

    func invalidateAndCancel()

    func getAllTasks(completionHandler: @escaping ([URLSessionTaskProtocol]) -> Void)
}

extension URLSessionProtocol where Self: URLSession {
    public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }

    public func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        return uploadTask(with: request, fromFile: fileURL, completionHandler: completionHandler) as URLSessionUploadTask
    }

    public func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        return uploadTask(with: request, from: bodyData, completionHandler: completionHandler) as URLSessionUploadTask
    }

    public func downloadTask(with request: URLRequest, completionHandler: @escaping DownloadTaskResult) -> URLSessionTaskProtocol {
        return downloadTask(with: request, completionHandler: completionHandler) as URLSessionDownloadTask
    }

    public func downloadTask(withResumeData resumeData: Data, completionHandler: @escaping DownloadTaskResult) -> URLSessionTaskProtocol {
        return downloadTask(withResumeData: resumeData, completionHandler: completionHandler) as URLSessionDownloadTask
    }

    public func getAllTasks(completionHandler: @escaping ([URLSessionTaskProtocol]) -> Void) {
        getAllTasks { (tasks: [URLSessionTask]) in
            completionHandler(tasks)
        }
    }
}

extension URLSession: URLSessionProtocol { }
