//
//  PreferencesController.swift
//  i7NiuForMac
//
//  Created by hocgin on 22/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Cocoa

class PreferencesController: NSViewController {
    
    @IBOutlet weak var accessView: NSSecureTextField!
    @IBOutlet weak var secretView: NSSecureTextField!
    @IBOutlet weak var domainView: NSTextField!
    @IBOutlet weak var bucketView: NSTextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessView.stringValue = defaults.string(forKey: "accessKey") ?? ""
        self.secretView.stringValue = defaults.string(forKey: "secretKey") ?? ""
        self.bucketView.stringValue = defaults.string(forKey: "bucket") ?? ""
        self.domainView.stringValue = defaults.string(forKey: "domain") ?? ""
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.view.window?.close()
    }
    @IBAction func confirmAction(_ sender: Any) {
        // todo 后期更改为 ⚠️警告框
        if self.accessView.stringValue.isEmpty {
            Utils.showNotify(title: "校验错误", text: "Access Key 不能为空, 请前往七牛获取!!!")
        } else if self.secretView.stringValue.isEmpty {
            Utils.showNotify(title: "校验错误", text: "Secret Key 不能为空, 请前往七牛获取!!!")
        } else if self.bucketView.stringValue.isEmpty {
            Utils.showNotify(title: "校验错误", text: "Bucket 不能为空, 请前往七牛获取!!!")
        } else if self.domainView.stringValue.isEmpty {
            Utils.showNotify(title: "校验错误", text: "Domain 不能为空, 请前往七牛获取!!!")
        } else {
            defaults.setValuesForKeys([
                "accessKey": accessView.stringValue,
                "secretKey": secretView.stringValue,
                "bucket": bucketView.stringValue,
                "domain": domainView.stringValue
                ])
            self.view.window?.close()
        }
    }
}
