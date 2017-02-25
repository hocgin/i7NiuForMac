//
//  UploadFileListView.swift
//  i7NiuForMac
//
//  Created by hocgin on 20/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Cocoa

class UploadFileListView: NSView , NSTableViewDelegate, NSTableViewDataSource {
    let cellIdentifier = "uploadFileCell"

    @IBOutlet weak var uploadImageListView: NSTableView!
    var uploadFileCellDatas: Array<UploadFileModel> = []
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.uploadFileCellDatas.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: self.cellIdentifier, owner: nil) as? UploadFileCellView {
            let model = uploadFileCellDatas[row]
            cell.imageUrl = model.imageUrl
            cell.uploadImageView.image = model.image
            cell.fileNameView.stringValue = model.filename
            return cell
        }
        return nil
    }
    
    
    // 新增上次成功后的列表
    func loadModel(models: [UploadFileModel]){
            let maxCount = 9
            self.uploadFileCellDatas += models
            // 设置排序，倒序
            self.uploadFileCellDatas = self.uploadFileCellDatas.reversed()
            // 若数量>maxCount, 则进行截取
            if self.uploadFileCellDatas.count > maxCount {
                self.uploadFileCellDatas = Array(self.uploadFileCellDatas[0..<maxCount])
            }
            self.uploadImageListView.reloadData()
    }
    
}
