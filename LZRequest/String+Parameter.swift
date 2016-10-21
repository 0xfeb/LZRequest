//
//  String+Parameter.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

public extension String {
	static func mixParameters(_ params:[String:Any]) -> String {
		return params.reduce("") { $0+$1.0+"="+"\($1.1)".urlString()+"&" }
	}
	
	func genUrl(_ params:[String:String]) -> String {
		return params.reduce(self+"?") { $0+$1.0+"="+$1.1.urlString()+"&" }
	}
	
	
	func urlString() -> String {
		return (self as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
	}
	
	var url:URL? {
		get {
			return URL(string: self.urlString())
		}
	}
}
