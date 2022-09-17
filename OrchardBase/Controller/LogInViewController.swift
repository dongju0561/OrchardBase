//
//  LogInViewController.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/16.
//

import UIKit
import SwiftUI

class LogInViewController: UIViewController {

    let toMainButton = UIButton()
    let IDLbl = UILabel()
    let PWLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(IDLbl)
        self.view.addSubview(toMainButton)
        self.view.addSubview(PWLbl)
        let screanSize = UIScreen.main.bounds
        
        //configuring common
        IDLbl.translatesAutoresizingMaskIntoConstraints = false
        PWLbl.translatesAutoresizingMaskIntoConstraints = false
        toMainButton.translatesAutoresizingMaskIntoConstraints = false
        
        //configuring IDLbl
        IDLbl.text = "ID"
        IDLbl.backgroundColor = .orange
        IDLbl.widthAnchor.constraint(equalToConstant: screanSize.width - 70).isActive = true
        IDLbl.heightAnchor.constraint(equalToConstant: screanSize.height / 15).isActive = true
        IDLbl.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        IDLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //configuring PWLbl
        PWLbl.text = "Password"
        PWLbl.backgroundColor = .orange
        PWLbl.widthAnchor.constraint(equalToConstant: screanSize.width - 70).isActive = true
        PWLbl.heightAnchor.constraint(equalToConstant: screanSize.height / 15).isActive = true
        PWLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        PWLbl.topAnchor.constraint(equalTo: self.IDLbl.topAnchor, constant: 100).isActive = true
        
        //configuring button
        toMainButton.setTitle("로그인", for: .normal)
        toMainButton.setTitleColor(.black, for: .normal)
        toMainButton.backgroundColor = .orange
        toMainButton.widthAnchor.constraint(equalToConstant: screanSize.width - 70).isActive = true
        toMainButton.heightAnchor.constraint(equalToConstant: screanSize.height / 15).isActive = true
        toMainButton.topAnchor.constraint(equalTo: self.PWLbl.topAnchor, constant: 100).isActive = true
        toMainButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
