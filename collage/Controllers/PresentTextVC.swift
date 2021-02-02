//
//  PresentTextVC.swift
//  Photo Collage Maker
//
//  Created by Grapes Infosoft on 14/09/19.
//  Copyright © 2019 Grapes Infosoft. All rights reserved.
//

import UIKit

class PresentTextVC: UIViewController,UITextFieldDelegate
{
    
    var txt = ""
    var objImg = EditImageVC()
    var objSelection = 0
    
    //MARK:- Outlet
    @IBOutlet weak var txtEdit: UITextField!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEdit.delegate = self
        if objSelection == 1{
            txt = txtEdit.text!
        }else if objSelection == 2{
            txtEdit.text = objImg.viewMain.currentlyEditingLabel.labelTextView?.text
        }else if objSelection == 3{
            txt = txtEdit.text!
        }
     }

    //MARK:- Button Action Method
    @IBAction func btnCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOkAction(_ sender: Any) {
        if txtEdit.text == "" {
            displayMyAlertMessage(userMessage: "Please add some text")
        }else{
            if objSelection == 1{
                objImg.addTextLabel(self.txt)
                objImg.viewTextEditor.isHidden = false
                setView(view: objImg.viewTextEditor)
            }else if objSelection == 2{
                if objImg.viewMain.currentlyEditingLabel.labelTextView?.isSelectable == true{
                    objImg.viewMain.currentlyEditingLabel.labelTextView?.isUserInteractionEnabled = false
                    objImg.viewMain.currentlyEditingLabel.labelTextView?.text = txtEdit.text
                    self.dismiss(animated: true, completion: nil)
                }else {
                    objImg.addTextLabel(self.txt)
                }
            }else if objSelection == 3{
                objImg.addTextLabel(self.txt)
            }
        }
    }
    
    //MARK:- textview delegate methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtEdit.resignFirstResponder()
        self.txt = textField.text ?? ""
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        self.txt = resultString
        return true
    }
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }

}
