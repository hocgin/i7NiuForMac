//
//  Utils.swift
//  i7NiuForMac
//
//  Created by hocgin on 20/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Cocoa

class Utils {

    // 弹出通知
    static func showNotify(title:String, text: String){
        let failNotification = NSUserNotification()
        failNotification.title = title
        failNotification.informativeText = text
        NSUserNotificationCenter.default.deliver(failNotification)
    }
    
    // 复制到粘贴板
    static func copyString(text:String){
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(text, forType: NSPasteboardTypeString)
    }
    
    // 压缩图片
    static func compressionImage(filePath: String) -> Data {
        let image = NSImage(contentsOfFile: filePath)!
        let bitmapImageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
        let compressOption:NSDictionary = [NSImageCompressionFactor: 0.3]
        let imageData = bitmapImageRep?.representation(using: NSJPEGFileType, properties: compressOption as! [String : Any])
        return imageData!
    }
    
}
