//
//  HDNotifPopViewViewController.swift
//  HDMasterProject
//
//  Created by 邓立兵 on 2021/2/24.
//  Copyright © 2021 HarryDeng. All rights reserved.
//

import UIKit

class HDNotifPopViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showNotifPopView()
    }

    private func showNotifPopView() {
        let obj = HDNotifObj()
        obj.title = "消息中心"
        obj.text = "消息中心消息中心消息中心消息中心消息中心消息中心消息中心消息中心消息中心消息中心"
        HDNotifPopManager.showNotifPopView(notif: obj) {
            debugPrint("tapHandler")
        }
    }
}
