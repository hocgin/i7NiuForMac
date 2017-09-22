//
//  Custom.swift
//  i7NiuForMac
//
//  Created by hocgin on 20/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Foundation

let CompressFileTypes = ["public.jpeg", "public.png"]
let ImageFileTypes = CompressFileTypes + ["public.gif"]
let MaxImageSize:UInt64 = 409600

let CompressSettingKey = "compressionState"
let AutoCopySettingKey = "autoCopyState"
let AllKeys = ["accessKey", "secretKey", "bucket", "domain"]


class UserInfo{
    
    static func getDomain() -> String {
        return UserDefaults.standard.string(forKey: "domain") ?? "https://not-found"
    }
    
    static func getAccessKey() -> String {
        return UserDefaults.standard.string(forKey: "accessKey") ?? ""
    }
    
    static func getSecretKey() -> String {
        return UserDefaults.standard.string(forKey: "secretKey") ?? ""
    }
    
    static func getBucket() -> String {
        return UserDefaults.standard.string(forKey: "bucket") ?? ""
    }
    
    static func getCompressionState() -> Int {
        return UserDefaults.standard.integer(forKey: "compressionState")
    }
    
    static func getAutoCopyState() -> Int {
        return UserDefaults.standard.integer(forKey: "autoCopyState")
    }
    
    
}
