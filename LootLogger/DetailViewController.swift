//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Victor Beltran on 12/6/21.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var SerialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var item: Item! {
    didSet {
        navigationItem.title = item.name
    }
  }
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        
        SerialNumberField.text = item.serialNumber
        
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // get the key item
        let key = item.itemKey
        
        // if there is an associated image with the item, display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear first responder
        view.endEditing(true)
        
        // "save changes to item
        item.name = nameField.text ?? ""
        
        item.serialNumber = SerialNumberField.text
        
        if let valueText = valueField.text,
           let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
            
        } else {
            item.valueInDollars = 0
        }
            
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            
            let imagePicker = self.imagePicker(for: .camera)
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
       
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
    alertController.addAction(photoLibraryAction)
    
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
   
    present(alertController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        
        // store the image in the imagestore for the items key
        imageStore.setImage(image, forKey: item.itemKey)
        
        
        // put that image on the screen in the image view
        imageView.image = image
        
        // take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    
}
    
    

