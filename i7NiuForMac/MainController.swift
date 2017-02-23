//
//  MainController.swift
//  i7NiuForMac
//
//  Created by hocgin on 19/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Cocoa

class MainController: NSObject, NSWindowDelegate, NSDraggingDestination {

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var uploadFileListView: UploadFileListView!
    let dragStatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    var uploadManager:I7NiuUploadManager!
    
    override func awakeFromNib() {
        dragStatusItem.title = "i7Niu"
        dragStatusItem.menu = self.menu
        
        // 注册拖拉
        dragStatusItem.button?.window?.registerForDraggedTypes([NSFilenamesPboardType])
        dragStatusItem.button?.window?.delegate = self
        
        // 设置上传显示列表
        let uploadFilesView = self.menu.item(withTag: 1)!
        uploadFilesView.isHidden = true

        uploadManager = I7NiuUploadManager()
    }
    
    // 显示上传文件历史记录
    func showUploadFileHistory(){
        if let item = self.menu.item(withTag: 1), item.isHidden {
            item.view = self.uploadFileListView
            item.isHidden = false
        }
    }
    
    // 开启文件拖动，+ 号
    func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.copy
    }
    
    // 上传文件
    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard()
        let filePaths = pasteboard.propertyList(forType: NSFilenamesPboardType) as! NSArray
        self.uploadManager.uploadFiles(filePaths: filePaths, callback: { models in
            self.uploadFileListView.loadModel(models: models)
            self.showUploadFileHistory()
        })
        return true
    }
    
    // 粘贴板数据上传..
    @IBAction func uploadForClipboard(_ sender: Any) {
        let pasteboard = NSPasteboard.general()
        if let imageData = pasteboard.data(forType: NSPasteboardTypePNG){
            // TODO 开启上传状态
            
            self.uploadManager.uploadData(imageData: imageData, callback: { models in
                self.uploadFileListView.loadModel(models: models)
                self.showUploadFileHistory()
            })
            // TODO 关闭上传状态
            
        }else{
            Utils.showNotify(title: "数据格式错误", text: "粘贴板的非图片！")
        }
    }
    
    // Quit Application
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
}
