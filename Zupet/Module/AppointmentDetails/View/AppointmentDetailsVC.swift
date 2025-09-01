//
//  AppointmentDetailsVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class AppointmentDetailsVC: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font = .manropeBold(18)
            lblTitle.localize("Appointment’s Timeline")
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var lblVetNameTitle: UILabel!{
        didSet{
            lblVetNameTitle.font = .manropeMedium(14)
        }
    }
    @IBOutlet weak var lblRequestTitle: UILabel!{
        didSet{
            lblRequestTitle.font = .manropeBold(16)
        }
    }
    @IBOutlet weak var lblDate: UILabel!{
        didSet{
            lblDate.font = .manropeRegular(12)
        }
    }
    @IBOutlet weak var lblServiceTitle: UILabel!{
        didSet{
            lblServiceTitle.font = .manropeMedium(14)
        }
    }
    @IBOutlet weak var lblService: UILabel!{
        didSet{
            lblService.font = .manropeRegular(12)
        }
    }
   
    private var viewModel : AppointmentDetailsViewModel?
    var appointmentId : String?
    var vetName : String?
    var date : String?
    var selectedDate : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AppointmentDetailsViewModel(view: self)
        setupTableView()
        viewModel?.getAppointmentsData(Id: appointmentId ?? "")
    }
    
    func setupData(){
        btnCancel.isHidden = viewModel?.appointmentModel?.data?.date?.isWithinTwoHours() ?? false && viewModel?.appointmentModel?.data?.status?.lowercased() == "pending"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
        requestView.addInnerShadow(cornerRadius: requestView.layer.cornerRadius)
        tableViewContainer.addInnerShadow(cornerRadius: tableViewContainer.layer.cornerRadius)
        
        //MARK: setupValue
        
        lblDate.text = date?.toLocalTime(inputFormat: .utcFormate, outputFormat: .localWithDate)
        lblVetNameTitle.text = vetName ?? ""

    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        tableView.register(cellType: AppointmentTimelineXIB.self)
        
    }
      
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func cancelOnPress(_ sender: UIButton) {
    }
    
    private func deleteAppointment(index:Int){
        presentPopup(from: self, mainTitle: .DeleteAppointment, subTitle: .DeleteAppointment, btnOkTitle: .Yes, btnCancelTitle: .No) { [weak self] in
            guard let self = self else { return }
            viewModel?.submitDecision(Id: appointmentId ?? "", index: index, decision: "declined")
        }
    }
    
}

extension AppointmentDetailsVC:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.appointmentModel?.data?.timeline?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AppointmentTimelineXIB = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.row == ((viewModel?.appointmentModel?.data?.timeline?.count ?? 0) - 1){
            cell.timelineView.isHidden = true
        }else{
            cell.timelineView.isHidden = false
        }
        let indexData = viewModel?.appointmentModel?.data?.timeline?[indexPath.row]
        cell.lblTitle.text = indexData?.title ?? ""
        cell.lblSubtitle.text = indexData?.message ?? ""
        cell.imgTimeline.setImage(from: indexData?.image ?? "")
        
        cell.btnAccept.tag = indexPath.row
        cell.btnDecline.tag = indexPath.row
        
        cell.btnActionStackConatiner.isHidden = indexData?.requiresAction ?? false == false
        cell.collectonViewContainer.isHidden = indexData?.requiresAction ?? false == false
        
        cell.configData(dates: indexData?.alternateSlots ?? [])
        
        cell.acceptOnPress = { [weak self] index in
            guard let self = self else { return }
            if selectedDate.isEmpty{
                Task{
                    await ToastManager.shared.showToast(message: ErrorMessages.SelectPreferredTime.rawValue)
                }
            }else{
                viewModel?.submitDecision(Id: appointmentId ?? "", index: index, decision: "accepted")
            }
        }
        
        cell.declineOnPress = { [weak self] index in
            guard let self = self else { return }
            deleteAppointment(index: index)
        }
        cell.selectDate = { [weak self] date in
            guard let self = self else { return }
            selectedDate = date
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
