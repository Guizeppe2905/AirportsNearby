//
//  DefaultContentView.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import SwiftUI

struct DefaultContentView: View {
    @State private var searchText = ""
    private let startAnimationDuration = 11.0
    @State private var animationStart = false
    @State private var animationEnd = false
    @State private var rectWidth: CGFloat = 300

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Image("backgroundImage")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        Spacer()
                        Image("airportsLogo")
                            .frame(width: 250, height: 150)
                            .padding(.top, 30)
                            Text("Давным-давно, в далекой-далекой галактике... Появилось приложе-\nние для поиска ближайшего аэро-\nпорта. Оно умеет определять ваше \nместоnположение и проклады\nвать маршрут по карте, теперь вы никогда не потеряетесь. Вбей-\nте в строку поиска город и посмотрите, какие аэро-\nпорты находятся рядом")
                                .fontWeight(.bold)
                                .font(.custom("Avenir Next", size: 20))
                                .foregroundColor(Color("customYellow"))
                                .lineSpacing(10)
                                .padding()
                                .multilineTextAlignment(.center)
                                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                                .shadow(color: .gray, radius: 2, x: 0, y: 15)
                                .frame(width: animationStart ? 400 : 280, height: animationStart ? 900 : 0)
                                .animation(.linear(duration: 0.5), value: rectWidth)
                                .onAppear() {
                                    self.animationStart.toggle()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + self.startAnimationDuration) {
                                        self.animationEnd.toggle()
                                    }
                                }
                        .padding(.top, -260)
                    }
                    .padding(.leading, -110)
            }
        }
    }
}


