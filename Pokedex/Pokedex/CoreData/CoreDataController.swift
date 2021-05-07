//
//  CoreDataController.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataController {
    static let shared = CoreDataController()
    
    private var context: NSManagedObjectContext
    private var backgroundContext: NSManagedObjectContext
    
    private init() {
        let application = UIApplication.shared.delegate as! AppDelegate
        self.context = application.persistentContainer.viewContext
        self.backgroundContext = application.persistentContainer.newBackgroundContext()
    }
    
    func addPokemon(name: String, pokemonId: Int, types: [String], stats: [PokemonStat], imageData: Data) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = self.backgroundContext
        privateMOC.performAndWait {
            guard self.getPokemon(by: pokemonId) == nil else { return } // prevent duplicates
            
            let entity = NSEntityDescription.entity(forEntityName: "PokemonEntity", in: self.backgroundContext)
            
            let newPokemonEntity = PokemonEntity(entity: entity!, insertInto: self.backgroundContext)
            newPokemonEntity.id = Int16(pokemonId)
            newPokemonEntity.name = name
            newPokemonEntity.types = types
            
            stats.forEach { pokemonStat in
                self.addPokemonStat(to: newPokemonEntity, pokemonId: pokemonId, statName: pokemonStat.name, baseStat: pokemonStat.baseStat)
            }
            
            newPokemonEntity.image = imageData
            
            saveContext(forContext: privateMOC)
//            do {
//                try saveContext(forContext: privateMOC)
//                Log.info("addPokemon SUCCESS -> pokemonID: \(pokemonId), pokemonName: \(name)")
//            } catch let error {
//                Log.error("COREDATA addPokemon Error: ", error.localizedDescription)
//            }
        }
        
        //now save the main context with the changes from the private context
        saveContext(forContext: self.backgroundContext)
    }
    
    func addPokemon(name: String, pokemonId: Int, types: [String], stats: [PokemonStat]) {
        let entity = NSEntityDescription.entity(forEntityName: "PokemonEntity", in: self.context)
        
        let newPokemonEntity = PokemonEntity(entity: entity!, insertInto: self.context)
        newPokemonEntity.name = name
        newPokemonEntity.types = types
        
        stats.forEach { pokemonStat in
            self.addPokemonStat(to: newPokemonEntity, pokemonId: pokemonId, statName: pokemonStat.name, baseStat: pokemonStat.baseStat)
        }
        
        do {
            try self.context.save()
            Log.info("addPokemon SUCCESS")
        } catch let error {
            Log.error("COREDATA addPokemon Error: ", error.localizedDescription)
        }
    }
    
    func addPokemon(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "PokemonEntity", in: self.context)
        
        let newPokemonEntity = PokemonEntity(entity: entity!, insertInto: self.context)
        newPokemonEntity.name = name
        
        do {
            try self.context.save()
            Log.info("addPokemon SUCCESS")
        } catch let error {
            Log.error("COREDATA addPokemon Error: ", error.localizedDescription)
        }
    }
    
    func addPokemonDetails(pokemonId: Int, types: [String], stats: [PokemonStat]) {
        let entity = NSEntityDescription.entity(forEntityName: "PokemonEntity", in: self.context)
        
        let newPokemonEntity = PokemonEntity(entity: entity!, insertInto: self.context)
        newPokemonEntity.types = types
        
        stats.forEach { pokemonStat in
            self.addPokemonStat(to: newPokemonEntity, pokemonId: pokemonId, statName: pokemonStat.name, baseStat: pokemonStat.baseStat)
        }
        
        do {
            try self.context.save()
            Log.info("addPokemonStatAndTypes SUCCESS")
        } catch let error {
            Log.error("COREDATA addPokemonStatAndTypes Error: ", error.localizedDescription)
        }
    }
    
    func addPokemonStat(to pokemon: PokemonEntity, pokemonId: Int, statName: String, baseStat: Int) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = self.backgroundContext
        privateMOC.performAndWait {
            let pokemonStatEntity = NSEntityDescription.entity(forEntityName: "PokemonStatEntity", in: self.backgroundContext)
            let newPokemonStatEntity = PokemonStatEntity(entity: pokemonStatEntity!, insertInto: self.backgroundContext)
            
            newPokemonStatEntity.name = statName
            newPokemonStatEntity.baseStat = Int16(baseStat)
            
            let stats = pokemon.mutableSetValue(forKey: "stats")
            stats.add(newPokemonStatEntity)
            
            saveContext(forContext: privateMOC)
        }
        saveContext(forContext: self.backgroundContext)
    }
//        saveContext(forContext: context)
    
    
    func addPokemonImage(pokemonName: String, imageData: Data) {
        let pokemonEntity = self.getPokemon(with: pokemonName)
        pokemonEntity?.image = imageData
        
        do {
            try self.context.save()
            Log.info("COREDATA addPokemonImage SUCCESS")
        } catch let error {
            Log.error("COREDATA addPokemonImage Error: ", error.localizedDescription)
        }
    }
    
    func deletePokemon(by id: Int) {
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        request.predicate = NSPredicate.init(format: "id==\(id)")
        let pokemons = try! context.fetch(request)
        
        for pokemon in pokemons {
            context.delete(pokemon)
        }

        do {
            try context.save() 
        } catch {
            Log.error("COREDATA deletePokemon(by id: Error: ", error.localizedDescription)
        }
    }
    
    func getPokemon(by id: Int) -> PokemonEntity? {
        let pokemonEntity: PokemonEntity?
        
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id == %@", id as NSNumber)
        request.predicate = predicate
        
        do {
            let result = try self.context.fetch(request)
            
            switch result.count {
            case 0:
                // not exist
                return nil
                
            case 1:
                pokemonEntity = result[0]
                return pokemonEntity
                
            default:
                return nil
            }
            
        } catch let error {
            Log.error("COREDATA getPokemon(by id: Error: ", error.localizedDescription)
        }
        
        return nil
    }
    
    func getPokemon(with name: String) -> PokemonEntity? {
        let pokemonEntity: PokemonEntity?
        
        let request: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        
        do {
            let result = try self.context.fetch(request)
            
            switch result.count {
            case 0:
                // not exist
                return nil
                
            case 1:
                pokemonEntity = result[0]
                return pokemonEntity
                
            default:
                return nil
            }
            
        } catch let error {
            Log.error("COREDATA getPokemon(with name: Error: ", error.localizedDescription)
        }
        
        return nil
    }
    
    func getAllPokemons() -> [PokemonEntity]? {
        let fetchRequest: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
        
        do {
            let pokemonEntities = try self.context.fetch(fetchRequest)
            
            guard pokemonEntities.count > 0 else {
                Log.error("COREDATA loadAllPokemons Error: NO ELEMENTS")
                return nil
            }
            
            return pokemonEntities
            
        } catch let error {
            Log.error("COREDATA loadAllPokemons Error: ", error.localizedDescription)
        }
        
        return nil
    }
    
    func resetAllRecords(in entity : String, completion: @escaping () -> Void) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
        } catch let error {
            Log.error("COREDATA resetAllRecords Error: ", error.localizedDescription)
        }
        
        completion()
    }
    
    func reset(completion: @escaping () -> Void) {
        self.resetAllRecords(in: "PokemonStatEntity") {
            self.resetAllRecords(in: "PokemonEntity") {
                completion()
            }
        }
    }

    func saveContext(forContext context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    _ = error as NSError
//                    print("Error when saving !!! \(nserror.localizedDescription)")
//                    print("Callstack :")
//                    for symbol: String in Thread.callStackSymbols {
//                        print(" > \(symbol)")
//                    }
                }
            }
        }
    }
    
}
