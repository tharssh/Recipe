//
//  ViewController.swift
//  Recipe
//
//  Created by InsightzClub on 10/04/2020.
//  Copyright © 2020 Tharsshinee. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UIViewController {
    
    var recipes = [Recipe]()
    var pickerView = UIPickerView()
    
    var types : [Type] = []
    var elementName: String = String()
    var titleType = String()
    
    @IBOutlet weak var typeTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var recipe = [Recipe]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

      
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        typeTxt.inputView = pickerView
        parseXML()
        
        //prepopulate data
        if(!appDelegate.hasAlreadyLaunched){
            appDelegate.sethasAlreadyLaunched()
            PersistenceService.prepopulateData()
        }
    
    }

    override func viewWillAppear(_ animated: Bool) {
        
        typeTxt.text = ""
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        do {
            let recipe = try PersistenceService.context.fetch(fetchRequest)
            self.recipes = recipe
            self.tableView.reloadData()

        } catch {}
    }
    
    func fetchRecipes(type:String)  {
        let predicate = NSPredicate(format: "type == %@", type)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Recipe")
        fetchRequest.predicate = predicate
        do{
            let result = try PersistenceService.context.fetch(fetchRequest)
            recipes = result as! [Recipe]
            tableView.reloadData()
        }catch{}
    }
    
    @objc func donePicker() {
        self.view.endEditing(true)
    }
    
    @IBAction func AddRecipe(_ sender: Any) {
        performSegue(withIdentifier: "segueToAddRecipe", sender: nil)
    }
    
    @IBAction func unwindToList(_ unwindSegue: UIStoryboardSegue) {}
    
   
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddVC
        vc.pickerViewData = types
   
        if segue.identifier == "segueToShow" {
            if let selectedPath = tableView.indexPathForSelectedRow{
                let recipe = recipes[selectedPath.row]
                vc.recipe = recipe
            }
        }
     }
}

// MARK: - PickerView
extension ListVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(types[row].title)
        typeTxt.text = types[row].title
        fetchRecipes(type: types[row].title)
        self.view.endEditing(true)
    }
}

// MARK: - TableView
extension ListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if recipes[indexPath.row].image != nil{
            let image = UIImage(data: recipes[indexPath.row].image! as Data)
            cell.imageView?.image = image
        }
       
        cell.textLabel?.text = recipes[indexPath.row].title
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToShow", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PersistenceService.context.delete(recipes.remove(at: indexPath.row))
            PersistenceService.saveContext()
        }
        tableView.reloadData()
    }
    
}

// MARK: - XMLParser
extension ListVC: XMLParserDelegate{
    
    func parseXML(){
        
        if let path = Bundle.main.url(forResource: "recipetype", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "type" {
            self.titleType = String()
        }
        self.elementName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "type" {
            let type = Type(title: titleType)
            types.append(type)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "title" {
                titleType += data
            }
        }
    }
}
