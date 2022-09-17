//
//  ViewController.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/15.
//

import UIKit
import SwiftUI
import FirebaseDatabase

class MainViewController: UIViewController {

    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var light1: UISwitch!
    @IBOutlet weak var inputData: UITextField!
    
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        light1.isOn = false
        
        }

    
    @IBAction func writeOnDatabase(_ sender: Any) {
        guard let safedata = Int(inputData.text ?? "0") else {return}
        ref.child("test").setValue("\(safedata)")
        
        ref.child("test").observeSingleEvent(of: .value, with: { [self] snapshot in
            let value = snapshot.value as? Int
            temp.text = "\(value!)"
        })
        
        inputData.text = ""
    }
    @IBAction func switchLight(_ sender: UISwitch) {
        if sender.isOn == true{
            ref.child("light1").setValue(true)
        }
        else{
            ref.child("light1").setValue(false)
        }
        
    }
    
}

