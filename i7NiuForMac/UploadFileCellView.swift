//
//  UploadFileCellView.swift
//  i7NiuForMac
//
//  Created by hocgin on 20/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Cocoa

class UploadFileCellView: NSTableCellView {
    @IBOutlet weak var uploadImageView: NSImageView!
    @IBOutlet weak var line: NSBox!

    @IBOutlet weak var fileNameView: NSTextField!
    
    var imageName:String!
    var imageUrl:String!
    var imageUrlString:String {
        get {
            return self.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        }
    }
    
    @IBAction func clickMdAction(_ sender: NSButton) {
        Utils.copyString(text: "![\(self.imageName ?? "image")](\(self.imageUrlString))")
        Utils.showNotify(title: "MarkDown复制提示", text: "已成功复制")
    }
    
    @IBAction func clickUrlAction(_ sender: NSButton) {
        Utils.copyString(text: self.imageUrlString)
        Utils.showNotify(title: "URL复制提示", text: "已成功复制")
    }
}
