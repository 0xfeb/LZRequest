//
//  LZClient.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

public class LZClient: NSObject {
	public static var baseURL = ""
	public static var shareHeaders:[String:String] = [:]
	
	static let QueryTimeOut = 100.0
	
	var session:URLSession
	var isStaticMode:Bool = false
	
	init(session:URLSession) {
		self.session = session
	}
	
	// 实时获取数据
	public static var realTime:LZClient {
		let config = URLSessionConfiguration.ephemeral
		config.timeoutIntervalForRequest = QueryTimeOut
		config.timeoutIntervalForResource = QueryTimeOut
		let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue())
		return LZClient(session: session)
	}
	
	public static var cache:LZClient {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue())
		return LZClient(session: session)
	}
	
	public static var staticCache:LZClient {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue())
		let client = LZClient(session: session)
		client.isStaticMode = true
		return client
	}
}

public extension LZClient {
	static func buildHeader(type:URLSession.ContentType) -> [String:String] {
		var headers:[String:String] = [:]
		
		shareHeaders.forEach{
			headers[$0.key] = $0.value
		}
		
		switch type {
		case .part:
			headers["Content-Type"] = "multipart/form-data; charset=utf-8; boundary="+Data.HTTP_BOUNDRY
		case .json:
			headers["Content-Type"] = "application/json; charset=utf-8"
		case .form:
			headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
		}
		
		return headers
	}
}

public extension LZClient {
	private func URL(url:String) -> String {
		let urlGap = LZClient.baseURL.isEmpty||LZClient.baseURL.hasSuffix("/") ? "" : "/"
		return LZClient.baseURL + urlGap + url
	}
	
	public func GET(_ url:String, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .GET, parameters: nil, url: URL(url: url), contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	public func POST(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: URL(url: url), contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	public func DELETE(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: URL(url: url), contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	public func PUT(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: URL(url: url), contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	public func PATCH(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: URL(url: url), contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	public func OPTION(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: URL(url: url), contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
}
