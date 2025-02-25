//
//  CustomTabBarView.swift
//  DynamicTabBar
//
//  Created by Xuan Thinh on 17/2/25.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var tabs: [MyView]
    @Binding var activeIndex: Int
    @Binding var tabBarScrollableState: String?
    @Binding var mainViewScrollableState: String?
    @Binding var progress: CGFloat

    var body: some View {
        ZStack(alignment: .bottomLeading) { // Giữ Capsule đúng vị trí
            TabIndicatorView(tabs: tabs, progress: progress)
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach($tabs.indices, id: \.self) { index in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeIndex = index
                                    tabBarScrollableState = tabs[index].title
                                    mainViewScrollableState = tabs[index].title
                                    proxy.scrollTo(tabs[index].title, anchor: .center)
                                }
                            }) {
                                Text(tabs[index].title)
                                    .padding(.vertical, 12)
                                    .foregroundStyle(Color.primary)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            .id(tabs[index].title)
                            .rect { rect in
                                tabs[index].size = rect.size
                                tabs[index].minX = rect.minX
                            }
                        }
                    }
                }
                .scrollPosition(id: $tabBarScrollableState, anchor: .center)
            }
           
        }
        .padding([.bottom, .horizontal])
        .background(.thinMaterial)
    }
}


#Preview {
    HomeView()
}

struct TabIndicatorView: View {
    let tabs: [MyView]
    let progress: CGFloat
    var body: some View {
        ZStack {
            let inputRange = tabs.indices.map { CGFloat($0) }
            let outputRange = tabs.map { $0.size.width }
            let outputPositionRange = tabs.map { $0.minX }
            let indicatorWidth = progress.interpolate(inputRange: inputRange, outputRange: outputRange)
            let indicatorPosition = progress.interpolate(inputRange: inputRange, outputRange: outputPositionRange)

            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pink, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: indicatorWidth + 20, height: 43)
                .offset(x: indicatorPosition - 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .shadow(color: .black.opacity(0.15), radius: 2)
        }
    }
}
