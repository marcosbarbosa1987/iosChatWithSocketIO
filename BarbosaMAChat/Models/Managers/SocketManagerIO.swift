//
//  SocketManagerIO.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 10/11/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import Foundation
import SocketIO

class SocketManagerIO: NSObject {
    
    static let shared = SocketManagerIO()
    internal var socket: SocketIOClient!
    private var manager: SocketManager!
    
    override init() {
        super.init()
    }
    
    internal func socketConnect(withIP ip: String, port: String) {
        
        manager = SocketManager(socketURL: URL(string: "http://\(ip):\(port)/")!, config: [.log(true), .compress])
//        manager = SocketManager(socketURL: URL(string: "https://whispering-bastion-25939.herokuapp.com/:8080")!, config: [.log(true), .compress, .forceWebsockets(true)])
//        manager = SocketManager(socketURL: URL(string: "http://whispering-bastion-25939.herokuapp.com/")!, config: [.log(true), .compress, .forcePolling(false)])
        socket = manager.defaultSocket
       
        socket.connect()
//        web: python script.py
    }
    
    internal func socketDesconect() {
        socket.disconnect()
    }
    
    internal func socketUpdateData() {
        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                self.socket.emit("update", ["amount": cur + 2.50])
            }
            
            ack.with("Got your currentAmount", "dude")
        }
    }
    
    internal func socketSendMessage(withMessage message: String) {
         socket.emit("my message", message)
    }
    
    internal func socketIsWriting(withUser user: String, isWriting: Bool) {
        if isWriting {
            socket.emit("writing", user)
        } else {
            socket.emit("writing", "")
        }
    }
    
    internal func socketIsLogged(withUser user: String) {
        socket.emit("loggedUser", user)
    }
    
    internal func socketIsNotLogged(withUser user: String) {
        socket.emit("logoutUser", user)
    }
    
}
