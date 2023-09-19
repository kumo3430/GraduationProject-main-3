//
//  CommunityCardView.swift
//  GraduationProject
//
//  Created by heonrim on 9/5/23.
//

import SwiftUI

struct CommunityCardView: View {
    var body: some View {
        TabView {
            ForEach(1...5, id: \.self) { index in
                VStack(alignment: .leading, spacing: 10){
                    Text("我是來自群組相關最新消息的")
                        .padding(.top, 20)
                    Text("Card \(index)")
                        .font(.headline)
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .padding()
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .cardStyle()
    }
}

struct CommunityCardView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityCardView()
    }
}
