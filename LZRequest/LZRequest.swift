//
//  LZRequest.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

public struct LZRequest {
	var session:URLSession
	var request:URLRequest
}

public extension LZRequest {
	func array(_ response:@escaping ([Any]?)->Void) {
		let url = request.url?.absoluteString ?? "[unknown]"
		let body = request.httpBody?.string ?? "[empty]"
		let header = request.allHTTPHeaderFields
		self.session.dataTask(with: request) { [url, body, header] (data, resp, error) in
			if let data = data {
				print("\nRequest success [array]: \(String(describing: resp)), error: \(String(describing: error)), url: \(url)")
				print("header---> ", header ?? "[empty]")
				print("body---> ", body)
				
				if let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments) ) as? [Any] {
					 response(json)
				} else {
					print("Json array parser error: \(data)")
					 response(nil)
				}
			} else {
				print("\nRequest error [array]: \(String(describing: resp)), error: \(String(describing: error)), url: \(url)")
				print("header---> ", header ?? "[empty]")
				print("body---> ", body)
				 response(nil)
			}
		}.resume()
	}
	
	func dictionary(_ response:@escaping ([AnyHashable:Any]?)->Void) {
		print("req-->", request.url?.absoluteString ?? "[unknown]")
		let url = request.url?.absoluteString ?? "[unknown]"
		let body = request.httpBody?.string ?? "[empty]"
		let header = request.allHTTPHeaderFields
		self.session.dataTask(with: request) { [url, body, header] (data, resp, error) in
			if let data = data {
				print("\nRequest success [dict]: \(String(describing: resp)), error: \(String(describing: error)), url: \(url)")
				print("header---> ", header ?? "[empty]")
				print("body---> ", body)
				
				if let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments) ) as? [AnyHashable:Any] {
					if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) {
						print("json--->", jsonData.string ?? "[unknown]")
					}
					response(json)
				} else {
					print("Json array parser error: \(data)")
					response(nil)
				}
			} else {
				print("\nRequest error [dict]: \(String(describing: resp)), error: \(String(describing: error)), url: \(url)")
				print("header---> ", header ?? "[empty]")
				print("body---> ", body)
				 response(nil)
			}
			}.resume()
	}
	
	func string(_ response:@escaping (String?)->Void) {
		self.session.dataTask(with: request) { (data, resp, error) in
			if let data = data {
				if let text = String(data: data, encoding: String.Encoding.utf8) {
					 response(text)
				} else {
					print("String parse error: \(data)")
					 response(nil)
				}
			} else {
				print("Request error [string]: \(String(describing: resp))")
				 response(nil)
			}
			}.resume()
	}
	
	func data(_ response:@escaping (Data?)->Void) {
		self.session.dataTask(with: request) { (data, resp, error) in
			if let data = data {
				 response(data)
			} else {
				print("Request error [data]: \(String(describing: resp))")
				 response(nil)
			}
			}.resume()
	}
}
