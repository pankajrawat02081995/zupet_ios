//
//  DeleteAccountVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 03/09/25.
//

import UIKit

class DeleteAccountVC: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!{
        didSet{
            Task{
                lblEmail.font = .manropeMedium(14)
                lblEmail.text = await UserDefaultsManager.shared.fatchCurentUser()?.email ?? ""
            }
        }
    }
    
    @IBOutlet weak var lblSubtitle: UILabel!{
        didSet{
            lblSubtitle.font = .manropeMedium(14)
        }
    }
    
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
        }
    }
    @IBOutlet weak var lblDeseTitle: UILabel!{
        didSet{
            lblDeseTitle.font = .manropeBold(16)
        }
    }
    
    private var viewModel : DeleteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DeleteViewModel(view: self)
    }
    

    @IBAction func deleteOnPress(_ sender: UIButton) {
        viewModel?.callDeleteAccountApi()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
}
