//
//  VetNearMeVC.swift
//  Zupet
//
//  Created by Pankaj Rawat on 19/08/25.
//

import UIKit

class VetNearMeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var txtSeach: UITextField! {
        didSet {
            txtSeach.font = .manropeMedium(14)
            txtSeach.delegate = self
            txtSeach.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 24
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var lblTitle: UILabel! {
        didSet {
            lblTitle.font = .manropeBold(18)
        }
    }
    
    // MARK: - Properties
    private var vets: [String] = []
    private var viewModel : VetNearMeViewModel?
    
    // Debounce timer to prevent multiple API calls
    private var searchDebounceTimer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VetNearMeViewModel(view: self)
        setupCollectionView()
        getVets(search: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgView.applyDiagonalGradient()
        bgView.updateGradientFrameIfNeeded()
    }
    
    private func getVets(search: String) {
        LocationService.shared.getUserLocation { result in
            switch result {
            case .success(let location):
                self.viewModel?.getVets(radius: 5000, location: location, search: search)
            case .failure(let error):
                Log.error("❌ Error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.register(cellType: VetXIB.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 8
            layout.estimatedItemSize = .zero
        }
    }
    
    
    // MARK: - Actions
    @IBAction private func backOnPress(_ sender: UIButton) {
        popView()
    }
    
    // MARK: - Search
    @objc private func searchTextChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        // Invalidate previous timer
        searchDebounceTimer?.invalidate()
        
        // Start new debounce timer (300ms delay)
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.getVets(search: text)
        }
    }
}

extension VetNearMeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.vetModel?.data?.count ?? 0
        return count >= 5 ? 5 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : VetXIB = collectionView.dequeueReusableCell(for: indexPath)
        let indexData = viewModel?.vetModel?.data?[indexPath.row]
        cell.imgUser.setImage(from: indexData?.photos?.first ?? "")
        cell.lblName.text = indexData?.name ?? ""
        cell.lblRate.text = "\(indexData?.rating ?? 0.0)(\(indexData?.totalReviews ?? 0))"
        cell.lblAddress.text = indexData?.address ?? ""
        
        let status = OpeningHoursHelper.status(openingTime: indexData?.openingTime ?? "", closingTime: indexData?.closingTime ?? "")

        cell.lblOpen.text = status.openText
        cell.lblOpen.textColor = status.openColor

        cell.lblCloseTime.text = status.closeText
        cell.lblCloseTime.textColor = status.closeColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        push(VetDetailsVC.self, from: .vet){ [weak self] vc in
            guard let self = self else {return}
            let indexData = viewModel?.vetModel?.data?[indexPath.row]
            vc.vetID = indexData?.id ?? ""
        }
    }
}

extension VetNearMeVC: UITextFieldDelegate {}
