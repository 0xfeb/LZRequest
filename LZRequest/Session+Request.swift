//
//  Session+Request.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

public extension URLSession {
	enum ContentType {
		case form
		case json
		case part
	}
	
	public enum Method : String {
		case GET = "GET"
		case POST = "POST"
		case PUT = "PUT"
		case PATCH = "PATCH"
		case DELETE = "DELETE"
		case OPTION = "OPTION"
	}
	
	public struct Query {
		var method:Method
		var parameters:[String:Any]?
		var url:String
		var contentType:ContentType
		var isStaticMode:Bool = false
	}
	
	func buildQuery(headers:[String:String], query:Query) -> LZRequest? {
		guard let url = URL(string: query.url) else { return nil }
		let request = query.isStaticMode ?  NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 120.0) : NSMutableURLRequest(url: url)
		
		for kv in headers {
			request.setValue(kv.value, forHTTPHeaderField: kv.key)
		}
		
		func buildBody(type:ContentType, content:[String:Any]) -> Data? {
			switch type {
			case .form:
				return String.mixParameters(content).data(using: String.Encoding.utf8)
			case .json:
				return try? JSONSerialization.data(withJSONObject: content, options: JSONSerialization.WritingOptions.prettyPrinted)
			case .part:
				return Data.setting {
					let param = $0
					content.forEach{
						if let d = $0.1 as? Data {
							_ = param.set($0.0, data: d )
						} else {
							_ = param.set($0.0, value: "\($0.1)")
						}
					}
				}
			}
		}
		
		request.httpMethod = query.method.rawValue
		if let params = query.parameters {
			request.httpBody = buildBody(type: query.contentType, content: params)
		}
		
		return LZRequest(session: self, request: request as URLRequest)
	}
}
