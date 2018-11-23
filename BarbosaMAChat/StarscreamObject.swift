//
//  StarscreamObject.swift
//  BarbosaMAChat
//
//  Created by Marcos Barbosa on 06/11/18.
//  Copyright © 2018 Marcos Barbosa. All rights reserved.
//

import Foundation
import Starscream

class StarscreamObject: NSObject, WebSocketDelegate {
    
    
    static let shared = StarscreamObject()
    var socket: WebSocket!
    
    override init() {
        super.init()
        
//        var request = URLRequest(url: URL(string: "ws://192.168.25.4:7000/")!)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 5
//        let socket = WebSocket(request: request)
//        socket.delegate = self
//        socket.connect()
        
       
    }
    
    func conect() {

        self.socket = WebSocket(url: URL(string: "ws://192.168.25.4:8443/")!, protocols: ["chat"])
        self.socket.delegate = self
        print("trying to connect")
        self.socket.connect()
        
        
    }
    
    func sendMessage(_ message: String) {
        self.socket.write(string: message)
        self.websocketDidReceiveMessage(socket: socket, text: "Boommmmm")
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        socket.write(string: "Boom")
        print("Conectou")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Desconectou \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Recebeu mensagem \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Recebeu um objeto")
    }
    
    
}
