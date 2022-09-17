//
//  MainView.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/17.
//

import SwiftUI
import FirebaseDatabase

struct MainView: View {
    @State var lightStates: Array<Bool> = [false,false,false]
    var body: some View{
        let screanSize = UIScreen.main.bounds
        let ref = Database.database().reference()
        VStack{
            Rectangle()
                .frame(width: 200, height: 100)
                .cornerRadius(20)
            Spacer()
                .frame(width: 1, height: 100)
            HStack{
                Button{
                    ref.child("light/light1").setValue(!lightStates[0])
                    lightStates[0] = !lightStates[0]
                } label: {
                    Rectangle()
                        .fill(btnBackgoundColor(for: lightStates[0]))
                        .frame(width: (screanSize.width - 20) / 2, height: 150)
                        .cornerRadius(20)
                }

                Button{
                    ref.child("light/light2").setValue(!lightStates[1])
                    lightStates[1] = !lightStates[1]
                } label: {
                    Rectangle()
                        .fill(btnBackgoundColor(for: lightStates[1]))
                        .frame(width: (screanSize.width - 20) / 2, height: 150)
                        .cornerRadius(20)
                }
            }
            HStack{
                Button{
                    ref.child("light/light3").setValue(!lightStates[2])
                    lightStates[2] = !lightStates[2]
                } label: {
                    Rectangle()
                        .fill(btnBackgoundColor(for: lightStates[2]))
                        .frame(width: (screanSize.width - 20) / 2, height: 150)
                        .cornerRadius(20)

                }
                Button{
                    print(!lightStates[0])
                } label: {
                    Rectangle()
                        .fill(.red)
                        .frame(width: (screanSize.width - 20) / 2, height: 150)
                        .cornerRadius(20)
                }
            }
            Spacer()
                .frame(width: 1, height: 100)
            Button{
                for databaseIndex in 1...3{
                    ref.child("light/light\(databaseIndex)").observeSingleEvent(of: .value, with: { [self] snapshot in
                        let state = snapshot.value as? Bool
                        lightStates[databaseIndex - 1] = state ?? true
                        print(lightStates)
                    })
                }
            } label: {
                Text("refresh")
            }
            
        }
    }
    
    private func btnBackgoundColor(for state : Bool) -> Color{
        switch state{
        case true: return Color.yellow
        case false: return Color.gray
        }
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
