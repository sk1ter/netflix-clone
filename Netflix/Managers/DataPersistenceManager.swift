//
//  DataPersistenceManager.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 12/03/23.
//

import Foundation
import UIKit

class DataPersistenceManager {
    static let shared = DataPersistenceManager()

    func downloadTitleWith(_ model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        let item = TitleItem(context: context)
        item.id = Int64(model.id)
        item.original_title = model.original_title
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count ?? 0)
        item.vote_avarage = model.vote_avarage ?? 0

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchTitles(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        do {
            let result = try context.fetch(TitleItem.fetchRequest())
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteData(_ model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        do {
            context.delete(model)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
