//
//  EUCLAViewController.swift
//  RandPeople
//
//  Created by Mac on 13.02.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class EUCLAViewController: UIViewController {

    private var textView : UITextView = UITextView()
    private var doneButton : UIButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        MasterPage()
        self.view.backgroundColor = .white
    }
    @objc func doneButtonTapped(){
        UserDefaults.standard.set(true, forKey: "EUCLA")
        UserDefaults.standard.synchronize()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        appDel.open_Page(withPage: .PrivarcyPolicy, withParam: "")
    }
}
extension EUCLAViewController : CreateView{
    func MasterPage() {
        self.textView = {
            let txtView = UITextView()
            txtView.textColor = .black
            txtView.layer.borderWidth = 0.3
            txtView.layer.borderColor = UIColor.black.cgColor
            txtView.textAlignment = .left
            txtView.backgroundColor = .clear
            txtView.text = """
RandPeople App End User License Agreement
This End User License Agreement (“Agreement”) is between you and RandPeople and governs use of this app made available through the Apple App Store. By installing the RandPeople App, you agree to be bound by this Agreement and understand that there is no tolerance for objectionable content. If you do not agree with the terms and conditions of this Agreement, you are not entitled to use the RandPeople.
In order to ensure RandPeople provides the best experience possible for everyone, we strongly enforce a no tolerance policy for objectionable content. If you see inappropriate content, please use the “Report as offensive” feature found under each post.

1. Parties This Agreement is between you and RandPeople only, and not Apple, Inc. (“Apple”). Notwithstanding the foregoing, you acknowledge that Apple and its subsidiaries are third party beneficiaries of this Agreement and Apple has the right to enforce this Agreement against you. RandPeople, not Apple, is solely responsible for the RandPeople App and its content.
2. Privacy RandPeople may collect and use information about your usage of the RandPeople App, including certain types of information from and about your device. RandPeople may use this information, as long as it is in a form that does not personally identify you, to measure the use and performance of the RandPeople  App.
 3. Limited License RandPeople grants you a limited, non-exclusive, non-transferable, revocable license to use the RandPeople App for your personal, non-commercial purposes. You may only use the RandPeople App on Apple devices that you own or control and as permitted by the App Store Terms of Service.
4. Age Restrictions By using the RandPeople App, you represent and warrant that (a) you are 17 years of age or older and you agree to be bound by this Agreement; (b) if you are under 17 years of age, you have obtained verifiable consent from a parent or legal guardian; and (c) your use of the  RandPeople does not violate any applicable law or regulation. Your access to the RandPeople App may be terminated without warning if RandPeople believes, in its sole discretion, that you are under the age of 17 years and have not obtained verifiable consent from a parent or legal guardian. If you are a parent or legal guardian and you provide your consent to your child’s use of the RandPeople App, you agree to be bound by this Agreement in respect to your child’s use of the RandPeople App.
 5. Objectionable Content Policy Content may not be submitted to RandPeople, who will moderate all content and ultimately decide whether or not to post a submission to the extent such content includes, is in conjunction with, or alongside any, Objectionable Content. Objectionable Content includes, but is not limited to: (i) sexually explicit materials; (ii) obscene, defamatory, libelous, slanderous, violent and/or unlawful content or profanity; (iii) content that infringes upon the rights of any third party, including copyright, trademark, privacy, publicity or other personal or proprietary right, or that is deceptive or fraudulent; (iv) content that promotes the use or sale of illegal or regulated substances, tobacco products, ammunition and/or firearms; and (v) gambling, including without limitation, any online casino, sports books, bingo or poker.
6. Warranty RandPeople disclaims all warranties about the RandPeople App to the fullest extent permitted by law. To the extent any warranty exists under law that cannot be disclaimed,RandPeople, not Apple, shall be solely responsible for such warranty.
7. Maintenance and Support RandPeople does provide minimal maintenance or support for it but not to the extent that any maintenance or support is required by applicable law, RandPeople, not Apple, shall be obligated to furnish any such maintenance or support.
8. Product Claims RandPeople, not Apple, is responsible for addressing any claims by you relating to the RandPeople App or use of it, including, but not limited to: (i) any product liability claim; (ii) any claim that the RandPeople App fails to conform to any applicable legal or regulatory requirement; and (iii) any claim arising under consumer protection or similar legislation. Nothing in this Agreement shall be deemed an admission that you may have such claims.
9. Third Party Intellectual Property Claims RandPeople shall not be obligated to indemnify or defend you with respect to any third party claim arising out or relating to the RandPeople App. To the extent RandPeople is required to provide indemnification by applicable law, RandPeople, not Apple, shall be solely responsible for the investigation, defense, settlement and discharge of any claim that the RandPeople App or your use of it infringes any third party intellectual property right.
10.Contact Informations :
    Web address : http://www.benozgurelmasli.com
    Name And Surname : Hasan Ozgur Elmasli
    Address : Yeni ziraat mahallesi 657.sokak 19/8
    E-mail address : ozgur_elmasli@hotmail.com
"""
            return txtView
        }()
        self.doneButton = {
            let btn = UIButton()
            btn.setTitle("Agree", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.layer.borderColor = UIColor.white.cgColor
            btn.backgroundColor = .green
            btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
            return btn
        }()
        self.textView.frame = CGRect(x: 0, y: 0, width: screenWith, height: screenHeigth - 100)
        self.doneButton.frame = CGRect(x: 20, y: screenHeigth - 80, width: screenWith - 40, height: 50)
        
        doneButton.layer.masksToBounds = true
        doneButton.clipsToBounds = true
        doneButton.layer.cornerRadius = self.doneButton.frame.size.width / 25.0
        self.view.addSubview(textView)
        self.view.addSubview(self.doneButton)
    }
}
