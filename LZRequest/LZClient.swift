//
//  LZClient.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

public class LZClient: NSObject {
	static var baseURL = ""
	static var shareHeaders:[String:String] = [:]
	
	static let QueryTimeOut = 10.0
	
	var session:URLSession
	var isStaticMode:Bool = false
	
	init(session:URLSession) {
		self.session = session
	}
	
	// 实时获取数据
	static func realTimeClient() -> LZClient {
		let config = URLSessionConfiguration.ephemeral
		config.timeoutIntervalForRequest = QueryTimeOut
		config.timeoutIntervalForResource = QueryTimeOut
		let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue())
		return LZClient(session: session)
	}
	
	static func cacheClient() -> LZClient {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue())
		return LZClient(session: session)
	}
	
	static func staticCacheClient() -> LZClient {
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
	
	func GET(_ url:String, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .GET, parameters: nil, url: url, contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	func POST(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: url, contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	func DELETE(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: url, contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	func PUT(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: url, contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	func PATCH(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: url, contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
	
	func OPTION(_ url:String, _ parameters:[String:Any]?, type:URLSession.ContentType = .form) -> LZRequest? {
		let query = URLSession.Query(method: .POST, parameters: parameters, url: url, contentType: type, isStaticMode: isStaticMode)
		let headers = LZClient.buildHeader(type: type)
		return session.buildQuery(headers: headers, query: query)
	}
}
