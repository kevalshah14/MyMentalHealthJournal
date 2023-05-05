import Foundation
import SwiftUI
import CoreData

struct JournalEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var journalEntryViewModel = JournalEntryViewModel()
    @State private var entryText = ""
    private let currentDate = Date()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemTeal
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            Text(dateFormatter.string(from: currentDate))
                .font(.title2)
                .padding(.top)
            
            TextEditor(text: $entryText)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), radius: 5, x: 0, y: 5)
                .padding()
            
            Button(action: {
                journalEntryViewModel.saveEntry(text: entryText, date: currentDate, context: viewContext)
            })  {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("Journal Entry", displayMode: .inline)
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView()
    }
}
