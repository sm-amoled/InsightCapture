//
//  AnnouncementPageView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/20.
//

import SwiftUI

struct AnnouncementPageView: View {
    var announcement: AnnouncementItem
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .edgesIgnoringSafeArea(.vertical)
                .foregroundColor(Color(uiColor: UIColor.systemGray5))

            VStack {
                HStack(spacing: 8) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(Font.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Text(announcement.title)
                        .lineLimit(1)
                        .font(Font.system(size: 18, weight: .semibold))
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(uiColor: UIColor.systemGray5))
                
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack { Spacer() }
                        VStack(alignment: .leading) {
                            Text(announcement.title)
                                .font(Font.system(size: 17, weight: .bold))
                                .padding(.bottom, 4)
                            Text(announcement.writtenDate.toPageDateString())
                                .font(Font.system(size: 14, weight: .regular))
                                .padding(.bottom, 16)
                            Text(announcement.content)
                                .font(Font.system(size: 15, weight: .regular))
                            Spacer()
                        }
                        .padding(.all, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.white))
                    .padding(.horizontal, 16)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}
