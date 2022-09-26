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
                    }
                    label: {
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
    @State var toggleState = false
    var body: some View{
        NavigationView {
            ZStack{
                Color.graceGreen
                    .ignoresSafeArea()
                    
                VStack {
                    Button{
                        toggleState.toggle()
                        changeStateOfAircon(state: toggleState)
                    }label: {
                        ZStack{
                            Circle()
                                .fill(Color.brighGreen)
                                .frame(width: 80, height: 80)
                                
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
            }.onAppear(
                
            )
        }
    }
}

func changeStateOfAircon(state: Bool) {
    let ref = Database.database().reference()
    if(state){
        ref.child("Airconditioner/power").setValue("true")
    }
    else{
        ref.child("Airconditioner/power").setValue("false")
    }
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

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
