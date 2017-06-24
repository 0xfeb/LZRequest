//
//  Data+Request.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

extension Data {
	static let HTTP_BOUNDRY = "_REQUEST_APPLICATION_"
	
	static func parameters(_ boundry:String = HTTP_BOUNDRY) -> LZData {
		return LZData(source: NSMutableData(), boundry: boundry)
	}
	
	static func setting(_ action:(LZData)->()) -> Data {
		let data = Data.parameters()
		return data.setting(action)
	}
}

extension NSMutableData {
	
	func set(_ key:String, value:String, boundry:String) {
		let leadString = "\n--\(boundry)"
			+ "\nContent-Disposition:form-data;name=\"\(key)\"\n"
			+ "\n\(value)"
		
		if let data = (leadString as NSString).data(using: String.Encoding.utf8.rawValue) {
			self.append(data)
		}
	}
	
	func set(_ file:String, data:Data, boundry:String) {
		let leadString = "\n--\(boundry)"
			+ "\nContent-Disposition:form-data;name=\"file\";filename=\"\(file)\""
			+ "\nContent-Type:application/octet-stream"
			+ "\nContent-Transfer-Encoding:binary\n\n"
		
		if let lead = (leadString as NSString).data(using: String.Encoding.utf8.rawValue) {
			self.append(lead)
		}
		self.append(data)
	}
	
	func closeBoundry(_ boundry:String) {
		let endString = "\n--\(boundry)--"
		if let data = (endString as NSString).data(using: String.Encoding.utf8.rawValue) {
			self.append(data)
		}
	}
}

