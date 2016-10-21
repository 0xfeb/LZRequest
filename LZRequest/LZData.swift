//
//  LZData.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import UIKit

// HTTP Body data
class LZData {
	var source:NSMutableData
	var boundry:String
	
	init(source:NSMutableData, boundry:String) {
		self.boundry = boundry
		self.source = source
	}
	
	func set(_ key:String, value:String) -> LZData {
		source.set(key, value: value, boundry: boundry)
		return self
	}
	
	func set(_ file:String, data:Data) -> LZData {
		source.set(file, data: data, boundry: boundry)
		return self
	}
	
	func set(_ file:String, image:UIImage, compose:CGFloat = 1.0) -> LZData {
		var data:Data? = nil
		if compose == 1.0 {
			data = UIImagePNGRepresentation(image)
		} else {
			data = UIImageJPEGRepresentation(image, compose)
		}
		
		if let data = data {
			source.set(file, data: data, boundry: boundry)
		}
		return self
	}
	
	func setting(_ action:(LZData)->()) -> Data {
		action(self)
		source.closeBoundry(boundry)
		
		return (NSData(data: source as Data) as Data)
	}
}
