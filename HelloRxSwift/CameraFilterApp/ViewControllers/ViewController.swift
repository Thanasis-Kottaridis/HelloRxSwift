//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 24/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ViewController: UIViewController {

    @IBOutlet weak var applyFilterBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nc = segue.destination as? UINavigationController,
              let photosVC = nc.viewControllers.first as? PhotosVC
        else {
            fatalError("PhotosVC not found")
        }
        
        photosVC.selectedPhoto.subscribe(onNext: { [weak self] image in
            DispatchQueue.main.async {
                self?.updateUI(image: image)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func updateUI(image: UIImage) {
        applyFilterBtn.isHidden = false
        photoImageView.image = image
    }
    
    @IBAction func applyFilterTapped(_ sender: Any) {
        guard let sourceImage = photoImageView.image else {return}
        FiltersService().applyFilter(to: sourceImage).subscribe { filteredImage in
            self.photoImageView.image = filteredImage
        }.disposed(by: disposeBag)
    }
}



