//
//  BetterAnimatedTimersView.swift
//  University
//
//  Created by Дмитрий Савинов on 02.02.2022.
//

import SwiftUI
import VERSE

struct BetterAnimatedTimersView: View {

    let store: Store<BetterAnimatedTimersState, BetterAnimatedTimersAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ForEachStore(store.scope(state: \.timerItems, action: BetterAnimatedTimersAction.timerItem(id:action:))) { itemStore in
                    NavigationLink(
                        tag: ,
                        selection: viewStore.binding(
                            get: { $0.selectedTimer?.id },
                            send: BetterAnimatedTimersAction.setNavigation
                        ),
                        destination: IfLetStore(
                            store.scope(
                                state: { $0.selectedTimer?.value },
                                action: { BetterAnimatedTimersAction.timerCounterItem(id: \.id ,action:$0) }
                            ),
                            then: TimerCounterView.init
                        )
                    ) {
                        TimerView(store: itemStore)
                    }
                }
                HStack {
                    CircleButton(
                        image: .init(systemName: "repeat.1"),
                        gradient: [
                            .init(color: .blue, location: 1)
                        ]
                    ) {
                        viewStore.send(.parallelButtonTapped)
                    }
                    .padding()
                    CircleButton(
                        image: .init(systemName: viewStore.state.isTimersOnFire ? "pause.fill" : "play.fill"),
                        gradient: [
                            .init(color: .green, location: 0),
                            .init(color: viewStore.state.isTimersOnFire ? .red : .green, location: 1)
                        ]
                    ) {
                        viewStore.send(.playOrPauseButtonTapped)
                    }
                    .padding()
                    CircleButton(
                        image: .init(systemName: "shuffle"),
                        gradient: [
                            .init(color: .blue, location: 1)
                        ]
                    ) {
                        viewStore.send(.consecutiveButtonTapped)
                    }
                    .padding()
                }
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.allTimersDone,
                    send: BetterAnimatedTimersAction.setSheet
                ),
                content: {
                    HStack {
                        Text.init("Done!")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .monospacedDigit()
                            .transition(.opacity)
                    }.padding()
                    ZStack {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 80, weight: .light))
                    }
                    .frame(width: 100, height: 100)
                    .background(
                        ZStack {
                            Circle()
                                .fill(.green)
                                .frame(width: 100, height: 100)//Button Size.
                                .shadow(color: .gray.opacity(0.2), radius: 8, x: -8, y: -8)
                                .shadow(color: .gray.opacity(0.2), radius: 8, x: 8, y: 8)
                        }
                    )
                }
            )
        }.navigationBarTitle(Text("Animated Timers"))
    }
}


struct ContentView_BetterAnimatedTimersView: PreviewProvider {
    static var previews: some View {
        BetterAnimatedTimersView(
            store: .init(
                initialState: BetterAnimatedTimersState(),
                reducer: betterAnimatedTimersReducer,
                environment: BetterAnimatedTimersEnvironment()
            )
        )
    }
}
