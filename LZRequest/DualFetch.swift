//
//  DualFetch.swift
//  VPNGo
//
//  Created by 王渊鸥 on 2017/1/4.
//  Copyright © 2017年 王渊鸥. All rights reserved.
//

import Foundation

public enum ResponseType {
	case local
	case remote
	case faile
}

/// 双线获取数据的工具, 用以实现数据缓冲功能, T为操作的数据类型
public class DualFetch<T> {
	var localQueue:OperationQueue
	var remoteQueue:OperationQueue
	
	var localError = false
	var remoteError = false
	
	var lFetcher: ((T?)->Void)->Void
	var rFetcher: (@escaping (T?)->Void)->Void
	var saver: (T)->Void
	
	public init(lFetcher:@escaping ((T?)->Void)->Void,
	     rFetcher:@escaping (@escaping (T?)->Void)->Void,
	     saver:@escaping (T)->Void) {
		
		localQueue = OperationQueue()
		remoteQueue = OperationQueue()
		
		self.lFetcher = lFetcher
		self.rFetcher = rFetcher
		self.saver = saver
	}
	
	public func run(response:@escaping (ResponseType, T?)->Void) {
		self.localQueue.addOperation { [weak self] in
			self?.lFetcher(){ (oResult) in
				if let result = oResult {
					response(.local, result)
				} else {
					self?.localError = true
					if self?.remoteError == true {
						response(.faile, nil)
					}
				}
			}
		}
		
		self.remoteQueue.addOperation { [weak self] in
			self?.rFetcher() { (oResult) in
				if let result = oResult {
					self?.localQueue.cancelAllOperations()
					self?.saver(result)
					response(.remote, result)
				} else {
					self?.remoteError = true
					if self?.localError == true {
						response(.faile, nil)
					}
				}
			}
		}
	}
}

public class DualFetchDict : DualFetch<[AnyHashable:Any]> {
	public init(userDefaults key:String, rFetcher:@escaping (@escaping ([AnyHashable:Any]?)->Void)->Void) {
		super.init(lFetcher: { (fetchResult) in
			let ud = UserDefaults.standard
			if let dict = ud.dictionary(forKey: key) {
				fetchResult(dict)
			} else {
				fetchResult(nil)
			}
		}, rFetcher: rFetcher) { (dict) in
			let ud = UserDefaults.standard
			ud.set(dict, forKey: key)
			ud.synchronize()
		}
	}
	
	public init(fileCache key:String, rFetcher:@escaping (@escaping ([AnyHashable:Any]?)->Void)->Void) {
		super.init(lFetcher: { (fetchResult) in
			let file = String.libraryPath+"/cache/dict/"+key
			if let dict = NSDictionary(contentsOfFile: file) as? [AnyHashable : Any]? {
				fetchResult(dict)
			}
		}, rFetcher: rFetcher) { (dict) in
			let file = String.libraryPath+"/cache/dict/"+key
			(dict as NSDictionary).write(toFile: file, atomically: true)
		}
	}
}

public class DualFetchStr : DualFetch<String> {
	public init(userDefaults key:String, rFetcher:@escaping (@escaping(String?)->Void)->Void) {
		super.init(lFetcher: { (fetchResult) in
			fetchResult(UserDefaults.standard.string(forKey: key))
		}, rFetcher: rFetcher) { (str) in
			let ud = UserDefaults.standard
			ud.set(str, forKey: key)
			ud.synchronize()
		}
	}
	
	public init(fileCache key:String, rFetcher:@escaping (@escaping(String?)->Void)->Void) {
		super.init(lFetcher: { (fetchResult) in
			let file = String.libraryPath+"/cache/str/"+key
			fetchResult(try? String(contentsOfFile: file, encoding: String.Encoding.utf8))
		}, rFetcher: rFetcher) { (str) in
			let file = String.libraryPath+"/cache/str/"+key
			try? str.write(toFile: file, atomically: true, encoding: String.Encoding.utf8)
		}
	}
}


