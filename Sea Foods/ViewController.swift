//
//  ViewController.swift
//  Sea Foods
//
//  Created by Amritanshu Dash on 03/09/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = [UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            
           guard let ciimage = CIImage(image: image)
            else{
               fatalError("Couldn't convert!!")
           }
            
           detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage){
        
        guard let model = try?VNCoreMLModel(for: Inceptionv3().model) //VNCoreMLModel comes from Vision
        else{
            fatalError("Loading COREML model failed!!")
        }

        let request = VNCoreMLRequest(model: model){ (request, error) in
            guard let results = request.results as? [VNClassificationObservation]
            else{
                fatalError("Model fail to process image!!")
            }
            
            if let firstResult = results.first{
                
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog!"
                }
                else{
                    self.navigationItem.title = "Not HotDog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        
        catch{
            print(error)
        }
    }
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
    
        present(imagePicker, animated: true)
    }
    
}

