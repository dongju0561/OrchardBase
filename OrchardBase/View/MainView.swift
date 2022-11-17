//
//  MainView.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/17.
//

import SwiftUI
import FirebaseDatabase

struct MainView: View {
    init() {
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.5635787845, green: 0.7178360224, blue: 0.4905223846, alpha: 1)
    }
    var body: some View{
        
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            ControlView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Control")
                }
                .tag(1)
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "eyes.inverse")
                    Text("Check")
                }
                .tag(2)
        }
        .accentColor(.brighGreen)
    }
}

struct ControlView: View{
    @State var lightStates: Array<Bool> = [false,false,false]
    @State var isModalSheetShown: Bool = false
    
    var body: some View{
        let screanSize = UIScreen.main.bounds
        let ref = Database.database().reference()
        
        ZStack{
            Color.graceGreen
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button{
                        ref.child("light/light1").setValue(!lightStates[0])
                        changeState()
                        lightStates[0] = !lightStates[0]
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(btnBackgoundColor(for: lightStates[0]))
                                .frame(width: (screanSize.width - 20) / 2, height: 150)
                                .cornerRadius(40)
                            HStack{
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 30))
                                    .foregroundColor(.bearBrown)
                                Text("거실")
                                    .font(.system(size: 25))
                                    .foregroundColor(.bearBrown)
                            }
                        }
                    }
                    
                    Button{
                        ref.child("light/light2").setValue(!lightStates[1])
                        changeState()
                        lightStates[1] = !lightStates[1]
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(btnBackgoundColor(for: lightStates[1]))
                                .frame(width: (screanSize.width - 20) / 2, height: 150)
                                .cornerRadius(40)
                            HStack{
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 30))
                                    .foregroundColor(.bearBrown)
                                Text("현관")
                                    .font(.system(size: 25))
                                    .foregroundColor(.bearBrown)
                            }
                        }
                    }
                }
                HStack{
                    Button{
                        ref.child("light/light3").setValue(!lightStates[2])
                        changeState()
                        lightStates[2] = !lightStates[2]
                    } label: {
                        ZStack{
                            Rectangle()
                                .fill(btnBackgoundColor(for: lightStates[2]))
                                .frame(width: (screanSize.width - 20) / 2, height: 150)
                                .cornerRadius(40)
                            HStack{
                                Image(systemName: "lightbulb")
                                    .font(.system(size: 25))
                                    .foregroundColor(.bearBrown)
                                Text("화장실")
                                    .font(.system(size: 25))
                                    .foregroundColor(.bearBrown)
                            }
                        }
                    }
                    Button{
                        self.isModalSheetShown = true
                    }label: {
                        ZStack{
                            Rectangle()
                                .fill(Color.bearBrown)
                                .frame(width: (screanSize.width - 20) / 2, height: 150)
                                .cornerRadius(40)
                            Text("에어컨")
                                .font(.system(size: 25))
                                .foregroundColor(.brighGreen)
                        }
                    }
                    .sheet(isPresented: $isModalSheetShown) {
                        AirconditionView()
                    }
                    
                }
                Spacer()
                    .frame(width: 1, height: 100)
                
            }.onAppear(perform: {
                print("it workedx")
                for databaseIndex in 1...3{
                    ref.child("light/light\(databaseIndex)").observeSingleEvent(of: .value, with: { [self] snapshot in
                        let state = snapshot.value as? Bool
                        lightStates[databaseIndex - 1] = state ?? true
                    })
                }
            })
        }
    }
    private func btnBackgoundColor(for state : Bool) -> Color{
        switch state{
        case true: return Color.brighGreen
        case false: return Color.gray
        }
    }
}

struct AirconditionView: View{
    @Environment(\.dismiss) var dismiss
    @State var power: Bool = false
    let ref = Database.database().reference()
    
    @State var dTemp: String = ""
    @State var temp: String = "23"
    var body: some View{
        NavigationView {
            ZStack{
                Color.graceGreen
                    .ignoresSafeArea()
                    
                VStack {
                    Spacer()
                        .frame(height: 1)
                    Text("에어컨 리모콘")
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.brighGreen)
                        .background(Color.bearBrown)
                    Spacer()
                        .frame(height: 30)
                    VStack{
                        Text("설정 온도")
                        HStack{
                            Text("\(temp) ℃")
                                .font(.system(size: 50))
                                .fontWeight(.heavy)
                        }
                    }
                    HStack{
                        Text("희망 온도:")
                            .font(.system(size: 25))
                            .foregroundColor(.brighGreen)
                            .fontWeight(.heavy)
                        
                        TextField("16℃ ~ 32℃", text: $dTemp)
                            .textFieldStyle(.plain)
                            .font(.system(size: 14))
                            .padding(.leading,10)
                            .frame(width: 100,height: 40, alignment: .trailing)
                            .background(Color.brighGreen)
                            .cornerRadius(15)
                            .keyboardType(.decimalPad)
                        
                        Button {
                            if(16 <=  Int(dTemp)! && Int(dTemp)! <= 32){
                                temp = dTemp
                                UIApplication.shared.endEditing()
                                ref.child("Airconditioner/dTemp").setValue("\(dTemp)")
                                changeState()
                                dTemp = ""
                            }
                            else{
                                dTemp = ""
                                UIApplication.shared.endEditing()
                            }
                        }label: {
                            Image(systemName: "paperplane.circle.fill")
                                .foregroundColor(.brighGreen)
                                .font(.system(size: 30))
                                .padding(.leading,10)
                        }
                    }
                    .frame(width: 300, height: 55, alignment: .center)
                    .background(Color.bearBrown)
                    .cornerRadius(20)
                    
                    Spacer()
                    ZStack{
                        VStack{
                            Button{
                                if(Int(temp)! < 32){
                                    temp = String((Int(temp)! + 1))
                                    ref.child("Airconditioner/dTemp").setValue("\(temp)")
                                    changeState()
                                }
                            }label: {
                                ZStack{
                                    Circle()
                                        .fill(Color.bearBrown)
                                        .frame(width: 80)
                                    Image(systemName: "chevron.up")
                                        .foregroundColor(.brighGreen)
                                        .font(.system(size: 30))
                                        .fontWeight(.heavy)
                                }
                            }
                            Spacer()
                                .frame(height: 60)
                            Button{
                                if(Int(temp)! > 16){
                                    temp = String((Int(temp)! - 1))
                                    ref.child("Airconditioner/dTemp").setValue("\(temp)")
                                    changeState()
                                }
                            }label: {
                                ZStack{
                                    Circle()
                                        .fill(Color.bearBrown)
                                        .frame(width: 80)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.brighGreen)
                                        .font(.system(size: 30))
                                        .fontWeight(.heavy)
                                }
                            }
                        }
                        HStack{
                            Button{
                                
                            }label: {
                                ZStack{
                                    Circle()
                                        .fill(Color.bearBrown)
                                        .frame(width: 80)
                                    Image(systemName: "m.circle")
                                        .foregroundColor(.brighGreen)
                                        .font(.system(size: 30))
                                        .fontWeight(.heavy)
                                }
                            }
                            Spacer()
                                .frame(width: 60 )
                            Button{
                                
                            }label: {
                                ZStack{
                                    Circle()
                                        .fill(Color.bearBrown)
                                        .frame(width: 80)
                                    Image(systemName: "wind")
                                        .foregroundColor(.brighGreen)
                                        .font(.system(size: 30))
                                        .fontWeight(.heavy)
                                }
                            }
                        }
                    }
                    Spacer()
                    Button{
                        power = changePower(power: power)
                    }label: {
                        ZStack{
                            Circle()
                                .fill(Color.brighGreen)
                                .frame(width: 80)
                                
                            Image(systemName: "power")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                                .fontWeight(.heavy)
                        }
                    }
                }
                .navigationBarItems(trailing: Button("Done",action: {
                    dismiss()
                }))
            }
        }
    }
}
func changeState(){
    let ref = Database.database().reference()
    ref.child("state").setValue(true)
}

func changePower(power: Bool) -> Bool {
    let ref = Database.database().reference()
    ref.child("Airconditioner/power").setValue(!power)
    changeState()
    return !power
}

extension Color{
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
      }
    
    static let graceGreen = Color(hex: "#90B77D")
    static let brighGreen = Color(hex: "#D2D79F")
    static let bearBrown = Color(hex: "#483838")
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        AirconditionView()
    }
}
