//
//  String+Parameter.swift
//  LZRequest
//
//  Created by 王渊鸥 on 2016/10/21.
//  Copyright © 2016年 王渊鸥. All rights reserved.
//

import Foundation
import Coastline

public extension String {
	static func mixParameters(_ params:[String:Any]) -> String {
		return params.reduce("") {
			if let mix = "\($1.1)".urlString {
				return $0+$1.0+"="+mix+"&"
			} else {
				return $0
			}
		}
	}
	
	func genUrl(_ params:[String:String]) -> String {
		return params.reduce(self+"?") {
			if let mix = $1.1.urlString {
				return $0+$1.0+"="+mix+"&"
			} else {
				return $0
			}
		}
	}
}
