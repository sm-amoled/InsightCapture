//
//  InquiryView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/08/21.
//

import SwiftUI

struct InquiryView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(uiColor: UIColor.systemGray5))
                .edgesIgnoringSafeArea(.vertical)
            
//            if viewModel.announcementList.count == 0 {
//                VStack{
//                    Spacer()
//                    HStack{
//                        Text("공지사항이 있을 때\n여기에서 알려드릴게요")
//                            .font(Font.system(size: 24, weight: .thin))
//                            .lineSpacing(6)
//                        Spacer()
//                    }
//                    .padding(.horizontal, 16)
//                    Spacer()
//
//                }
//            } else {
//                List {
//                    Section {
//
//                        ForEach(viewModel.announcementList, id: \.self) { announcement in
//                            NavigationLink {
//                                AnnouncementPageView(announcement: announcement)
//                            } label: {
//                                Text(announcement.title)
//                                    .lineLimit(1)
//                            }
//                        }
//
//                    } header: {
//                        Spacer().frame(height: 30)
//                    }
//                }
//                .scrollContentBackground(.hidden)
//                .background(Color(uiColor: UIColor.systemGray5))
//            }
            
            HStack(spacing: 8) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                Text("공지사항")
                    .font(Font.system(size: 18, weight: .semibold))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: UIColor.systemGray5))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct InquiryView_Previews: PreviewProvider {
    static var previews: some View {
        InquiryView()
    }
}
