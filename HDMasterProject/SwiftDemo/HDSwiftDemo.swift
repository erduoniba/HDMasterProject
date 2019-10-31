//
//  HDSwiftDemo.swift
//  HDMasterProject
//
//  Created by 邓立兵 on 2019/10/23.
//  Copyright © 2019 HarryDeng. All rights reserved.
//

import UIKit

enum HDDemoState: String, CaseIterable {
    case happy = "happy"
    case cry = "cry"
    case worry = "worry"
}

class HDSwiftDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        enumTest()
    }
    
    
    func enumTest() {
        // CaseIterable.allCases
        // https://www.jianshu.com/p/92b88e4525d1
        print(HDDemoState.allCases)
        for type in HDDemoState.allCases {
            print(type)
        }
    }
}


