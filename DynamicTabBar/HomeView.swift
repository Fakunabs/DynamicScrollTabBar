//
//  HomeView.swift
//  DynamicTabBar
//
//  Created by Xuan Thinh on 17/2/25.
//

import SwiftUI

struct HomeView: View {
    @State var tabs: [MyView] = [
        MyView(title: "All", theview: AnyView(Color.cyan)),
        MyView(title: "Romantic Comedy", theview: AnyView(Color.red)),
        MyView(title: "Thriller", theview: AnyView(Color.blue)),
        MyView(title: "Documentary films", theview: AnyView(Color.purple)),
        MyView(title: "Mistorical Dramas", theview: AnyView(Color.gray)),
    ]
    @State var activeIndex: Int = 0
    @State var tabBarScrollableState: String?
    @State var mainViewScrollableState: String?
    @State var progress: CGFloat = .zero
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(tabs.indices, id: \.self) { index in
                            tabs[index].theview
                                .id(tabs[index].title)
                                .containerRelativeFrame(.horizontal)
                        }
                    }
                    .scrollTargetLayout()
                    .rect { rect in
                        progress = -rect.minX / geo.size.width
                    }
                }
                .scrollPosition(id: $mainViewScrollableState)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onChange(of: mainViewScrollableState) { _, newValue in
                    if let newValue, let newIndex = tabs.firstIndex(where: { $0.title == newValue }) {
                        withAnimation(.snappy) {
                            tabBarScrollableState = newValue
                            activeIndex = newIndex
                        }
                    }
                }
            }
            .ignoresSafeArea()
            CustomTabBarView(tabs: $tabs, activeIndex: $activeIndex, tabBarScrollableState: $tabBarScrollableState, mainViewScrollableState: $mainViewScrollableState, progress: $progress)
        }
    }
}

#Preview {
    HomeView()
}
