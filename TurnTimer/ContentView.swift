//
//  ContentView.swift
//  TurnTimer
//
//  Created by Nickolans Griffith on 6/3/22.
//

import Combine
import SwiftUI

struct ContentView: View {
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    @State var currentTime = 30
    @State var maxTime = 30
    
    @State var timeToDisplay = "30"
    @State var isEditable = true
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                
                Spacer()
                
                TextField(text: self.$timeToDisplay, label: {
                    Text("\(maxTime)")
                }).onSubmit {
                    print("\(maxTime) \(timeToDisplay)")
                    
                    if let time = Int(self.timeToDisplay) {
                        self.maxTime = time
                        self.currentTime = time
                    }
                    
                    print(maxTime)
                }
                .keyboardType(.numbersAndPunctuation)
                .labelsHidden()
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { isFocused in
                    if isFocused {
                        self.isEditable = false
                        self.cancelTimer()
                    } else {
                        self.isEditable = true
                        DispatchQueue.main.async {
                            self.restartTimer()
                        }
                        
                    }
                }
                .font(.system(size: 100))
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("\(maxTime)")
                    .foregroundColor(Color.white.opacity(0.5))
                    .bold()
                    .font(.title)
                
                
                Spacer()
                
                Button {
                    //
                    self.timeToDisplay = "\(maxTime)"
                    self.currentTime = maxTime
                } label: {
                    Text("Reset")
                        .foregroundColor(self.currentTime == 0 ? Color.white : Color.white)
                        .font(.title)
                }
                
                Spacer()
            }
            
            Spacer()
            
        }
        
        .onReceive(timer) { input in
            if self.isEditable {
                if (currentTime - 1) != -1 {
                    self.currentTime -= 1
                }
                
                self.timeToDisplay = "\(currentTime)"
            }
        }
        .onAppear(perform: {
            self.initiateTimer()
        })
        .background(self.currentTime == 0 ? Color.red : Color.black)
        
    }
    
    func initiateTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
    }
    
    func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }
    
    func restartTimer() {
        self.currentTime = maxTime
        self.cancelTimer()
        self.initiateTimer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
