//
//  7NiuUploadManager.swift
//  i7NiuForMac
//
//  Created by hocgin on 19/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//
import Cocoa

import SwiftyJSON
import CryptoSwift
import Qiniu
import PromiseKit


class I7NiuUploadManager {
    
    let shareWorkspace = NSWorkspace.shared()
    let uploadManager = QNUploadManager()!
    let fileManager = FileManager()
    
    // 获取上传 Token
    func get7NiuToken(fileName: String) -> String{
        let deadline = round(NSDate(timeIntervalSinceNow: 3600).timeIntervalSince1970)
        let policyData:JSON = [
            "scope": "\(UserInfo.getBucket()):\(fileName)",
            "deadline": deadline
        ]
        // 签名字符串
        let encodedPutPolicy = QNUrlSafeBase64.encode(policyData.rawString()!)!
        // 计算HMAC-SHA1签名
        let secretSign = try! HMAC(key: (UserInfo.getSecretKey().utf8.map({$0})), variant: .sha1).authenticate((encodedPutPolicy.utf8.map({$0})))
        // 将加密后的数据用 Base64 编码
        let encodedSign = QNUrlSafeBase64.encode(Data(bytes: secretSign))!
        // 生成上传凭证
        let policy:String = [UserInfo.getAccessKey(), encodedSign, encodedPutPolicy].joined(separator: ":")
        NSLog("[String Token]: \n\(policy)")
        return policy
    }
    
    // 上传至七牛
    private func uploadFile(filePath:String) -> Promise<UploadFileModel>{
        return Promise{ fulfill, reject in
            let fileType = try! shareWorkspace.type(ofFile: filePath)
            let fileAttr = try! fileManager.attributesOfItem(atPath: filePath) as NSDictionary
            let fileSize = fileAttr.fileSize()
            // 从路径中获取文件名
            let fileName = NSURL(fileURLWithPath: filePath).lastPathComponent!
            let uploadToken = get7NiuToken(fileName: fileName)
            
            // 上传
            if UserInfo.getCompressionState() == NSOnState && CompressFileTypes.contains(fileType) && fileSize > MaxImageSize { // 压缩图片后上传
                self.uploadManager.put( Utils.compressionImage(filePath: filePath), key: fileName, token: uploadToken, complete: { info, key, resp -> Void in
                    if (info?.isOK)! {
                        let model = self.createUploadFileModel(filename: key!, filePath: filePath, fileType: fileType)
                        fulfill(model)
                    }else{
                        reject((info?.error)!)
                    }
                }, option: nil)
            } else {
                // Upload, 华东地区用默认配置，其他地区更改 Zone
                self.uploadManager.putFile(filePath, key: fileName, token: uploadToken, complete: { info, key, resp -> Void in
                    if (info?.isOK)! {
                        let model = self.createUploadFileModel(filename: key!, filePath: filePath, fileType: fileType)
                        fulfill(model)
                    }else{
                        reject((info?.error)!)
                    }
                }, option: nil)
            }
        }
    }
    
    // 上传文件
    func uploadFiles(filePaths: NSArray, callback: @escaping ([UploadFileModel])->Void) -> Void {
        var uploadFiles: [Promise<UploadFileModel>] = []
        for filePath in filePaths {
            uploadFiles.append(uploadFile(filePath: filePath as! String))
        }
        
        when(fulfilled: uploadFiles).then(execute: { models -> Void in
            callback(models)
        }).catch(execute: {error in
            Utils.showNotify(title: "错误", text: "上传失败！")
        })
    }
    
    // 上传数据
    func uploadData(imageData: Data, callback: @escaping ([UploadFileModel])->Void){
        let filename = "\(NSUUID().uuidString).png"
        let token = self.get7NiuToken(fileName: filename)
        
        uploadManager.put(imageData, key: filename, token: token, complete: {info, key, resp -> Void in
            if (info?.isOK)! {
                let model = self.createUploadFileModel(filename: filename, imageData: imageData)
                let models: [UploadFileModel] = [model]
                callback(models)
            }else{
                Utils.showNotify(title: "错误", text: "上传失败！")
            }
        }, option: nil)
    }
    
    // 创建 Model for Data
    func createUploadFileModel(filename: String, imageData: Data) -> UploadFileModel {
        let imageUrl = "\(UserInfo.getDomain())/\(filename)"
        let fileIcon = NSImage(data: imageData)!
        return UploadFileModel(image: fileIcon, url: imageUrl, filename: filename)
    }
    
    // 创建 Model for File Path
    func createUploadFileModel(filename: String, filePath: String, fileType: String) -> UploadFileModel {
        let imageUrl = "\(UserInfo.getDomain())/\(filename)"
        let fileIcon = { () -> NSImage in
            if ImageFileTypes.contains(fileType) {
                return NSImage(contentsOfFile: filePath)!
            }
            else {
                return self.shareWorkspace.icon(forFile: filePath)
            }
        }()
        return UploadFileModel(image: fileIcon, url: imageUrl, filename: filename)
    }
}
