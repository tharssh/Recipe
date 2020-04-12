//
//  AddVC.swift
//  Recipe
//
//  Created by InsightzClub on 10/04/2020.
//  Copyright © 2020 Tharsshinee. All rights reserved.
//

import UIKit
import CoreData

class AddVC: UIViewController {
    
    var recipe: Recipe?
    var pickerView = UIPickerView()
    var pickerViewData : [Type] = []
    let imagePicker = UIImagePickerController()
    var data = UserDefaults.standard.array(forKey: "type")

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var ingredientsTxtView: UITextView!
    @IBOutlet weak var stepsTxtView: UITextView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewSetup()
        DataSetup()
    }
    
    @IBAction func DeleteImage(_ sender: Any) {
        imageView.image = nil
    }
    
    @IBAction func AddImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func SaveRecipe(_ sender: Any) {
        var eximage = (imageView.image)?.pngData() as NSData?
        if imageView.image == nil{
           eximage = nil
        }
        
        if let recipe = recipe, let type = typeTxt.text, let title = titleTxt.text, let ingredients = ingredientsTxtView.text, let steps = stepsTxtView.text {
            recipe.type = type
            recipe.title = title
            recipe.image = eximage
            recipe.ingredients = ingredients
            recipe.steps = steps
        }else if recipe == nil{
            let recipe = Recipe(context: PersistenceService.context)
            recipe.type = typeTxt.text!
            recipe.title = titleTxt.text!
            if eximage != nil{
                recipe.image = eximage
            }
            recipe.ingredients = ingredientsTxtView.text!
            recipe.steps = stepsTxtView.text!
        }
        PersistenceService.saveContext()
        performSegue(withIdentifier: "unwindToList", sender: nil)
    }
    
    
    
    @IBAction func Cancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindToList", sender: nil)
    }
    
    func ViewSetup()  {
        pickerView.delegate = self
        pickerView.dataSource = self
        typeTxt.inputView = pickerView
        
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.sourceType = .photoLibrary
        
        ingredientsTxtView.layer.borderWidth = 0.5
        stepsTxtView.layer.borderWidth = 0.5
        ingredientsTxtView.layer.cornerRadius = 5.0
        stepsTxtView.layer.cornerRadius = 5.0
        
        typeTxt.delegate = self
        titleTxt.delegate = self
    }
    
    func DataSetup() {
        saveBtn.isEnabled = false
        //setup
        if let recipe = recipe {
            typeTxt.text = recipe.type ?? ""
            titleTxt.text = recipe.title ?? ""
            
            if recipe.image != nil {
                let wrappedImage = recipe.image ?? NSData()
                let image = UIImage(data: wrappedImage as Data)
                imageView.image = image
            }
            ingredientsTxtView.text = recipe.ingredients
            stepsTxtView.text = recipe.steps
            
            saveBtn.isEnabled = true
        }
    }
}

// MARK: - ImagePickerController
extension AddVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - PickerView
extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTxt.text = pickerViewData[row].title
        self.view.endEditing(true)
    }
}

extension AddVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty{
             saveBtn.isEnabled = true
        } else {
             saveBtn.isEnabled = false
        }
        return true
    }
}
