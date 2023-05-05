//
//  ContentView.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        appearance.setBackIndicatorImage(UIImage(systemName: "chevron.left"), transitionMaskImage: UIImage(systemName: "chevron.left"))
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left")
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            NavigationView {
                VStack(spacing: 30) {
                    HStack(spacing: 30) {
                        NavigationLink(destination: JournalEntryView()) {
                            buttonStyle(title: "New Journal Entry", icon: "pencil.circle")
                        }
                        NavigationLink(destination: ViewJournalView(viewModel: ViewJournalViewModel(context: context))) {
                            buttonStyle(title: "View Journal Entries", icon: "book.circle")
                        }
                    }
                    HStack(spacing: 30) {
                        NavigationLink(destination: HelpView()) {
                            buttonStyle(title: "Get Help Nearby", icon: "mappin.circle")
                        }
                        NavigationLink(destination: JokeView()) {
                            buttonStyle(title: "Change My Mood!", icon: "face.smiling")
                        }
                    }
                }
                .padding(.horizontal, 20)
                .navigationBarTitle("My Mental Health Journal", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                )
            }
            .background(Color.clear)
        }
    }
    
    private func buttonStyle(title: String, icon: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: 150, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(20)
        )
    }
}
