//
//  HDNetwork.swift
//  HDMasterProject
//
//  Created by 邓立兵 on 2020/12/15.
//  Copyright © 2020 HarryDeng. All rights reserved.
//

import Foundation

enum HTTPMethid: String {
    case GET
    case POST
}

struct User {
    let type: String
    let url: String
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        guard let type = obj["type"] as? String else {
            return nil
        }
        guard let url = obj["url"] as? String else {
            return nil
        }
        
        self.type = type
        self.url = url
    }
}

extension User: Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}

protocol Request {
    var host: String { get }
    var path: String { get }
    
    var method: HTTPMethid { get }
    var paramter: [String: Any] { get }
    
    associatedtype Response: Decodable
//    func parse(data: Data) -> Response?
}

extension Request {
    func send(handle: @escaping (Response?) -> Void) {
        let url = URL(string: host.appending(path))!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if let data = data, let res = Response.parse(data: data) {
                DispatchQueue.main.async {
                    handle(res)
                }
            }
            else {
                DispatchQueue.main.async {
                    handle(nil)
                }
            }
        }
        task.resume()
    }
}

struct UserRequest: Request {
    func parse(data: Data) -> User? {
        return User(data: data)
    }
    
    var host: String = "https://hacker-news.firebaseio.com"
    var path: String = "/v0/item/8863.json?print=pretty"
    var method: HTTPMethid = .GET
    var paramter: [String : Any] = [:]
    
    typealias Response = User
}


protocol Client {
    /*
     func send(_ r: Request, handler: @escaping (Request.Response?) -> Void)
     会编译报错
     */

    // 是因为 Request是含有关联类型的协议，所以它并不能作为独立的类型来使用，
    // 我们只能够将它作为类型约束，来限制输入参数 request。正确的声明方式应当是：
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)
    
    var host: String { get }
}

struct URLSessionClient: Client {
    func send<T>(_ r: T, handler: @escaping (T.Response?) -> Void) where T : Request {
        let url = URL(string: host.appending(r.path))
        var request = URLRequest(url: url!)
        request.httpMethod = r.method.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
    
    let host: String = "https://hacker-news.firebaseio.com"
    
}

protocol Decodable {
    static func parse(data: Data) -> Self?
}
