//
//  LZRequest+Image.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation
import UIKit

public extension LZRequest {
	func image(_ response:@escaping (UIImage?)->Void) {
		data { (data) in
			if let data = data {
				if let image = UIImage(data: data) {
					response(image)
				} else {
					print("Image parse error: \(data)")
					 response(nil)
				}
			} else {
				print("Request error")
				 response(nil) 
			}
		}
	}
}
