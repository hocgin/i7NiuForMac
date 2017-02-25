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
    let defaults = UserDefaults.standard;
    
    
    
    override func awakeFromNib() {
        dragStatusItem.image = #imageLiteral(resourceName: "i7Niu-32x32")
        dragStatusItem.menu = self.menu
        
        // 注册拖拉
        dragStatusItem.button?.window?.registerForDraggedTypes([NSFilenamesPboardType])
        dragStatusItem.button?.window?.delegate = self
        
        // 设置上传显示列表
        let uploadFilesView = self.menu.item(withTag: 1)!
        uploadFilesView.isHidden = true

        uploadManager = I7NiuUploadManager()
        
        // Compression Status
        if let compressionItem = self.menu.item(withTag: 2) {
            compressionItem.state = UserInfo.getCompressionState();
        }
        
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
    
    // 设置是否压缩
    @IBAction func compressionStatusAction(_ sender: NSMenuItem) {
        let state: Int = { () -> Int in
            let state = defaults.integer(forKey: "compressionState")
            if state == NSOnState {
                return NSOffState
            }
            else {
                return NSOnState
            }
        }()
        sender.state = state
        defaults.set(state, forKey: CompressSettingKey)
        defaults.synchronize()
    }
    
    // 上传文件
    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard()
        let filePaths = pasteboard.propertyList(forType: NSFilenamesPboardType) as! NSArray
        // 开启上传状态
        dragStatusItem.image = #imageLiteral(resourceName: "upload")
        self.uploadManager.uploadFiles(filePaths: filePaths, callback: { models in
            self.uploadFileListView.loadModel(models: models)
            self.showUploadFileHistory()
            // 关闭上传状态
            self.dragStatusItem.image = #imageLiteral(resourceName: "i7Niu-32x32")
        })
        return true
    }
    
    // 粘贴板数据上传..
    @IBAction func uploadForClipboard(_ sender: Any) {
        let pasteboard = NSPasteboard.general()
        if let imageData = pasteboard.data(forType: NSPasteboardTypePNG){
            // 开启上传状态
            dragStatusItem.image = #imageLiteral(resourceName: "upload")
            self.uploadManager.uploadData(imageData: imageData, callback: { models in
                self.uploadFileListView.loadModel(models: models)
                self.showUploadFileHistory()
                // 关闭上传状态
                self.dragStatusItem.image = #imageLiteral(resourceName: "i7Niu-32x32")
            })
            
        }else{
            Utils.showNotify(title: "数据格式错误", text: "粘贴板的非图片！")
        }
    }
    
    @IBAction func openURL(_ sender: NSMenuItem) {
        NSLog(sender.identifier!)
        let urls = [
            "http://github.com/hocgin",
            "http://weibo.com/hocgin",
            "https://hocg.in"
        ]
        
        if let url = URL(string: urls[sender.tag]), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }
    }
    
    // Quit Application
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
}
