// This file is generated.
import UIKit

/// A filled circle.
///
/// - SeeAlso: [Mapbox Style Specification](https://www.mapbox.com/mapbox-gl-style-spec/#layers-circle)
public struct CircleLayer: Layer, Equatable {

    // MARK: - Conformance to `Layer` protocol
    /// Unique layer name
    public var id: String

    /// Rendering type of this layer.
    public let type: LayerType

    /// An expression specifying conditions on source features.
    /// Only features that match the filter are displayed.
    public var filter: Expression?

    /// Name of a source description to be used for this layer.
    /// Required for all layer types except ``BackgroundLayer``, ``SkyLayer``, and ``LocationIndicatorLayer``.
    public var source: String?

    /// Layer to use from a vector tile source.
    ///
    /// Required for vector tile sources.
    /// Prohibited for all other source types, including GeoJSON sources.
    public var sourceLayer: String?

    /// The slot this layer is assigned to. If specified, and a slot with that name exists, it will be placed at that position in the layer order.
    public var slot: Slot?

    /// The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden.
    public var minZoom: Double?

    /// The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden.
    public var maxZoom: Double?

    /// Whether this layer is displayed.
    public var visibility: Value<Visibility>

    /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
    public var circleSortKey: Value<Double>?

    /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
    /// Default value: 0.
    public var circleBlur: Value<Double>?

    /// Transition options for `circleBlur`.
    public var circleBlurTransition: StyleTransition?

    /// The fill color of the circle.
    /// Default value: "#000000".
    public var circleColor: Value<StyleColor>?

    /// Transition options for `circleColor`.
    public var circleColorTransition: StyleTransition?

    /// Controls the intensity of light emitted on the source features.
    /// Default value: 0. Minimum value: 0.
    public var circleEmissiveStrength: Value<Double>?

    /// Transition options for `circleEmissiveStrength`.
    public var circleEmissiveStrengthTransition: StyleTransition?

    /// The opacity at which the circle will be drawn.
    /// Default value: 1. Value range: [0, 1]
    public var circleOpacity: Value<Double>?

    /// Transition options for `circleOpacity`.
    public var circleOpacityTransition: StyleTransition?

    /// Orientation of circle when map is pitched.
    /// Default value: "viewport".
    public var circlePitchAlignment: Value<CirclePitchAlignment>?

    /// Controls the scaling behavior of the circle when the map is pitched.
    /// Default value: "map".
    public var circlePitchScale: Value<CirclePitchScale>?

    /// Circle radius.
    /// Default value: 5. Minimum value: 0.
    public var circleRadius: Value<Double>?

    /// Transition options for `circleRadius`.
    public var circleRadiusTransition: StyleTransition?

    /// The stroke color of the circle.
    /// Default value: "#000000".
    public var circleStrokeColor: Value<StyleColor>?

    /// Transition options for `circleStrokeColor`.
    public var circleStrokeColorTransition: StyleTransition?

    /// The opacity of the circle's stroke.
    /// Default value: 1. Value range: [0, 1]
    public var circleStrokeOpacity: Value<Double>?

    /// Transition options for `circleStrokeOpacity`.
    public var circleStrokeOpacityTransition: StyleTransition?

    /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
    /// Default value: 0. Minimum value: 0.
    public var circleStrokeWidth: Value<Double>?

    /// Transition options for `circleStrokeWidth`.
    public var circleStrokeWidthTransition: StyleTransition?

    /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
    /// Default value: [0,0].
    public var circleTranslate: Value<[Double]>?

    /// Transition options for `circleTranslate`.
    public var circleTranslateTransition: StyleTransition?

    /// Controls the frame of reference for `circle-translate`.
    /// Default value: "map".
    public var circleTranslateAnchor: Value<CircleTranslateAnchor>?

    public init(id: String, source: String) {
        self.source = source
        self.id = id
        self.type = LayerType.circle
        self.visibility = .constant(.visible)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(sourceLayer, forKey: .sourceLayer)
        try container.encodeIfPresent(slot, forKey: .slot)
        try container.encodeIfPresent(minZoom, forKey: .minZoom)
        try container.encodeIfPresent(maxZoom, forKey: .maxZoom)

        var paintContainer = container.nestedContainer(keyedBy: PaintCodingKeys.self, forKey: .paint)
        try paintContainer.encodeIfPresent(circleBlur, forKey: .circleBlur)
        try paintContainer.encodeIfPresent(circleBlurTransition, forKey: .circleBlurTransition)
        try paintContainer.encodeIfPresent(circleColor, forKey: .circleColor)
        try paintContainer.encodeIfPresent(circleColorTransition, forKey: .circleColorTransition)
        try paintContainer.encodeIfPresent(circleEmissiveStrength, forKey: .circleEmissiveStrength)
        try paintContainer.encodeIfPresent(circleEmissiveStrengthTransition, forKey: .circleEmissiveStrengthTransition)
        try paintContainer.encodeIfPresent(circleOpacity, forKey: .circleOpacity)
        try paintContainer.encodeIfPresent(circleOpacityTransition, forKey: .circleOpacityTransition)
        try paintContainer.encodeIfPresent(circlePitchAlignment, forKey: .circlePitchAlignment)
        try paintContainer.encodeIfPresent(circlePitchScale, forKey: .circlePitchScale)
        try paintContainer.encodeIfPresent(circleRadius, forKey: .circleRadius)
        try paintContainer.encodeIfPresent(circleRadiusTransition, forKey: .circleRadiusTransition)
        try paintContainer.encodeIfPresent(circleStrokeColor, forKey: .circleStrokeColor)
        try paintContainer.encodeIfPresent(circleStrokeColorTransition, forKey: .circleStrokeColorTransition)
        try paintContainer.encodeIfPresent(circleStrokeOpacity, forKey: .circleStrokeOpacity)
        try paintContainer.encodeIfPresent(circleStrokeOpacityTransition, forKey: .circleStrokeOpacityTransition)
        try paintContainer.encodeIfPresent(circleStrokeWidth, forKey: .circleStrokeWidth)
        try paintContainer.encodeIfPresent(circleStrokeWidthTransition, forKey: .circleStrokeWidthTransition)
        try paintContainer.encodeIfPresent(circleTranslate, forKey: .circleTranslate)
        try paintContainer.encodeIfPresent(circleTranslateTransition, forKey: .circleTranslateTransition)
        try paintContainer.encodeIfPresent(circleTranslateAnchor, forKey: .circleTranslateAnchor)

        var layoutContainer = container.nestedContainer(keyedBy: LayoutCodingKeys.self, forKey: .layout)
        try layoutContainer.encode(visibility, forKey: .visibility)
        try layoutContainer.encodeIfPresent(circleSortKey, forKey: .circleSortKey)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(LayerType.self, forKey: .type)
        filter = try container.decodeIfPresent(Expression.self, forKey: .filter)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        sourceLayer = try container.decodeIfPresent(String.self, forKey: .sourceLayer)
        slot = try container.decodeIfPresent(Slot.self, forKey: .slot)
        minZoom = try container.decodeIfPresent(Double.self, forKey: .minZoom)
        maxZoom = try container.decodeIfPresent(Double.self, forKey: .maxZoom)

        if let paintContainer = try? container.nestedContainer(keyedBy: PaintCodingKeys.self, forKey: .paint) {
            circleBlur = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .circleBlur)
            circleBlurTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleBlurTransition)
            circleColor = try paintContainer.decodeIfPresent(Value<StyleColor>.self, forKey: .circleColor)
            circleColorTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleColorTransition)
            circleEmissiveStrength = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .circleEmissiveStrength)
            circleEmissiveStrengthTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleEmissiveStrengthTransition)
            circleOpacity = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .circleOpacity)
            circleOpacityTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleOpacityTransition)
            circlePitchAlignment = try paintContainer.decodeIfPresent(Value<CirclePitchAlignment>.self, forKey: .circlePitchAlignment)
            circlePitchScale = try paintContainer.decodeIfPresent(Value<CirclePitchScale>.self, forKey: .circlePitchScale)
            circleRadius = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .circleRadius)
            circleRadiusTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleRadiusTransition)
            circleStrokeColor = try paintContainer.decodeIfPresent(Value<StyleColor>.self, forKey: .circleStrokeColor)
            circleStrokeColorTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleStrokeColorTransition)
            circleStrokeOpacity = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .circleStrokeOpacity)
            circleStrokeOpacityTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleStrokeOpacityTransition)
            circleStrokeWidth = try paintContainer.decodeIfPresent(Value<Double>.self, forKey: .circleStrokeWidth)
            circleStrokeWidthTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleStrokeWidthTransition)
            circleTranslate = try paintContainer.decodeIfPresent(Value<[Double]>.self, forKey: .circleTranslate)
            circleTranslateTransition = try paintContainer.decodeIfPresent(StyleTransition.self, forKey: .circleTranslateTransition)
            circleTranslateAnchor = try paintContainer.decodeIfPresent(Value<CircleTranslateAnchor>.self, forKey: .circleTranslateAnchor)
        }

        var visibilityEncoded: Value<Visibility>?
        if let layoutContainer = try? container.nestedContainer(keyedBy: LayoutCodingKeys.self, forKey: .layout) {
            visibilityEncoded = try layoutContainer.decodeIfPresent(Value<Visibility>.self, forKey: .visibility)
            circleSortKey = try layoutContainer.decodeIfPresent(Value<Double>.self, forKey: .circleSortKey)
        }
        visibility = visibilityEncoded ?? .constant(.visible)
    }

    enum RootCodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case filter = "filter"
        case source = "source"
        case sourceLayer = "source-layer"
        case slot = "slot"
        case minZoom = "minzoom"
        case maxZoom = "maxzoom"
        case layout = "layout"
        case paint = "paint"
    }

    enum LayoutCodingKeys: String, CodingKey {
        case circleSortKey = "circle-sort-key"
        case visibility = "visibility"
    }

    enum PaintCodingKeys: String, CodingKey {
        case circleBlur = "circle-blur"
        case circleBlurTransition = "circle-blur-transition"
        case circleColor = "circle-color"
        case circleColorTransition = "circle-color-transition"
        case circleEmissiveStrength = "circle-emissive-strength"
        case circleEmissiveStrengthTransition = "circle-emissive-strength-transition"
        case circleOpacity = "circle-opacity"
        case circleOpacityTransition = "circle-opacity-transition"
        case circlePitchAlignment = "circle-pitch-alignment"
        case circlePitchScale = "circle-pitch-scale"
        case circleRadius = "circle-radius"
        case circleRadiusTransition = "circle-radius-transition"
        case circleStrokeColor = "circle-stroke-color"
        case circleStrokeColorTransition = "circle-stroke-color-transition"
        case circleStrokeOpacity = "circle-stroke-opacity"
        case circleStrokeOpacityTransition = "circle-stroke-opacity-transition"
        case circleStrokeWidth = "circle-stroke-width"
        case circleStrokeWidthTransition = "circle-stroke-width-transition"
        case circleTranslate = "circle-translate"
        case circleTranslateTransition = "circle-translate-transition"
        case circleTranslateAnchor = "circle-translate-anchor"
    }
}

@_documentation(visibility: public)
@_spi(Experimental) extension CircleLayer {
    /// An expression specifying conditions on source features.
    /// Only features that match the filter are displayed.
    @_documentation(visibility: public)
    public func filter(_ newValue: Expression) -> Self {
        with(self, setter(\.filter, newValue))
    }

    /// Name of a source description to be used for this layer.
    /// Required for all layer types except ``BackgroundLayer``, ``SkyLayer``, and ``LocationIndicatorLayer``.
    @_documentation(visibility: public)
    public func source(_ newValue: String) -> Self {
        with(self, setter(\.source, newValue))
    }

    /// Layer to use from a vector tile source.
    ///
    /// Required for vector tile sources.
    /// Prohibited for all other source types, including GeoJSON sources.
    @_documentation(visibility: public)
    public func sourceLayer(_ newValue: String) -> Self {
        with(self, setter(\.sourceLayer, newValue))
    }

    /// The slot this layer is assigned to.
    /// If specified, and a slot with that name exists, it will be placed at that position in the layer order.
    @_documentation(visibility: public)
    public func slot(_ newValue: Slot?) -> Self {
        with(self, setter(\.slot, newValue))
    }

    /// The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden.
    @_documentation(visibility: public)
    public func minZoom(_ newValue: Double) -> Self {
        with(self, setter(\.minZoom, newValue))
    }

    /// The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden.
    @_documentation(visibility: public)
    public func maxZoom(_ newValue: Double) -> Self {
        with(self, setter(\.maxZoom, newValue))
    }

    /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
    @_documentation(visibility: public)
    public func circleSortKey(_ constant: Double) -> Self {
        with(self, setter(\.circleSortKey, .constant(constant)))
    }

    /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
    @_documentation(visibility: public)
    public func circleSortKey(_ expression: Expression) -> Self {
        with(self, setter(\.circleSortKey, .expression(expression)))
    }

    /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
    /// Default value: 0.
    @_documentation(visibility: public)
    public func circleBlur(_ constant: Double) -> Self {
        with(self, setter(\.circleBlur, .constant(constant)))
    }

    /// Transition property for `circleBlur`
    @_documentation(visibility: public)
    public func circleBlurTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleBlurTransition, transition))
    }

    /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
    /// Default value: 0.
    @_documentation(visibility: public)
    public func circleBlur(_ expression: Expression) -> Self {
        with(self, setter(\.circleBlur, .expression(expression)))
    }

    /// The fill color of the circle.
    /// Default value: "#000000".
    @_documentation(visibility: public)
    public func circleColor(_ constant: StyleColor) -> Self {
        with(self, setter(\.circleColor, .constant(constant)))
    }

    /// The fill color of the circle.
    /// Default value: "#000000".
    @_documentation(visibility: public)
    public func circleColor(_ color: UIColor) -> Self {
        with(self, setter(\.circleColor, .constant(StyleColor(color))))
    }

    /// Transition property for `circleColor`
    @_documentation(visibility: public)
    public func circleColorTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleColorTransition, transition))
    }

    /// The fill color of the circle.
    /// Default value: "#000000".
    @_documentation(visibility: public)
    public func circleColor(_ expression: Expression) -> Self {
        with(self, setter(\.circleColor, .expression(expression)))
    }

    /// Controls the intensity of light emitted on the source features.
    /// Default value: 0. Minimum value: 0.
    @_documentation(visibility: public)
    public func circleEmissiveStrength(_ constant: Double) -> Self {
        with(self, setter(\.circleEmissiveStrength, .constant(constant)))
    }

    /// Transition property for `circleEmissiveStrength`
    @_documentation(visibility: public)
    public func circleEmissiveStrengthTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleEmissiveStrengthTransition, transition))
    }

    /// Controls the intensity of light emitted on the source features.
    /// Default value: 0. Minimum value: 0.
    @_documentation(visibility: public)
    public func circleEmissiveStrength(_ expression: Expression) -> Self {
        with(self, setter(\.circleEmissiveStrength, .expression(expression)))
    }

    /// The opacity at which the circle will be drawn.
    /// Default value: 1. Value range: [0, 1]
    @_documentation(visibility: public)
    public func circleOpacity(_ constant: Double) -> Self {
        with(self, setter(\.circleOpacity, .constant(constant)))
    }

    /// Transition property for `circleOpacity`
    @_documentation(visibility: public)
    public func circleOpacityTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleOpacityTransition, transition))
    }

    /// The opacity at which the circle will be drawn.
    /// Default value: 1. Value range: [0, 1]
    @_documentation(visibility: public)
    public func circleOpacity(_ expression: Expression) -> Self {
        with(self, setter(\.circleOpacity, .expression(expression)))
    }

    /// Orientation of circle when map is pitched.
    /// Default value: "viewport".
    @_documentation(visibility: public)
    public func circlePitchAlignment(_ constant: CirclePitchAlignment) -> Self {
        with(self, setter(\.circlePitchAlignment, .constant(constant)))
    }

    /// Orientation of circle when map is pitched.
    /// Default value: "viewport".
    @_documentation(visibility: public)
    public func circlePitchAlignment(_ expression: Expression) -> Self {
        with(self, setter(\.circlePitchAlignment, .expression(expression)))
    }

    /// Controls the scaling behavior of the circle when the map is pitched.
    /// Default value: "map".
    @_documentation(visibility: public)
    public func circlePitchScale(_ constant: CirclePitchScale) -> Self {
        with(self, setter(\.circlePitchScale, .constant(constant)))
    }

    /// Controls the scaling behavior of the circle when the map is pitched.
    /// Default value: "map".
    @_documentation(visibility: public)
    public func circlePitchScale(_ expression: Expression) -> Self {
        with(self, setter(\.circlePitchScale, .expression(expression)))
    }

    /// Circle radius.
    /// Default value: 5. Minimum value: 0.
    @_documentation(visibility: public)
    public func circleRadius(_ constant: Double) -> Self {
        with(self, setter(\.circleRadius, .constant(constant)))
    }

    /// Transition property for `circleRadius`
    @_documentation(visibility: public)
    public func circleRadiusTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleRadiusTransition, transition))
    }

    /// Circle radius.
    /// Default value: 5. Minimum value: 0.
    @_documentation(visibility: public)
    public func circleRadius(_ expression: Expression) -> Self {
        with(self, setter(\.circleRadius, .expression(expression)))
    }

    /// The stroke color of the circle.
    /// Default value: "#000000".
    @_documentation(visibility: public)
    public func circleStrokeColor(_ constant: StyleColor) -> Self {
        with(self, setter(\.circleStrokeColor, .constant(constant)))
    }

    /// The stroke color of the circle.
    /// Default value: "#000000".
    @_documentation(visibility: public)
    public func circleStrokeColor(_ color: UIColor) -> Self {
        with(self, setter(\.circleStrokeColor, .constant(StyleColor(color))))
    }

    /// Transition property for `circleStrokeColor`
    @_documentation(visibility: public)
    public func circleStrokeColorTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleStrokeColorTransition, transition))
    }

    /// The stroke color of the circle.
    /// Default value: "#000000".
    @_documentation(visibility: public)
    public func circleStrokeColor(_ expression: Expression) -> Self {
        with(self, setter(\.circleStrokeColor, .expression(expression)))
    }

    /// The opacity of the circle's stroke.
    /// Default value: 1. Value range: [0, 1]
    @_documentation(visibility: public)
    public func circleStrokeOpacity(_ constant: Double) -> Self {
        with(self, setter(\.circleStrokeOpacity, .constant(constant)))
    }

    /// Transition property for `circleStrokeOpacity`
    @_documentation(visibility: public)
    public func circleStrokeOpacityTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleStrokeOpacityTransition, transition))
    }

    /// The opacity of the circle's stroke.
    /// Default value: 1. Value range: [0, 1]
    @_documentation(visibility: public)
    public func circleStrokeOpacity(_ expression: Expression) -> Self {
        with(self, setter(\.circleStrokeOpacity, .expression(expression)))
    }

    /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
    /// Default value: 0. Minimum value: 0.
    @_documentation(visibility: public)
    public func circleStrokeWidth(_ constant: Double) -> Self {
        with(self, setter(\.circleStrokeWidth, .constant(constant)))
    }

    /// Transition property for `circleStrokeWidth`
    @_documentation(visibility: public)
    public func circleStrokeWidthTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleStrokeWidthTransition, transition))
    }

    /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
    /// Default value: 0. Minimum value: 0.
    @_documentation(visibility: public)
    public func circleStrokeWidth(_ expression: Expression) -> Self {
        with(self, setter(\.circleStrokeWidth, .expression(expression)))
    }

    /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
    /// Default value: [0,0].
    @_documentation(visibility: public)
    public func circleTranslate(x: Double, y: Double) -> Self {
        with(self, setter(\.circleTranslate, .constant([x, y])))
    }

    /// Transition property for `circleTranslate`
    @_documentation(visibility: public)
    public func circleTranslateTransition(_ transition: StyleTransition) -> Self {
        with(self, setter(\.circleTranslateTransition, transition))
    }

    /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
    /// Default value: [0,0].
    @_documentation(visibility: public)
    public func circleTranslate(_ expression: Expression) -> Self {
        with(self, setter(\.circleTranslate, .expression(expression)))
    }

    /// Controls the frame of reference for `circle-translate`.
    /// Default value: "map".
    @_documentation(visibility: public)
    public func circleTranslateAnchor(_ constant: CircleTranslateAnchor) -> Self {
        with(self, setter(\.circleTranslateAnchor, .constant(constant)))
    }

    /// Controls the frame of reference for `circle-translate`.
    /// Default value: "map".
    @_documentation(visibility: public)
    public func circleTranslateAnchor(_ expression: Expression) -> Self {
        with(self, setter(\.circleTranslateAnchor, .expression(expression)))
    }
}

@available(iOS 13.0, *)
@_spi(Experimental)
extension CircleLayer: MapStyleContent, PrimitiveMapContent {
    func visit(_ node: MapContentNode) {
        node.mount(MountedLayer(layer: self))
    }
}

// End of generated file.
