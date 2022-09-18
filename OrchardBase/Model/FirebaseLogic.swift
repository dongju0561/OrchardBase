//
//  FirebaseLogic.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/17.
//

import Foundation
import FirebaseDatabase


struct FirebaseLogic {
    var array: Array<Bool> = [false,false,false]
    let ref = Database.database().reference()
    
    mutating func updateState() {
        var temp: Bool = false
    }
}
