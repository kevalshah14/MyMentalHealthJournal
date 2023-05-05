//
//  JokeView.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import SwiftUI

struct Joke: Codable {
    let id: Int
    let type: String
    let setup: String
    let punchline: String
}

class JokeViewModel: ObservableObject {
    @Published var joke: Joke?
    
    init() {
        getJoke()
    }
    
    func getJoke() {
        if let url = URL(string: "https://official-joke-api.appspot.com/jokes/random") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(Joke.self, from: data)
                        DispatchQueue.main.async {
                            self.joke = decodedData
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

struct JokeView: View {
    @StateObject var viewModel = JokeViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text(viewModel.joke?.setup ?? "")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()

                Text(viewModel.joke?.punchline ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()

                Button(action: {
                    viewModel.getJoke()
                }) {
                    Text("Get Another Joke")
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.bottom)

                Spacer()
            }
        }
        .navigationBarTitle("Jokes", displayMode: .inline)
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        JokeView()
    }
}
