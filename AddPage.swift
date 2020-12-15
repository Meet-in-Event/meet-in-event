//
//  AddPage.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit

private var filterCV: UICollectionView!
let filterReuseIdentifier = "filterReuseIdentifier"
let padding: CGFloat = 8
var  filters:[Tag] = []

class AddPage: UIViewController, UITextViewDelegate,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    weak var delegate: Add?
    var event: Event!
    var eventNameField: UITextField!
    var descriptionField: UITextView!
    var locationField: UITextField!
    var error: UILabel!
    var category: UIPickerView!
    var categoryOptions: [String] = []
    var datePicker: UIDatePicker!
    var date : Date!
    var user: User!
    var saveButton: UIButton!
    var descIcon: UIImageView!
    var locIcon: UIImageView!
    var timeIcon: UIImageView!
    var visIcon: UIImageView!
    var tagIcon: UIImageView!

 //   var


    
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = backColor
        categoryOptions = ["Friends Only", "Public"]
        user = delegate?.getUser()

        
        var filter1 = Tag(tag: "Sports")
        var filter2 = Tag(tag: "Music")
        var filter3 = Tag(tag: "Study")
        var filter4 = Tag(tag: "Outdoor")
        var filter5 = Tag(tag: "Exploring")
        var filter6 = Tag(tag: "Other")
         
        filters = [filter1, filter2, filter3, filter4, filter5, filter6]

        setupViews()
         setupConstraints()
    
     }
     
     
     func setupViews() {
       
         
        
        
        
         eventNameField = UITextField()
         eventNameField.translatesAutoresizingMaskIntoConstraints = false
         eventNameField.backgroundColor = backColor
//         eventNameField.layer.borderWidth = 1
//         eventNameField.layer.cornerRadius = 10
//         eventNameField.layer.borderColor = UIColor.black.cgColor
         eventNameField.textAlignment = .center
         eventNameField.textColor = .black
        eventNameField.attributedPlaceholder = NSAttributedString(string:"Title of event....", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 30.0)!])
         view.addSubview(eventNameField)
         
         
         descriptionField = UITextView()
         descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.backgroundColor = textFieldColor
         descriptionField.layer.borderWidth = 1
         descriptionField.layer.cornerRadius = 10
        descriptionField.layer.borderColor = backColor.cgColor
         descriptionField.textAlignment = .center
         descriptionField.textColor = .gray
        descriptionField.font = UIFont(name: "Avenir-Medium", size: 17.0)
        descriptionField.text = "Quick description, anything you'd like others to know about your event?"
         view.addSubview(descriptionField)
        
        
        descIcon = UIImageView()
        descIcon.translatesAutoresizingMaskIntoConstraints = false
        descIcon.clipsToBounds = true
        descIcon.layer.masksToBounds = true
        descIcon.contentMode = .scaleAspectFill
        descIcon.image = UIImage(named: "pen")
        view.addSubview(descIcon)

        
        locIcon = UIImageView()
       locIcon.translatesAutoresizingMaskIntoConstraints = false
        locIcon.clipsToBounds = true
       locIcon.layer.masksToBounds = true
        locIcon.contentMode = .scaleAspectFill
        locIcon.image = UIImage(named: "placeholder")
        view.addSubview(locIcon)
        
        timeIcon = UIImageView()
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        timeIcon.clipsToBounds = true
        timeIcon.layer.masksToBounds = true
        timeIcon.contentMode = .scaleAspectFill
        timeIcon.image = UIImage(named: "calendar")
        view.addSubview(timeIcon)
        
        visIcon = UIImageView()
        visIcon.translatesAutoresizingMaskIntoConstraints = false
        visIcon.clipsToBounds = true
       visIcon.layer.masksToBounds = true
         visIcon.contentMode = .scaleAspectFill
        visIcon.image = UIImage(named: "visibility")
              view.addSubview(visIcon)

        
        tagIcon = UIImageView()
        tagIcon.translatesAutoresizingMaskIntoConstraints = false
         tagIcon.clipsToBounds = true
         tagIcon.layer.masksToBounds = true
          tagIcon.contentMode = .scaleAspectFill
        tagIcon.image = UIImage(named: "price-tag")
              view.addSubview(tagIcon)
        
        locationField = UITextField()
        locationField.translatesAutoresizingMaskIntoConstraints = false
        locationField.backgroundColor = textFieldColor
        locationField.layer.borderWidth = 1
        locationField.layer.cornerRadius = 10
        locationField.layer.borderColor = textFieldColor.cgColor
        locationField.textAlignment = .center
        locationField.textColor = .black
        locationField.attributedPlaceholder = NSAttributedString(string:"Enter Location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        view.addSubview(locationField)

         
         category = UIPickerView()
         category.translatesAutoresizingMaskIntoConstraints = false
         category.backgroundColor = .white
         category.layer.borderWidth = 1
         category.layer.cornerRadius = 10
        category.layer.borderColor = textFieldColor.cgColor
        category.backgroundColor = textFieldColor
       
//         category.attributedPlaceholder = NSAttributedString(string:"Description", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
         view.addSubview(category)
         
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderColor = textFieldColor.cgColor
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = textFieldColor
        saveButton.titleLabel!.textColor = .gray
        saveButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        datePicker = UIDatePicker()
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = backColor
               
               // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
          
        view.addSubview(datePicker)
        
     
         descriptionField.delegate =  self
    category.delegate = self
      category.dataSource = self
        
        
        error = UILabel()
        error.font = UIFont.systemFont(ofSize: 15)
        error.textColor = .red
        error.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(error)
        
        
        
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.minimumInteritemSpacing = padding
        filterLayout.minimumLineSpacing = 0
        
       
       filterCV = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
       filterCV.backgroundColor = backColor
       filterCV.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterReuseIdentifier)
        filterCV.dataSource = self
        filterCV.delegate = self
        filterCV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterCV)
        
      
        
        


     }
     
     
     func setupConstraints() {
         let offset: CGFloat = 25

         
         eventNameField.snp.makeConstraints{ make in
             make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
             make.centerX.equalTo(view.snp.centerX)
             make.width.equalTo(250)
             make.height.equalTo(50)

         }

         descriptionField.snp.makeConstraints{ make in
             make.top.equalTo(eventNameField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX).offset(20)
             make.width.equalTo(250)
             make.height.equalTo(130)
         }
        
        descIcon.snp.makeConstraints{ make in
            make.top.equalTo(eventNameField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX).offset(-150)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        locIcon.snp.makeConstraints{ make in
            make.top.equalTo(descriptionField.snp.bottom).offset(offset)
            make.centerX.equalTo(descIcon)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
     
        locationField.snp.makeConstraints{ make in
            make.top.equalTo(descriptionField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        timeIcon.snp.makeConstraints{ make in
            make.top.equalTo(locationField.snp.bottom).offset(offset+15)
             make.centerX.equalTo(descIcon)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
      //  datePicker.frame = CGRect(x: 10, y: 300, width: self.view.frame.width, height: 200)
       

        datePicker.snp.makeConstraints{make in
            make.top.equalTo(locationField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(50)
                   
        }
        
       
        
      
        category.snp.makeConstraints{ make in
            make.top.equalTo(datePicker.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX)
                           make.width.equalTo(150)
                           make.height.equalTo(50)
                       }
        
        error.snp.makeConstraints{make in
            make.top.equalTo(category.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        
     
        NSLayoutConstraint.activate([
                     filterCV.topAnchor.constraint(equalTo:category.bottomAnchor, constant: 30),
                     filterCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
                     filterCV.heightAnchor.constraint(equalToConstant: 50),
                     filterCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
                            ]);
        
        saveButton.snp.makeConstraints{make in
            make.top.equalTo(filterCV.snp.bottom).offset(40)
                 make.centerX.equalTo(view.snp.centerX)
                 make.width.equalTo(70)
                 make.height.equalTo(50)
                     }
        
       visIcon.snp.makeConstraints{ make in
        make.top.equalTo(category.snp.top).offset(10)
                   make.centerX.equalTo(descIcon)
                  make.width.equalTo(30)
                  make.height.equalTo(30)
              }
        tagIcon.snp.makeConstraints{ make in
            make.top.equalTo(filterCV.snp.top).offset(10)
                   make.centerX.equalTo(descIcon)
                  make.width.equalTo(30)
                  make.height.equalTo(30)
              }
             
            
     }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
         
         // Create date formatter
         let dateFormatter: DateFormatter = DateFormatter()

         // Set date format
         dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
         
         // Apply date format
    //     let selectedDate: String = dateFormatter.string(from: sender.date)
        
        
        dateFormatter.dateFormat = "yyyy"
        var year: String = dateFormatter.string(from: sender.date)
        var yearInt = (year as NSString).integerValue
        yearInt = 2020 % yearInt
        print(year)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: sender.date)
        var monthInt = (month as NSString).integerValue
        print(month)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: sender.date)
        var dayInt = (day as NSString).integerValue
        print(day)
        dateFormatter.dateFormat = "hh"
        let hour: String = dateFormatter.string(from: sender.date)
        var hourInt = (hour as NSString).integerValue
        print(hour)
        dateFormatter.dateFormat = "mm"
        let min: String = dateFormatter.string(from: sender.date)
        var minInt = (min as NSString).integerValue
        print(min)
        dateFormatter.dateFormat = "a"
        let suf: String = dateFormatter.string(from: sender.date)
        print(suf)

        date = Date(year: yearInt, mon: monthInt, day: dayInt, hour: hourInt, min: minInt, suf: suf)
//        let Index1 = selectedDate.index(selectedDate.startIndex, offsetBy: 0)
//        let Index2 = selectedDate.index(selectedDate.startIndex, offsetBy: 1)
//        print(selectedDate[Index2]+selectedDate[Index2])
     //    print("Selected value \(selectedDate)")

    
    
    
    
    }
     
     
     @objc func saveTapped() {
        
        if eventNameField.text=="" ||  descriptionField.text=="" || locationField.text==""  {
            print("must not be empty")
            error.text = "fields must not be empty"
         }
         else{
            event = Event(name: eventNameField.text! , desc: descriptionField.text!, date: self.date, creator: user, location: locationField.text!)
//            NetworkManager.createEvent(e: event, user: self.user) { ev in
//                self.event = ev
//                }
            self.delegate?.addEvent(i: event)
            eventNameField.text=""
            descriptionField.text=""
            locationField.text=""
            self.delegate?.home()
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
    if(row == 0)
    {event.publ = false}
    else
    { event.publ = true}
 }
func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  ///  titleForRow.textColor = .gray
    return categoryOptions[row]
}
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: categoryOptions[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }
}

extension AddPage: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filterCV.dequeueReusableCell(withReuseIdentifier: filterReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
        cell.configure(for: filters[indexPath.item])
                             return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filters.count
        
    }
}
   
extension AddPage: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (filterCV.frame.width - 2 * padding)/2.5
            return CGSize(width: size, height: 40)

        }
    }
extension AddPage: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
               let f = filters[indexPath.item]
                    if(f.isOn){
                            filters[indexPath.item].isOn = false
                                      }
                    else{
                        filters[indexPath.item].isOn = true
                        }
        
        var  eventTags: [Tag] = []
        for f in filters{
            if(f.isOn)
            {
                eventTags.append(f)
            }
                
        }
        event.setTags(t: eventTags)
           filterCV.reloadData()
    }

}


    
   
