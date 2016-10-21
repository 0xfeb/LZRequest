//
//  LZRequest+Fast.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation

public enum DataParts{
	// 空结构, 只有code值
	case empty(code:Int, error:String?)
	
	// 字符串结构
	case string(code:Int, error:String?, data:String)
	
	// Int数值
	case integer(code:Int, error:String?, data:Int)
	
	// 列表结构
	case list(code:Int, error:String?, data:[Any])
	
	// 字典结构
	case dictionary(code:Int, error:String?, data:[AnyHashable:Any])
}

public extension LZRequest {
	// 缺省数据结构块
	static var dataParts:(code:String, error:String, data:String) = ("code", "error", "data")
	
	func parts(_ response:@escaping (DataParts?)->Void) {
		dictionary { (dict) in
			if let dict = dict {
				if let code = dict[LZRequest.dataParts.code] as? Int {
					let error = dict[LZRequest.dataParts.error] as? String
					let data = dict[LZRequest.dataParts.data]
					if let data = data as? [Any] {
						OperationQueue.main.addOperation { response(DataParts.list(code: code, error: error, data: data)) }
					} else if let data = data as? [AnyHashable:Any] {
						OperationQueue.main.addOperation { response(DataParts.dictionary(code: code, error: error, data: data)) }
					} else if let data = data as? String {
						OperationQueue.main.addOperation { response(DataParts.string(code: code, error: error, data: data)) }
					} else if let data = data as? Int {
						OperationQueue.main.addOperation { response(DataParts.integer(code: code, error: error, data: data)) }
					} else {
						OperationQueue.main.addOperation { response(DataParts.empty(code: code, error: error)) }
					}
				} else {
					print("Dictionary parser error:\(dict)")
					OperationQueue.main.addOperation { response(nil) }
				}
			} else {
				print("Request error")
				OperationQueue.main.addOperation { response(nil) }
			}
		}
	}
}
