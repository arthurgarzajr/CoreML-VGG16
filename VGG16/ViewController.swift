//
//  ViewController.swift
//  VGG16
//
//  Created by Arthur Garza on 6/8/17.
//  Copyright © 2017 Arthur Garza. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var vgg16Object: UILabel!
    @IBOutlet weak var vgg16Confidence: UILabel!
    
    @IBAction func takePicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        present(picker, animated: true)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        // The photo library is the default source, editing not allowed
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else { fatalError("no image from image picker") }
        
        // Show the image in the UI.
        imageView.image = uiImage
        
        do {
            let model = try VNCoreMLModel(for: VGG16().model)
            let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
            let handler = VNImageRequestHandler(cgImage: uiImage.cgImage!)
            try handler.perform([request])
        } catch {
            
        }
    }
    
    func myResultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation]
            else { fatalError("huh") }
        var maxConfidence = Float(0.0)
        var maxClassification: VNClassificationObservation?
        for classification in results {
            if classification.confidence > maxConfidence {
                maxConfidence = classification.confidence
                maxClassification = classification
            }
        }
        self.vgg16Object.text = "Object: " + (maxClassification?.identifier)!
        
        self.vgg16Confidence.text = "Confidence: " + String(describing: (maxClassification?.confidence)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

