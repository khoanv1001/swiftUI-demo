//
//  ThumbnailView.swift
//  demo
//
//  Created by Nguyen Viet Khoa on 26/03/2024.
//

import SwiftUI

struct ThumbnailView: View {
    let post: Post
    
    private struct SizePreferenceKey: PreferenceKey {
            static var defaultValue: CGFloat = .zero
            static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
                value = min(value, nextValue())
            }
        }
    
    var body: some View {
        VStack {
            Image(post.imageUrl)
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .background(GeometryReader {
                            Color.clear.preference(key: SizePreferenceKey.self, value: $0.size.height)
                        })
                    Text(post.detail)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.06)
                        .lineLimit(5)
//                        .scaledToFit()
                        .background(GeometryReader {
                            Color.clear.preference(key: SizePreferenceKey.self, value: $0.size.height)
                        })
                }
            }
            Spacer()
        }
        .background(Color.white)
        .clipped()
//        .frame(width: post.size.width, height: post.size.height)
    }

}

#Preview {
    ThumbnailView(post: Post (title: "This is title", imageUrl: "thumbnail", detail: "This is detailThis is detailThis is detailbksjdfbksajdbflkasjdbfkasjdbfkasjbdflkajsdbflkasjdbfkasjdbfkasjdbfkasjdbfkasjdbfkhasdbfjkahsdasdasdasdasasdasdasdsdasdasdasdasdasdasdasdasdasd ", position: CGPoint(x: 0, y: 0), size:CGSize(width: 300, height: 300)))
}
