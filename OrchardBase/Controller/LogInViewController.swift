//
//  LogInViewController.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/16.
//

import UIKit
import SwiftUI
import FirebaseDatabase

class LogInViewController: UIViewController {

    let toMainButton = UIButton()
    let IDTextFiled = UITextField()
    let PWTextFiled = UITextField()
    let ref = Database.database().reference()
    let vc = UIHostingController(rootView: MainView())
    var User: String = ""
    var Password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(IDTextFiled)
        self.view.addSubview(toMainButton)
        self.view.addSubview(PWTextFiled)
        let screanSize = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        updateAuth()
        //configuring IDLbl
        IDTextFiled.translatesAutoresizingMaskIntoConstraints = false
        IDTextFiled.autocorrectionType = UITextAutocorrectionType.no
        IDTextFiled.autocapitalizationType = UITextAutocapitalizationType.none
        //IDTextFiled.placeholder = "Insert your ID"
        IDTextFiled.text = "dongju"
        IDTextFiled.addLeftPadding()
        IDTextFiled.layer.cornerRadius = 30
        IDTextFiled.backgroundColor = #colorLiteral(red: 0.8230885863, green: 0.8433898687, blue: 0.6238721013, alpha: 1)
        IDTextFiled.textColor = #colorLiteral(red: 0.2823529412, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        IDTextFiled.widthAnchor.constraint(equalToConstant: screanSize.width - 70).isActive = true
        IDTextFiled.heightAnchor.constraint(equalToConstant: screanSize.height / 15).isActive = true
        IDTextFiled.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        IDTextFiled.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //configuring PWLbl
        PWTextFiled.translatesAutoresizingMaskIntoConstraints = false
        PWTextFiled.autocorrectionType = UITextAutocorrectionType.no
        PWTextFiled.autocapitalizationType = UITextAutocapitalizationType.none
        //PWTextFiled.placeholder = "Insert your password"
        PWTextFiled.addLeftPadding()
        PWTextFiled.text = "qwerasdf"
        PWTextFiled.layer.cornerRadius = 30
        PWTextFiled.backgroundColor = #colorLiteral(red: 0.8230885863, green: 0.8433898687, blue: 0.6238721013, alpha: 1)
        PWTextFiled.textColor = #colorLiteral(red: 0.5647058824, green: 0.7176470588, blue: 0.4901960784, alpha: 1)
        PWTextFiled.widthAnchor.constraint(equalToConstant: screanSize.width - 70).isActive = true
        PWTextFiled.heightAnchor.constraint(equalToConstant: screanSize.height / 15).isActive = true
        PWTextFiled.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        PWTextFiled.topAnchor.constraint(equalTo: self.IDTextFiled.topAnchor, constant: 100).isActive = true
        
        //configuring button
        toMainButton.translatesAutoresizingMaskIntoConstraints = false
        toMainButton.setTitle("로그인", for: .normal)
        toMainButton.setTitleColor(.black, for: .normal)
        toMainButton.layer.cornerRadius = 30
        toMainButton.backgroundColor = #colorLiteral(red: 0.8230885863, green: 0.8433898687, blue: 0.6238721013, alpha: 1)
        toMainButton.setTitleColor(#colorLiteral(red: 0.2823529412, green: 0.2196078431, blue: 0.2196078431, alpha: 1), for: .normal) 
        
        toMainButton.widthAnchor.constraint(equalToConstant: screanSize.width - 70).isActive = true
        toMainButton.heightAnchor.constraint(equalToConstant: screanSize.height / 15).isActive = true
        toMainButton.topAnchor.constraint(equalTo: self.PWTextFiled.topAnchor, constant: 100).isActive = true
        toMainButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        toMainButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction(sender: UIButton){
        if(User == IDTextFiled.text && Password == PWTextFiled.text){
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //로그인에 실패했을때 실패 에니메이션 추가
        IDTextFiled.text = ""
        PWTextFiled.text = ""
    }
    
    func updateAuth() {
        ref.child("Auth/user").observeSingleEvent(of: .value, with: { [self] snapshot in
            let user = snapshot.value as? String
            User = user ?? ""
        })
        ref.child("Auth/Password").observeSingleEvent(of: .value, with: { [self] snapshot in
            let password = snapshot.value as? String
            Password = password ?? ""
        })
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension UITextField{
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

