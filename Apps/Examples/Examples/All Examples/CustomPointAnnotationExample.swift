import UIKit
import MapboxMaps
import Turf

@objc(CustomPointAnnotationExample)

fileprivate enum RouteDurationAnnotationTailPosition: Int {
    case left
    case right
}

fileprivate struct DebugFeature {
    var coordinate: CLLocationCoordinate2D
    var selected: Bool
    var sortOrder: Int
    var tailPosition: RouteDurationAnnotationTailPosition
    var label: String
    var imageName: String
}

public class CustomPointAnnotationExample: UIViewController, ExampleProtocol {

    internal var mapView: MapView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(with: view.bounds, resourceOptions: resourceOptions())
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        // Center the map camera over New York City
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)

        mapView.cameraManager.setCamera(centerCoordinate: centerCoordinate,
                                        zoom: 15.0)

        // Allows the delegate to receive information about map events.
        mapView.on(.mapLoaded) { [weak self] _ in

            guard let self = self else { return }

            /**
             Create the point annotation, using a custom image to mark the location specified.
             The image is referenced from the application's asset catalog.
             */
            let centerCoordinate = self.mapView.centerCoordinate
            let customPointAnnotation = PointAnnotation(coordinate: centerCoordinate,
                                                        image: UIImage(named: "star"))

            // Add the annotation to the map.
            self.mapView.annotationManager.addAnnotation(customPointAnnotation)

            self.updateAnnotationSymbolImages()
            let features = self.addDebugFeatures()
            self.addRouteAnnotationSymbolLayer(features: features)

            // The below line is used for internal testing purposes only.
            self.finish()
        }
    }

    private func updateAnnotationSymbolImages() {
        guard let style = mapView.style, style.getStyleImage(with: "RouteInfoAnnotationLeftHanded") == nil, style.getStyleImage(with: "RouteInfoAnnotationRightHanded") == nil else { return }

        let routeDurationAnnotationSelectedColor = UIColor(hue: 0.831372549, saturation: 0.72, brightness: 0.59, alpha: 1.0)
        let routeDurationAnnotationColor = UIColor.white

        // Right-hand pin
        if let image =  UIImage(named: "RouteInfoAnnotationRightHanded") {
            let regularRouteImage = image.tint(routeDurationAnnotationColor)

            let lStretchX = ImageStretches(first: Float(32), second: Float(42))
            let stretchX = [lStretchX]
            let stretchY = [ImageStretches(first: Float(26), second: Float(32))]
            let imageContent = ImageContent(left: 32, top: 26, right: 47, bottom: 33)

            style.setStyleImage(image: regularRouteImage,
                                with: "RouteInfoAnnotationRightHanded",
                                stretchX: stretchX,
                                stretchY: stretchY,
                                scale: 2.0,
                                imageContent: imageContent)

            let selectedRouteImage = image.tint(routeDurationAnnotationSelectedColor)
            style.setStyleImage(image: selectedRouteImage,
                                with: "RouteInfoAnnotationRightHanded-Selected",
                                stretchX: stretchX,
                                stretchY: stretchY,
                                scale: 2.0,
                                imageContent: imageContent)
        }

        // Left-hand pin
        if let image =  UIImage(named: "RouteInfoAnnotationLeftHanded") {
            let regularRouteImage = image.tint(routeDurationAnnotationColor)

            let lStretchX = ImageStretches(first: Float(32), second: Float(42))
            let stretchX = [lStretchX]
            let stretchY = [ImageStretches(first: Float(26), second: Float(32))]
            let imageContent = ImageContent(left: 32, top: 26, right: 47, bottom: 33)

            style.setStyleImage(image: regularRouteImage,
                                with: "RouteInfoAnnotationLeftHanded",
                                stretchX: stretchX,
                                stretchY: stretchY,
                                scale: 2.0,
                                imageContent: imageContent)

            let selectedRouteImage = image.tint(routeDurationAnnotationSelectedColor)
            style.setStyleImage(image: selectedRouteImage,
                                with: "RouteInfoAnnotationLeftHanded-Selected",
                                stretchX: stretchX,
                                stretchY: stretchY,
                                scale: 2.0,
                                imageContent: imageContent)
        }
    }

    static let routeDurationAnnotations = "routeDurationAnnotations"

    private func addDebugFeatures() -> FeatureCollection {
        var features = [Feature]()
        let featureList = [
            DebugFeature(coordinate: CLLocationCoordinate2DMake(40.714203, -74.006314), selected: false, sortOrder: 0, tailPosition: .left, label: "Chambers & Broadway Lefthand Stem", imageName: "RouteInfoAnnotationLeftHanded"),
            DebugFeature(coordinate: CLLocationCoordinate2DMake(40.707918, -74.006008), selected: false, sortOrder: 0, tailPosition: .right, label: "Cliff & John Righthand Stem", imageName: "RouteInfoAnnotationRightHanded"),
            DebugFeature(coordinate: CLLocationCoordinate2DMake(40.716908, -74.004016), selected: true, sortOrder: 1, tailPosition: .right, label: "Leonard & Broadway Selected Right", imageName: "RouteInfoAnnotationRightHanded-Selected"),
            DebugFeature(coordinate: CLLocationCoordinate2DMake(40.710194, -74.004248), selected: true, sortOrder: 1, tailPosition: .left, label: "Spruce & Gold Selected Left", imageName: "RouteInfoAnnotationLeftHanded-Selected")
        ]

        for (index, feature) in featureList.enumerated() {
            var featurePoint = Feature(Point(feature.coordinate))

            // set the feature attributes which will be used in styling the symbol style layer
            featurePoint.properties = ["selected": feature.selected, "tailPosition": feature.tailPosition.rawValue, "text": feature.label, "imageName": feature.imageName, "sortOrder": feature.selected == true ? 1 : -index]

            features.append(featurePoint)
        }

        return FeatureCollection(features: features)
    }

    private func addRouteAnnotationSymbolLayer(features: FeatureCollection) {
        guard let style = mapView.style else { return }
        if let _ = try? mapView.style.getSource(identifier: CustomPointAnnotationExample.routeDurationAnnotations, type: GeoJSONSource.self).get() {
            let _ = mapView.style.updateGeoJSON(for: CustomPointAnnotationExample.routeDurationAnnotations, with: features)
        } else {

            var dataSource = GeoJSONSource()
            dataSource.data = .featureCollection(features)
            mapView.style.addSource(source: dataSource, identifier: CustomPointAnnotationExample.routeDurationAnnotations)
        }

        var shapeLayer: SymbolLayer

        if let layer = try? mapView.style.getLayer(with: CustomPointAnnotationExample.routeDurationAnnotations, type: SymbolLayer.self).get() {
            shapeLayer = layer
        } else {
            shapeLayer = SymbolLayer(id: CustomPointAnnotationExample.routeDurationAnnotations)
        }

        shapeLayer.source = CustomPointAnnotationExample.routeDurationAnnotations

        shapeLayer.layout?.textField = .expression(Exp(.get) {
            "text"
        })

        shapeLayer.layout?.iconImage = .expression(Exp(.get) {
            "imageName"
        })

        shapeLayer.paint?.textColor = .expression(Exp(.switchCase) {
            Exp(.any) {
                Exp(.get) {
                    "selected"
                }
            }
            UIColor.white
            UIColor.black
        })

        shapeLayer.layout?.textSize = .expression(
            Exp(.interpolate) {
                Exp(.linear)
                Exp(.zoom)
                13
                16
                15.5
                20
            }
        )

        shapeLayer.layout?.iconTextFit = .both
        shapeLayer.layout?.iconAllowOverlap = .constant(true)
        shapeLayer.layout?.textAllowOverlap = .constant(true)
        shapeLayer.layout?.textJustify = .left
        shapeLayer.layout?.symbolZOrder = .auto
        shapeLayer.layout?.textFont = .constant(["DIN Pro Medium"])
//        shapeLayer.layout?.iconTextFitPadding = .constant([-4.0, -4.0, -2.0, -4.0])
        shapeLayer.layout?.symbolSortKey = .expression(Exp(.switchCase) {
            Exp(.any) {
                Exp(.get) {
                    "selected"
                }
            }
            1.0
            0.0
        })

        style.addLayer(layer: shapeLayer, layerPosition: nil)

        let expressionString =
        """
        [
          "match",
          ["get", "tailPosition"],
          ["0"],
          "bottom-left",
          "bottom-right"
        ]
        """

        if let expressionData = expressionString.data(using: .utf8), let expJSONObject = try? JSONSerialization.jsonObject(with: expressionData, options: []) {

            try! mapView.__map.setStyleLayerPropertyForLayerId(CustomPointAnnotationExample.routeDurationAnnotations,
                                                          property: "icon-anchor",
                                                          value: expJSONObject)
            try! mapView.__map.setStyleLayerPropertyForLayerId(CustomPointAnnotationExample.routeDurationAnnotations,
                                                          property: "text-anchor",
                                                          value: expJSONObject)
        }

        let offsetExpressionString =
        """
        [
          "match",
          ["get", "tailPosition"],
          ["0"],
          ["literal", [0.5, -1]],
          ["literal", [-0.5, -1]]
        ]
        """

        if let expressionData = offsetExpressionString.data(using: .utf8), let expJSONObject = try? JSONSerialization.jsonObject(with: expressionData, options: []) {

            try! mapView.__map.setStyleLayerPropertyForLayerId(CustomPointAnnotationExample.routeDurationAnnotations,
                                                          property: "icon-offset",
                                                          value: expJSONObject)

            try! mapView.__map.setStyleLayerPropertyForLayerId(CustomPointAnnotationExample.routeDurationAnnotations,
                                                          property: "text-offset",
                                                          value: expJSONObject)
        }
    }
}

extension UIImage {
    func tint(_ tintColor: UIColor) -> UIImage {
        let imageSize = size
        let imageScale = scale
        let contextBounds = CGRect(origin: .zero, size: imageSize)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, imageScale)

        defer { UIGraphicsEndImageContext() }

        UIColor.black.setFill()
        UIRectFill(contextBounds)
        draw(at: .zero)

        guard let imageOverBlack = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        tintColor.setFill()
        UIRectFill(contextBounds)

        imageOverBlack.draw(at: .zero, blendMode: .multiply, alpha: 1)
        draw(at: .zero, blendMode: .destinationIn, alpha: 1)

        guard let finalImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }

        return finalImage
    }
}