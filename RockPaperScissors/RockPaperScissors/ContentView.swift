//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Batuhan Akdemir on 7.12.2023.
//

import SwiftUI


struct ContentView: View {
    
    @State private var score = 0
    @State private var answerCount = 0
    @State private var shouldWin = false
    @State private var isFinish = false
    @State private var computerChoice = LungeTypes.allCases.randomElement() ?? .rock
    @State private var selectedLunge: LungeTypes?

    
    var question: some View {
        Text(shouldWin ? "Which one wins?" : "Which one loses?")
            .font(.title.bold())
            .foregroundStyle(shouldWin ? .green : .red)
    }
    
    var body: some View {
        
        ZStack {
            Color(red: 0.90, green: 0.90, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()

                Text("Computer has played")
                    .font(.title.weight(.semibold))
                
                Text(computerChoice.rawValue)
                    .font(.system(size: 200))
                   
                Group {
                    if shouldWin {
                        question
                    } else {
                        question
                    }
                }
                
                HStack(spacing: 20) {
                    ForEach(LungeTypes.allCases, id: \.self) { lunge in
                        Button {
                            userSelected(lunge)
                
                        } label: {
                            Text(lunge.rawValue)
                                .font(.system(size: 80))
                                .rotation3DEffect(
                                    .degrees(selectedLunge == lunge ? 360 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                        }
                    }
                }
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.weight(.semibold))
                
                Spacer()
            }
        }
        .alert("Game Over", isPresented: $isFinish) {
            Button("Play Again", action: restartGame)
        } message: {
            Text("Your score was \(score)")
        }
    }
    
    func userSelected(_ userChoice: LungeTypes) {
        let winModifier: Int = shouldWin ? 1 : -1
        
        if answerCount != 10 {
            switch (userChoice, computerChoice) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                score += winModifier
            case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
                score -= winModifier
            default:
                if userChoice != computerChoice {
                    score += winModifier
                } else {
                    score -= winModifier
                }
            }
            
            computerChoice = LungeTypes.allCases.randomElement() ?? .rock
            answerCount += 1
            shouldWin.toggle()
            selectedLunge = userChoice
            
        } else {
            isFinish = true
        }
    }
    
    func restartGame() {
        answerCount = 0
        score = 0
        shouldWin = Bool.random()
        computerChoice = LungeTypes.allCases.randomElement() ?? .rock
        selectedLunge = nil
    }
}
