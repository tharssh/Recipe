//
//  PersistenceService.swift
//  Recipe
//
//  Created by InsightzClub on 11/04/2020.
//  Copyright © 2020 Tharsshinee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PersistenceService {
    // MARK: - Core Data stack
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Recipe")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func prepopulateData(){
        let eximage1 = (UIImage(named: "lentils3"))?.pngData() as NSData?
        let recipe1 = Recipe(context: PersistenceService.context)
        recipe1.type = "Rice"
        recipe1.title = "Curried Lentils and Rice"
        recipe1.image = eximage1
        recipe1.ingredients = " - 1 quart chicken broth \n - 1 cup dried green lentils \n - 1/2 cup basmati rice \n - 1 tsp curry powder \n - 1 tsp salt"
        recipe1.steps = " 1. Bring broth to a low boil.\n 2. Add curry powder and salt.\n 3. Cook lentils for 20 minutes. \n 4. Add rice and simmer for 20 minutes."
        
        let eximage2 = (UIImage(named: "carbonara"))?.pngData() as NSData?
        let recipe2 = Recipe(context: PersistenceService.context)
        recipe2.type = "Pasta"
        recipe2.title = "Spaghetti Carbonara"
        recipe2.image = eximage2
        recipe2.ingredients = " - 12 oz. spaghetti \n - Kosher salt \n - 3 large eggs \n 1 cup freshly grated Parmesan \n - 8 slices bacon \n - 2 cloves garlic, minced \n - Freshly ground black pepper \n Garnish \n - Extra-virgin olive oil (optional)  \n - Flaky sea salt (optional) \n - Freshly chopped parsley"
        recipe2.steps = " 1. In a large pot of salted boiling water, cook spaghetti according to package directions until al dente. Drain, reserving 1 cup pasta water. \n 2. In a medium bowl, whisk eggs and Parmesan until combined. \n 3. Meanwhile, in a large skillet over medium heat, cook bacon until crispy, about 8 minutes. Reserve fat in skillet and transfer slices to a paper towel-lined plate to drain. \n 4. To the same skillet, add garlic and cook until fragrant, about 1 minutes. Add cooked spaghetti and toss until fully coated in bacon fat. Remove from heat. Pour over egg and cheese mixture and stir vigorously until creamy (be careful not to scramble eggs). Add pasta water a couple tablespoons a time to loosen sauce if necessary. \n 5. Season generously with salt and pepper and stir in cooked bacon. \n 6. Drizzle with olive oil and garnish with flaky sea salt, Parmesan, and parsley before serving. "
        
        let eximage3 = (UIImage(named: "mushroom_soup"))?.pngData() as NSData?
        let recipe3 = Recipe(context: PersistenceService.context)
        recipe3.type = "Soup"
        recipe3.title = "Mushroom Soup"
        recipe3.image = eximage3
        recipe3.ingredients = " - 90g butter \n - 2 medium onions roughly chopped \n - 1 garlic clove, crushed \n - 500g mushrooms , finely chopped  \n - 2 tbsp plain flour \n - 1L hot chicken stock \n - 1 bay leaf \n - 4 tbsp single cream  \n - small handful flat-leaf parsley , roughly chopped, to serve (optional)"
        recipe3.steps = " 1. Heat the butter in a large saucepan and cook the onions and garlic until soft but not browned, about 8-10 mins.\n 2. Add the mushrooms and cook over a high heat for another 3 mins until softened. Sprinkle over the flour and stir to combine. Pour in the chicken stock, bring the mixture to the boil, then add the bay leaf and simmer for another 10 mins. \n 3. Remove and discard the bay leaf, then remove the mushroom mixture from the heat and blitz using a hand blender until smooth. Gently reheat the soup and stir through the cream (or, you could freeze the soup at this stage – simply stir through the cream when heating). Scatter over the parsley, if you like, and serve."

    }
    

}
