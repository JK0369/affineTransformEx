//
//  ViewController.swift
//  TestAffine
//
//  Created by 김종권 on 2021/08/21.
//

import UIKit

class ViewController: UIViewController {

    enum AffineType {
        case translate
        case scale
        case rotate
    }

    lazy var rectButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        view.setTitleColor(.white, for: .normal)
        view.setTitle("원본", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        view.titleLabel?.numberOfLines = 0

        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.addSubview(rectButton)
//        rectButton.translatesAutoresizingMaskIntoConstraints = false
//        rectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        rectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        rectButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        rectButton.heightAnchor.constraint(equalToConstant: 200).isActive = true

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        let image = UIImage(named: "search")
        imageView.image = image?.rotate(degrees: 45)
        imageView.backgroundColor = .blue
//        imageView.transform = .init(rotationAngle: 45)

        affineTransfrom(.scale)
    }

    func affineTransfrom(_ type: AffineType) {
        switch type {
        case .translate:
            rectButton.transform = .init(translationX: 50, y: 1.0)
            rectButton.setTitle("(translationX:50, y:1.0)", for: .normal)
        case .rotate:
            rectButton.transform = .init(rotationAngle: 45.0)
            rectButton.setTitle("(rotationAngle:45.0)", for: .normal)
        case .scale:
            rectButton.transform = .init(scaleX: 2.0, y: 1.0)
            rectButton.setTitle("(scaleX:2.0, y:1.0)", for: .normal)
        }
    }
}

extension UIImage {
    func rotate(degrees: CGFloat) -> UIImage {

        /// context에 그려질 크기를 구하기 위해서 최종 회전되었을때의 전체 크기 획득
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let affineTransform: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = affineTransform

        /// 회전된 크기
        let rotatedSize: CGSize = rotatedViewBox.frame.size

        /// 회전한 만큼의 크기가 있을때, 필요없는 여백 부분을 제거하는 작업
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        /// 원점을 이미지의 가운데로 평행 이동
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        /// 회전
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        /// 상하 대칭 변환 후 context에 원본 이미지 그림 그리는 작업
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        /// 그려진 context로 부터 이미지 획득
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
