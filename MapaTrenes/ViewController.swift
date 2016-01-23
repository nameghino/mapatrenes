//
//  ViewController.swift
//  MapaTrenes
//
//  Created by Nicolas Ameghino on 1/22/16.
//  Copyright © 2016 Nicolas Ameghino. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    var trains: Observable<[TrainLocation]>!
    let disposeBag = DisposeBag()
    var firstLoad = true
    let lineColors: [UIColor] = [.blueColor(), .redColor(), .yellowColor(), .greenColor(), .orangeColor(), .purpleColor()]
    var lines = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        TrainMapAPI.trainLocationsForLine(5, updateInterval: 1.0).subscribeNext {
            [weak self] (trains) -> Void in
            self?.mapView.removeAnnotations(self!.mapView.annotations)
            self?.mapView.addAnnotations(trains)
            self?.lines = Array(Set(trains.map { $0.line }))
            if self!.firstLoad {
                self?.mapView.showAnnotations(trains, animated: true)
                self?.firstLoad = false
            }
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let train = annotation as! TrainLocation
        let view: MKPinAnnotationView = {
            if let p = mapView.dequeueReusableAnnotationViewWithIdentifier("Train") as? MKPinAnnotationView {
                return p
            }
            return MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Train")
        }()
        
        let color: UIColor = {
            if let index = self.lines.indexOf(train.line) {
                return self.lineColors[index]
            }
            return .whiteColor()
        }()
        
        view.pinTintColor = color
        view.canShowCallout = true
        
        return view
    }
}

