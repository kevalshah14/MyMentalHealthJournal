//
//  JournalEntryViewModel.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import Foundation
import CoreData
import Combine

class JournalEntryViewModel: ObservableObject {
    
    func saveEntry(text: String, date: Date, context: NSManagedObjectContext) {
        let newEntry = Entry(context: context)
        newEntry.text = text
        newEntry.date = date

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func updateEntry(entry: Entry, newText: String, context: NSManagedObjectContext) {
        entry.text = newText

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteEntry(entry: Entry, context: NSManagedObjectContext) {
        context.delete(entry)
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


