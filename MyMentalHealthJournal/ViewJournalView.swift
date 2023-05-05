//
//  ViewJournalView.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import Foundation
import SwiftUI
import CoreData
import UIKit

struct ViewJournalView: View {
    @ObservedObject var viewModel: ViewJournalViewModel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(viewModel: ViewJournalViewModel) {
        self.viewModel = viewModel
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemTeal
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.journalEntries) { entry in
                    NavigationLink(destination: EditJournalEntryView(entry: entry), label: {
                        VStack(alignment: .leading) {
                            Text(dateFormatter.string(from: entry.date!))
                                .font(.headline)
                            Text(entry.text!)
                                .font(.body)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)
                    })
                }
                .onDelete { indexSet in
                    viewModel.deleteEntry(at: indexSet)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("View Journal", displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
    }
}


struct EditJournalEntryView: View {
    var entry: Entry // Use the Entry entity
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var editedText: String
    
    init(entry: Entry) {
        self.entry = entry
        _editedText = State(initialValue: entry.text ?? "")
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $editedText)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.5), radius: 5, x: 0, y: 5)
                .padding()
            
            Button(action: {
                saveEditedEntry()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("Edit Journal Entry", displayMode: .inline)
    }
    
    private func saveEditedEntry() {
            // Update the entry's text property and save the context
            entry.text = editedText
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


struct ViewJournalView_Previews: PreviewProvider {
    static var previews: some View {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let viewModel = ViewJournalViewModel(context: context)
        return ViewJournalView(viewModel: viewModel)
    }
}

