//
//  CoreDataManager.swift
//  PasswordManager
//
//  Created by GWL on 14/07/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    init() {
        persistentContainer = NSPersistentContainer(name: "PasswordEntity")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load: \(error)")
            }
        }
    }

    func savePassword(accountName: String, username: String, password: String) {
        let passwordEntity = PasswordEntity(context: persistentContainer.viewContext)
        passwordEntity.id = UUID()
        passwordEntity.accountName = accountName
        passwordEntity.username = username
        passwordEntity.password = password
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save password: \(error)")
        }
    }

    func fetchPasswords() -> [DataModel] {
        let fetchRequest: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        do {
            let passwordEntities = try persistentContainer.viewContext.fetch(fetchRequest)
            return passwordEntities.map { DataModel(id: $0.id ?? UUID(), accountName: $0.accountName ?? "", username: $0.username ?? "", password: $0.password ?? "") }
        } catch {
            print("Failed to fetch passwords: \(error)")
            return []
        }
    }

    func updatePassword(id: UUID, accountName: String, username: String, password: String) {
            let fetchRequest: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let passwordEntities = try persistentContainer.viewContext.fetch(fetchRequest)
                if let passwordEntity = passwordEntities.first {
                    passwordEntity.accountName = accountName
                    passwordEntity.username = username
                    passwordEntity.password = password 
                    try persistentContainer.viewContext.save()
                }
            } catch {
                print("Failed to update password: \(error)")
            }
        }
    func deletePassword(id: UUID) {
            let fetchRequest: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let passwordEntities = try persistentContainer.viewContext.fetch(fetchRequest)
                if let passwordEntity = passwordEntities.first {
                    persistentContainer.viewContext.delete(passwordEntity)
                    try persistentContainer.viewContext.save()
                }
            } catch {
                print("Failed to delete password: \(error)")
            }
        }
}

