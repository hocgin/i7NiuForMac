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
let CompressSettingKey = "compressState"
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
}



// 设置
// 压缩
// about
// bug
// logo
