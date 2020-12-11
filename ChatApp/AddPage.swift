//
//  AddPage.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit
class AddPage: UIViewController, UITextViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    
    weak var delegate: Profile?
    var event: Event!
    var profileImage: UIImageView!
     var eventNameField: UITextField!
     var descriptionField: UITextView!
    var category: UIPickerView!
    var categoryOptions: [String] = []
    var datePicker: UIDatePicker!
    var date : Date!
     var user: User!
    var saveButton: UIButton!
 //   var


    
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = backgroundColor
        categoryOptions = ["Friends Only", "Public"]

         setupViews()
         setupConstraints()
    
     }
     
     
     func setupViews() {
       
         
        
        
        
         eventNameField = UITextField()
         eventNameField.translatesAutoresizingMaskIntoConstraints = false
         eventNameField.backgroundColor = backgroundColor
//         eventNameField.layer.borderWidth = 1
//         eventNameField.layer.cornerRadius = 10
//         eventNameField.layer.borderColor = UIColor.black.cgColor
         eventNameField.textAlignment = .center
         eventNameField.textColor = .black
         eventNameField.attributedPlaceholder = NSAttributedString(string:"Title of your event....", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
         view.addSubview(eventNameField)
         
         
         descriptionField = UITextView()
         descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.backgroundColor = UIColor(red: 253/255, green:213/255, blue: 174/255, alpha: 0.9)
         descriptionField.layer.borderWidth = 1
         descriptionField.layer.cornerRadius = 10
        descriptionField.layer.borderColor = backgroundColor.cgColor
         descriptionField.textAlignment = .center
         descriptionField.textColor = .gray
        descriptionField.text = "Quick description, anything you'd like others to know about your event?"
         view.addSubview(descriptionField)

         
         category = UIPickerView()
         category.translatesAutoresizingMaskIntoConstraints = false
         category.backgroundColor = .white
         category.layer.borderWidth = 1
         category.layer.cornerRadius = 10
         category.layer.borderColor = UIColor.black.cgColor
        category.backgroundColor = backgroundColor
//         category.textAlignment = .center
//         category.textColor = .black
//         category.attributedPlaceholder = NSAttributedString(string:"Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
         view.addSubview(category)
         
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.layer.borderWidth = 1
//        saveButton.layer.cornerRadius = 5
//        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.textColor = .gray
        saveButton.backgroundColor = UIColor(red: 253/255, green:213/255, blue: 174/255, alpha: 0.9)
        view.addSubview(saveButton)
        
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
               
               // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
          
        view.addSubview(datePicker)
        
     
         descriptionField.delegate =  self
    category.delegate = self
      category.dataSource = self

     }
     
     
     func setupConstraints() {
         let offset: CGFloat = 25

         
         eventNameField.snp.makeConstraints{ make in
             make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
             make.centerX.equalTo(view.snp.centerX)
             make.width.equalTo(200)
             make.height.equalTo(30)

         }

         descriptionField.snp.makeConstraints{ make in
             make.top.equalTo(eventNameField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX).offset(20)
             make.width.equalTo(250)
             make.height.equalTo(80)
         }

        
      //  datePicker.frame = CGRect(x: 10, y: 300, width: self.view.frame.width, height: 200)
       

        datePicker.snp.makeConstraints{make in
            make.top.equalTo(descriptionField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.frame.width - 20)
            make.height.equalTo(150)
                   
        }
        
       
        
        saveButton.snp.makeConstraints{make in
            make.top.equalTo(datePicker.snp.bottom).offset(offset + 20)
            make.centerX.equalTo(view.snp.centerX).offset(70)
            make.width.equalTo(60)
            make.height.equalTo(30)
                }
        category.snp.makeConstraints{ make in
            make.top.equalTo(datePicker.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX).offset(-50)
                           make.width.equalTo(150)
                           make.height.equalTo(50)
                       }
         
     }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
         
         // Create date formatter
         let dateFormatter: DateFormatter = DateFormatter()
         
         // Set date format
         dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
         
         // Apply date format
         let selectedDate: String = dateFormatter.string(from: sender.date)
         
         print("Selected value \(selectedDate)")

    
    
    
    
    }
     
     
     @objc func saveTapped() {
         if eventNameField.text=="" ||  descriptionField.text==""  {
            print("must not be empty")
         }
         else{
            event = Event(name: eventNameField.text! , desc: descriptionField.text!, date: self.date, creator: (delegate?.getUser())!, people: [])
        }
         
         navigationController?.popViewController(animated: true)
         }
   

func textViewDidBeginEditing(_ textView: UITextView) {
       if textView.textColor == UIColor.gray {
           textView.text = nil
           textView.textColor = UIColor.black
       }
   }
   func textViewDidEndEditing(_ textView: UITextView) {
       if textView.text.isEmpty {
           textView.text = "Quick description, anything you'd like others to know about your event?"
           textView.textColor = UIColor.lightGray
       }
   }
func numberOfComponents(in pickerView: UIPickerView) -> Int {
     return 1
 }
 
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categoryOptions.count
 }

func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     // This method is triggered whenever the user makes a change to the picker selection.
     // The parameter named row and component represents what was selected.
 }
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryOptions[row]
    }
}
   

