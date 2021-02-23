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
        
        Person(name: "harry").greet()
        Cat(name: "ww").greet()
        
        UserRequest().send { (user) in
            print("user1: \(user?.url)")
        }
        
        URLSessionClient().send(UserRequest()) { (user) in
            print("user2: \(user?.url)")
        }
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


