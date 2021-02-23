//
//  HDProtocol.swift
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/12/14.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

import UIKit

protocol Greatable {
    var name: String { get }
    func greet()
}

extension Greatable {
    func greet() {
        print("hello \(name)")
    }
}

struct Person: Greatable {
    var name: String
    
    func greet() {
        print("hello \(name) person")
    }
}

struct Cat: Greatable {
    var name: String
}
