//
//  MainView.swift
//  OrchardBase
//
//  Created by Dongju Park on 2022/09/17.
//

import SwiftUI
import FirebaseDatabase

struct MainView: View {
    var body: some View{
        let screanSize = UIScreen.main.bounds
        
        VStack{
            Rectangle()
                .frame(width: 200, height: 100)
                .cornerRadius(20)
            Spacer()
                .frame(width: 1, height: 100)
            HStack{
                Rectangle()
                    .fill(.red)
                    .frame(width: (screanSize.width - 20) / 2, height: 150)
                    .cornerRadius(20)
                Rectangle()
                    .fill(.red)
                    .frame(width: (screanSize.width - 20) / 2, height: 150)
                    .cornerRadius(20)
            }
            HStack{
                Rectangle()
                    .fill(.red)
                    .frame(width: (screanSize.width - 20) / 2, height: 150)
                    .cornerRadius(20)
                Rectangle()
                    .fill(.red)
                    .frame(width: (screanSize.width - 20) / 2, height: 150)
                    .cornerRadius(20)
            }
            Spacer()
                .frame(width: 1, height: 100)
        }
            
            
        
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
