//
//  UploadPhotoVC.swift
//  DispatchGroup
//
//  Created by Inderjeet Singh on 09/02/23.
//

import UIKit

class UploadPhotoVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var loaderView: UIView!
    
    // MARK: - Variables
    public lazy var objImages = [UIImage]()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    // MARK: - Button Action
    @IBAction func addImageBtnAtn(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] (image) in
            self?.objImages.append(image)
            self?.photosCollection.reloadData()
        }
    }
    
    @IBAction func uploadBtnAtn(_ sender: Any) {
        UploadImageViewModel.shared.uplaodImage(images: objImages)
    }
}

// MARK: - Private Methods
extension UploadPhotoVC {
    func setupUI(){
        self.loaderView.isHidden = true
        self.photosCollection.register(UINib(nibName: UploadPhotoCVC.Cell_Identifier, bundle: Bundle.main), forCellWithReuseIdentifier: UploadPhotoCVC.Cell_Identifier)
    }
}

// MARK: - Collection Methods
extension UploadPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: UploadPhotoCVC.Cell_Identifier, for: indexPath) as! UploadPhotoCVC
        item.setupData(data: self.objImages[indexPath.item])
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2
        return CGSize(width: width, height: 180)
    }
}
