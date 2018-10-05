//
//  SocketIOManager.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 29/09/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var socket: SocketIOClient!
    let manager = SocketManager(socketURL: URL(string: "10.54.162.195:9800")!, config: [.log(true), .compress])
    
    override init() {
        super.init()
        
        socket = manager.defaultSocket
    }
    
    func connectSocket(){
        let token = "ASDF"
        
        self.manager.config = SocketIOClientConfiguration(arrayLiteral: .connectParams(["token": token]), .secure(false))
        socket.connect()
    }
    
    func receiveMsg(){
        socket.on("new message here") { (dataArray, ack) in
            print(dataArray.count)
        }
    }
    
    func sendMessage(text: String){
//        socket.on("message") { (data, ack) in
//            self.socket.emit("message", data)
//        }
        
        socket.on(clientEvent: SocketClientEvent.connect) { (data, ack) in
            print("conectou porra")
        }
        
        socket.on(clientEvent: .statusChange) { (data, ack) in
            print("boom")
        }
        
    }
    
}
