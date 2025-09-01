//
//  AppointmentListVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 30/08/25.
//

import UIKit

class AppointmentListVC: UIViewController {
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbltitle: UILabel!{
        didSet{
            lbltitle.font = .manropeBold(18)
            lbltitle.localize("My Appointments")
        }
    }
    
    private var viewModel : AppointmentListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AppointmentListViewModel(view: self)
        setupTableView()
        viewModel?.getAppointmentsData()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellType: AppointmentListXIB.self)
        
        tableView.addRefreshControl { [weak self] in
            self?.tableView.endRefreshing()
            self?.viewModel?.getAppointmentsData()
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    @IBAction func addOnPress(_ sender: UIButton) {
        push(FindVetVC.self, from: .vet){ [weak self] vc in
            guard self != nil else {return}
//            vc.isDirectAppointment = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Apply diagonal gradient to btnContinue button and background view
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }

}

extension AppointmentListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.appointmentModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AppointmentListXIB = tableView.dequeueReusableCell(for: indexPath)
        let indexData = viewModel?.appointmentModel?.data?[indexPath.row]
        cell.lblPetName.text = indexData?.vet?.name ?? ""
        cell.lblDoctorName.text = "Special Notes : \(indexData?.specialNotes ?? "")"
        cell.lblDate.text = "\(indexData?.date?.toLocalTime(inputFormat: .utcFormate, outputFormat: .localWithDate) ?? "")"
        cell.lblStatus.text = indexData?.status?.capitalized ?? ""
        cell.imgPet.setImage(from: indexData?.vet?.photos?.first ?? "")
        
        cell.lblStatus.backgroundColor = indexData?.status?.lowercased() == "pending" ? .ThemeOrangeEnd : indexData?.status?.lowercased() == "confirmed" ? .appGreen : .appRed
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(AppointmentDetailsVC.self, from: .profile) { [weak self ] vc in
            guard let self = self else{return}
            vc.appointmentId = viewModel?.appointmentModel?.data?[indexPath.row].id ?? ""
            vc.vetName = viewModel?.appointmentModel?.data?[indexPath.row].vet?.name ?? ""
            vc.date = viewModel?.appointmentModel?.data?[indexPath.row].date ?? ""
        }
    }
}
