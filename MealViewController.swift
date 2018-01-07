//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Lnbo on 2018/1/2.
//  Copyright © 2018年 Lnbo. All rights reserved.
//

import UIKit
import os.log
//UITextFieldDelegate协议
class MealViewController: UIViewController,UITextFieldDelegate,
    UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //MARK:Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        nameTextField.delegate = self
        updateSaveButtonState()
    }

    //MARK:UITextFieldDelagate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    //使用这个方法使用户输入完信息点击键盘的return按钮解锁键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    //用户解锁键盘后调用这个方法实现里面的功能
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //当用户点击取消按钮，解除图像选择器
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else
            {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? "" //如果文本有值，返回当前值，没有值返回空字符串
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    //MARK:Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard.
        nameTextField.resignFirstResponder()
        //定义一个常量保存视图控制器
        let imagePickerController = UIImagePickerController()
        //只选择一个图片
        imagePickerController.sourceType = .photoLibrary
        //用户选择图像的时候通知给viewController
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    //MARK: Private Methods
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

