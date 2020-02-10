//
//  PersonalChatView.swift
//  RandPeople
//
//  Created by Mac on 2.09.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Firebase
import TinyConstraints

class PersonalChatView: Navbar {
    private var heightConstraint: NSLayoutConstraint!
    private var leftBackButton = UIButton()
    private var labelOfNav = UILabel()
    private var tableView = UITableView()
    private var bottomView = UIView()
    private var textfield = UITextField()
    private var sentButton = UIButton()
    private var messages = [MessageType](){
        didSet{self.tableView.reloadData()}
    }
    private var selectedUSERID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.95, green:0.99, blue:0.99, alpha:1.0)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PersonalChatView.endEditing))
        self.view.addGestureRecognizer(gesture)
        ListenerFunc()
        setupViews()
        setupFrameWithPhone(withdeviceName: .Hata)
        // Do any additional setup after loading the view.
    }
    @objc func endEditing(){
        self.view.endEditing(true)
//        self.bottomView.removeFromSuperview()
//         bottomView.frame = CGRect(x: 0, y: screenHeigth - 100, width: screenWith, height: 150)
//        self.view.addSubview(bottomView)
    }
    func setUserID(withID:String){
        print("konuşunlan insan : \((withID))")
        selectedUSERID = withID
        self.sentButton.isEnabled = true
    }
    private func setKeyBoardValue()->Int{
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError("error")}
        let deviceModel = appDel.deviceModel()
        print(deviceModel)
        if deviceModel == .iPhoneSE{
             // Tamam
             return 226
        }else if deviceModel == .iPhoneXR{
             // Tamam
            return 326
        }else if deviceModel == .iPhoneX{
             // Tamam
            return 326
        }else if deviceModel == .iPhone8{
             // Tamam
            return 234
        }else if deviceModel == .iPhone8Plus{
            // Tamam
            return 260
        }
        return 226
    }
    private func ListenerFunc(){
     
        let db = Firestore.firestore()
        db.collection("WholeMessages").document(getUserUUID()).collection(self.selectedUSERID).order(by: "sentDate", descending: false).addSnapshotListener { (snapshot, error) in
            if error == nil{
                if self.messages.count > 0 {
                    self.messages.removeAll(keepingCapacity: false)
                    self.tableView.reloadData()
                }
                for document in snapshot!.documents{
                     let data = document.data()
                     let typeOfMessages = MessageType()
                     typeOfMessages.messsageText = data["messsageText"] as! String
                     typeOfMessages.senderID = data["senderId"] as! String
                     self.messages.append(typeOfMessages)
                     self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    }

}
extension PersonalChatView : SetUpViews{
    func setupViews() {
        leftBackButton = {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
            button.addTarget(self, action: #selector(PersonalChatView.backButton), for: .touchUpInside)
            return button
        }()
        labelOfNav = {
            let label = UILabel()
            label.textColor = .black
             let stringArr = self.selectedUSERID.components(separatedBy: "-")
            label.text = "User#\(String(describing: stringArr.last!))"
            return label
        }()
        tableView = {
           let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = . none
            tableView.register(FirstCell.self, forCellReuseIdentifier: "cell")
            tableView.backgroundColor = .clear
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableView.automaticDimension
            return tableView
        }()
        bottomView = {
           let view = UIView()
           view.backgroundColor = UIColor(red:0.56, green:0.85, blue:0.82, alpha:1.0)
           return view
        }()
        textfield = {
            let textField = UITextField()
            textField.textAlignment = .center
            textField.backgroundColor = .white
            textField.textColor = .lightGray
            textField.delegate = self
            textField.layer.cornerRadius = view.frame.width/25.0
            textField.attributedPlaceholder = NSAttributedString(string: "Your message",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            textField.addTarget(self, action: #selector(PersonalChatView.myTargetFunction(textField:)), for: .touchDown)
            textField.clipsToBounds = true
            return textField
        }()
        sentButton = {
           let button = UIButton()
           button.setTitle("Send", for: .normal)
           button.setTitleColor(.black, for: .normal)
           button.backgroundColor = .white

            button.addTarget(self, action: #selector(PersonalChatView.sentButtonTapped), for: .touchUpInside)
            return button
        }()
    }
    func setupFrameWithPhone(withdeviceName: PhoneType) {
          leftBackButton.frame = CGRect(x: 15, y: 40, width: 40, height: 40)
          labelOfNav.frame = CGRect(x: (screenWith / 2) - 75, y: 40, width: 300, height: 40)
          tableView.frame = CGRect(x: 0, y: 90, width: screenWith, height: screenHeigth - 200)
          bottomView.frame = CGRect(x: 0, y: screenHeigth - 100, width: screenWith, height: 150)
          textfield.frame = CGRect(x: 10, y: 20, width: screenWith - 120, height: 50)
          sentButton.frame = CGRect(x: screenWith - 100, y: 20, width: 90, height: 50)
          self.bottomView.addSubview(textfield)
          self.bottomView.addSubview(sentButton)
          self.view.addSubview(bottomView)
          self.view.addSubview(tableView)
          self.view.addSubview(leftBackButton)
          self.view.addSubview(labelOfNav)
    }
    @objc func backButton(){
        if self.navigationController?.viewControllers == nil{
            guard let appDel = UIApplication.shared.delegate as? AppDelegate else {fatalError("error")}
            appDel.open_Page(withPage: .MessageView, withParam:"")
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func myTargetFunction(textField: UITextField) {
        print("focus on text")
//        bottomView.frame = CGRect(x: 0, y: screenHeigth - 450, width: screenWith, height: screenHeigth)
//        tableView.addSubview(bottomView)
    }
    @objc func sentButtonTapped(){
        let db = Firestore.firestore()
        let value = ["messsageText":self.textfield.text! , "senderId":getUserUUID(),"sentDate":Date()] as [String : Any]
        let sentuuid = NSUUID().uuidString
    db.collection("WholeMessages").document(getUserUUID()).collection(self.selectedUSERID).document(sentuuid).setData(value)
    db.collection("WholeMessages").document(self.selectedUSERID).collection(getUserUUID()).document(sentuuid).setData(value)
        self.textfield.text = ""
    }
}
extension PersonalChatView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? FirstCell else {fatalError("error")}
        cell.isUserInteractionEnabled = false
        cell.backgroundColor = .clear
        if self.messages[indexPath.row].senderID == getUserUUID(){
            cell.anaView.backgroundColor = .lightGray // deneme
        }
        cell.CommenterName.text = self.messages[indexPath.row].messsageText
        let containerViewHeight: CGFloat = DynamicLabelSize.height(text: cell.CommenterName.text!, font: cell.CommenterName.font!, width: self.view.frame.size.width) + CGFloat(15.0)
        cell.anaView.height(containerViewHeight)
        cell.CommenterName.size(CGSize(width: cell.anaView.frame.size.width - 5, height: cell.anaView.frame.size.height - 10))
        cell.CommenterName.edges(to: cell.anaView)
        cell.CommenterName.edgesToSuperview( insets: .left(100))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}
extension PersonalChatView : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: CGFloat(setKeyBoardValue()), view: self.view)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: CGFloat(setKeyBoardValue()), view: self.view)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat, view:UIView){
        
        let movementDistance:CGFloat = -moveValue
        let movementDuration: Double = 0.3
        var movement:CGFloat = 0
        if up{
            movement = movementDistance
        }else{
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        view.frame = view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

