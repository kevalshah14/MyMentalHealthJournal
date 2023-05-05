//
//  ViewJournalViewModel.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import Foundation
import CoreData
import Combine

class ViewJournalViewModel: ObservableObject {
    @Published var journalEntries: [Entry] = []
    
    private var cancellable: AnyCancellable?
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        cancellable = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self] _ in
                self?.fetchJournalEntries()
            }
        fetchJournalEntries()
    }

    private func fetchJournalEntries() {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Entry.date, ascending: false)]

        do {
            journalEntries = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching journal entries: \(error)")
        }
    }
    
    func deleteEntry(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let entry = journalEntries[index]
            context.delete(entry)
        }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
