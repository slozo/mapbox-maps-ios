import XCTest
@testable @_spi(Metrics) import MapboxMaps

final class MapViewTests: XCTestCase {

    var notificationCenter: MockNotificationCenter!
    var bundle: MockBundle!
    var cameraAnimatorsRunnerEnablable: MockMutableEnablable!
    var displayLink: MockDisplayLink!
    var locationProducer: MockLocationProducer!
    var dependencyProvider: MockMapViewDependencyProvider!
    var orientationProvider: MockInterfaceOrientationProvider!
    var attributionURLOpener: MockAttributionURLOpener!
    var mapView: MapView!
    var window: UIWindow!
    var metalView: MockMetalView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        notificationCenter = MockNotificationCenter()
        bundle = MockBundle()
        cameraAnimatorsRunnerEnablable = MockMutableEnablable()
        displayLink = MockDisplayLink()
        locationProducer = MockLocationProducer()
        dependencyProvider = MockMapViewDependencyProvider()
        dependencyProvider.notificationCenter = notificationCenter
        dependencyProvider.bundle = bundle
        dependencyProvider.cameraAnimatorsRunnerEnablable = cameraAnimatorsRunnerEnablable
        dependencyProvider.makeDisplayLinkStub.defaultReturnValue = displayLink
        dependencyProvider.makeLocationProducerStub.defaultReturnValue = locationProducer
        orientationProvider = MockInterfaceOrientationProvider()
        attributionURLOpener = MockAttributionURLOpener()
        mapView = MapView(
            frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            mapInitOptions: MapInitOptions(),
            dependencyProvider: dependencyProvider,
            orientationProvider: orientationProvider,
            urlOpener: attributionURLOpener)
        window = UIWindow()
        window.addSubview(mapView)

        metalView = try XCTUnwrap(dependencyProvider.makeMetalViewStub.invocations.first?.returnValue)
        // reset is required here to ignore the draw() invocation during initialization
        metalView.drawStub.reset()
    }

    override func tearDown() {
        metalView = nil
        window = nil
        mapView = nil
        attributionURLOpener = nil
        orientationProvider = nil
        dependencyProvider = nil
        locationProducer = nil
        displayLink = nil
        cameraAnimatorsRunnerEnablable = nil
        bundle = nil
        notificationCenter = nil
        super.tearDown()
    }

    func invokeDisplayLinkCallback() throws {
        let makeDisplayLinkParams = try XCTUnwrap(dependencyProvider.makeDisplayLinkStub.invocations.first?.parameters)
        let target = try XCTUnwrap(makeDisplayLinkParams.target as? NSObject)

        // Invoke the display link callback while there's an animator; verify that this alone does
        // not invoke setNeedsDisplay() on the MTKView
        target.perform(makeDisplayLinkParams.selector, with: displayLink)
    }

    // test that map view is deinited
    func testMapViewIsReleased() throws {
        weak var weakMapView: MapView?
        autoreleasepool {
            let mapView = MapView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
            weakMapView = mapView
        }
        XCTAssertNil(weakMapView)
    }

    func testDisplayLinkManagement() throws {
        do {
            XCTAssertEqual(dependencyProvider.makeDisplayLinkStub.invocations.count, 1)
            XCTAssertEqual(displayLink.addStub.invocations.count, 1)
            XCTAssertEqual(displayLink.addStub.invocations.first?.parameters.runloop, .current)
            XCTAssertEqual(displayLink.addStub.invocations.first?.parameters.mode, .common)
        }

        do {
            mapView.removeFromSuperview()
            let displayLink = try XCTUnwrap(dependencyProvider.makeDisplayLinkStub.invocations.first?.returnValue)
            XCTAssertEqual(displayLink.invalidateStub.invocations.count, 1)
        }
    }

    func testCameraAnimatorsRunnerEnablableIsDisabledPriorToJoiningAWindow() {
        cameraAnimatorsRunnerEnablable.$isEnabled.reset()
        mapView = MapView(
            frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            mapInitOptions: MapInitOptions(),
            dependencyProvider: dependencyProvider,
            orientationProvider: orientationProvider,
            urlOpener: attributionURLOpener)

        XCTAssertEqual(cameraAnimatorsRunnerEnablable.$isEnabled.setStub.invocations.map(\.parameters), [false])

        window.addSubview(mapView)

        XCTAssertEqual(cameraAnimatorsRunnerEnablable.$isEnabled.setStub.invocations.map(\.parameters), [false, true])
    }

    func testCancelsAndDisablesAnimationsWhenRemovedFromWindow() throws {
        let runner = try XCTUnwrap(dependencyProvider.makeCameraAnimatorsRunnerStub.invocations.first?.returnValue as? MockCameraAnimatorsRunner)
        runner.cancelAnimationsStub.reset()
        cameraAnimatorsRunnerEnablable.$isEnabled.reset()

        mapView.removeFromSuperview()

        XCTAssertEqual(runner.cancelAnimationsStub.invocations.count, 1)
        XCTAssertEqual(cameraAnimatorsRunnerEnablable.$isEnabled.setStub.invocations.map(\.parameters), [false])
    }

    func testCancelsAndDisablesAnimationsWhenUnableToCreateDisplayLink() throws {
        mapView = MapView(
            frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            mapInitOptions: MapInitOptions(),
            dependencyProvider: dependencyProvider,
            orientationProvider: orientationProvider,
            urlOpener: attributionURLOpener)
        let runner = try XCTUnwrap(dependencyProvider.makeCameraAnimatorsRunnerStub.invocations.first?.returnValue as? MockCameraAnimatorsRunner)
        runner.cancelAnimationsStub.reset()
        cameraAnimatorsRunnerEnablable.$isEnabled.reset()
        dependencyProvider.makeDisplayLinkStub.defaultReturnValue = nil

        window.addSubview(mapView)

        XCTAssertEqual(runner.cancelAnimationsStub.invocations.count, 1)
        XCTAssertEqual(cameraAnimatorsRunnerEnablable.$isEnabled.setStub.invocations.map(\.parameters), [false])
    }

    func testPreferredFramesPerSecondIsInitiallyZero() {
        XCTAssertEqual(mapView.preferredFramesPerSecond, 0)
        XCTAssertEqual(displayLink.preferredFramesPerSecond, mapView.preferredFramesPerSecond)
    }

    func testPreferredFramesPerSecondUpdate() {
        mapView.preferredFramesPerSecond = 23

        XCTAssertEqual(displayLink.preferredFramesPerSecond, 23)
        XCTAssertEqual(mapView.preferredFramesPerSecond, 23)
    }

    // Checking Swift version as a proxy for iOS SDK version to enable
    // building with iOS SDKs < 15
    #if swift(>=5.5)
    func testPreferredFrameRateRangeIsDefault() throws {
        guard #available(iOS 15.0, *) else {
            throw XCTSkip("Test requires iOS 15 or higher.")
        }
        let preferredFramesRateRange = mapView.preferredFrameRateRange
        let defaultRange = CAFrameRateRange.default
        XCTAssertEqual(preferredFramesRateRange, defaultRange)
        XCTAssertEqual(displayLink.preferredFrameRateRange, defaultRange)
    }

    func testPreferredFrameRateRangeUpdate() throws {
        guard #available(iOS 15.0, *) else {
            throw XCTSkip("Test requires iOS 15 or higher.")
        }
        let frameRateRange = CAFrameRateRange(minimum: 0, maximum: 120, preferred: 80)
        mapView.preferredFrameRateRange = frameRateRange
        XCTAssertEqual(displayLink.preferredFrameRateRange, frameRateRange)
        XCTAssertEqual(mapView.preferredFrameRateRange, frameRateRange)
    }
    #endif

    func testDisplayLinkTimestampIsNilWhenDisplayLinkIsNil() {
        mapView.removeFromSuperview()

        XCTAssertNil(mapView.displayLinkTimestamp)
    }

    func testDisplayLinkTimestampWhenDisplayLinkIsNonNil() {
        displayLink.timestamp = .random(in: 0..<CFTimeInterval.greatestFiniteMagnitude)

        XCTAssertEqual(mapView.displayLinkTimestamp, displayLink.timestamp)
    }

    func testDisplayLinkDurationIsNilWhenDisplayLinkIsNil() {
        mapView.removeFromSuperview()

        XCTAssertNil(mapView.displayLinkDuration)
    }

    func testDisplayLinkDurationWhenDisplayLinkIsNonNil() {
        displayLink.duration = .random(in: 0..<CFTimeInterval.greatestFiniteMagnitude)

        XCTAssertEqual(mapView.displayLinkDuration, displayLink.duration)
    }

    func testMetalViewSetNeedsDisplayIsTriggeredByScheduleRepaint() throws {
        mapView.scheduleRepaint()

        try invokeDisplayLinkCallback()

        XCTAssertEqual(metalView.drawStub.invocations.count, 1)
    }

    func testMetalViewDoesFitMapView() {
        let mapView = MapView(frame: .init(x: 50, y: 50, width: 100, height: 100))

        XCTAssertEqual(mapView.bounds, mapView.metalView?.frame)
    }

    func testMetalViewDoesResizeToFitMapView() {
        let mapView = MapView(frame: .init(x: 50, y: 50, width: 100, height: 100))
        mapView.frame = .init(x: 0, y: 0, width: 100, height: 100)

        XCTAssertEqual(mapView.bounds, mapView.metalView?.frame)
    }

    func testDisplayLinkInvokesParticipants() throws {
        let participant1 = MockDisplayLinkParticipant()
        let participant2 = MockDisplayLinkParticipant()

        mapView.add(participant1)

        try invokeDisplayLinkCallback()

        XCTAssertEqual(participant1.participateStub.invocations.count, 1)
        XCTAssertEqual(participant2.participateStub.invocations.count, 0)

        mapView.add(participant2)

        try invokeDisplayLinkCallback()

        XCTAssertEqual(participant1.participateStub.invocations.count, 2)
        XCTAssertEqual(participant2.participateStub.invocations.count, 1)

        mapView.remove(participant2)

        try invokeDisplayLinkCallback()

        XCTAssertEqual(participant1.participateStub.invocations.count, 3)
        XCTAssertEqual(participant2.participateStub.invocations.count, 1)

        mapView.remove(participant1)

        try invokeDisplayLinkCallback()

        XCTAssertEqual(participant1.participateStub.invocations.count, 3)
        XCTAssertEqual(participant2.participateStub.invocations.count, 1)
    }

    func testDisplayLinkInvokesCameraAnimatorsRunner() throws {
        XCTAssertEqual(dependencyProvider.makeCameraAnimatorsRunnerStub.invocations.count, 1)
        let runner = try XCTUnwrap(dependencyProvider.makeCameraAnimatorsRunnerStub.invocations.first?.returnValue as? MockCameraAnimatorsRunner)

        try invokeDisplayLinkCallback()

        XCTAssertEqual(runner.updateStub.invocations.count, 1)
    }

    func testDisplayLinkPausedWhenAppMovingToBackground() {
        notificationCenter.post(name: UIApplication.didEnterBackgroundNotification, object: nil)

        XCTAssertEqual(displayLink.$isPaused.setStub.invocations.map(\.parameters), [true])
    }

    func testDisplayLinkResumedWhenAppMovingToForeground() {
        notificationCenter.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        XCTAssertEqual(displayLink.$isPaused.setStub.invocations.map(\.parameters), [false])
    }

    func testOrientationProviderIsUsed() throws {
        try invokeDisplayLinkCallback()

        XCTAssertEqual(orientationProvider.interfaceOrientationStub.invocations.count, 1)
    }

    func testOrientationChangeIsPropagated() throws {
        let orientations: [UIInterfaceOrientation] = [.portrait, .landscapeLeft, .landscapeRight, .portraitUpsideDown]
        for orientation in orientations {
            orientationProvider.interfaceOrientationStub.defaultReturnValue = orientation

            try invokeDisplayLinkCallback()

            XCTAssertEqual(locationProducer.headingOrientation, CLDeviceOrientation(interfaceOrientation: orientation))
        }
    }

    func testURLOpener() {
        let manager = AttributionDialogManager(dataSource: MockAttributionDataSource(), delegate: MockAttributionDialogManagerDelegate())
        let url = URL(string: "http://example.com")!
        let attribution = Attribution(title: .randomASCII(withLength: 10), url: url)

        mapView.attributionDialogManager(manager, didTriggerActionFor: attribution)

        XCTAssertEqual(attributionURLOpener.openAttributionURLStub.invocations.count, 1)
        XCTAssertEqual(attributionURLOpener.openAttributionURLStub.invocations.first?.parameters, url)
    }
}

final class MapViewTestsWithScene: XCTestCase {

    var notificationCenter: MockNotificationCenter!
    var bundle: MockBundle!
    var cameraAnimatorsRunnerEnablable: MockMutableEnablable!
    var displayLink: MockDisplayLink!
    var locationProducer: MockLocationProducer!
    var dependencyProvider: MockMapViewDependencyProvider!
    var orientationProvider: MockInterfaceOrientationProvider!
    var attributionURLOpener: MockAttributionURLOpener!
    var mapView: MapView!
    var window: UIWindow!
    var metalView: MockMetalView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        notificationCenter = MockNotificationCenter()
        bundle = MockBundle()
        bundle.infoDictionaryStub.defaultReturnValue = ["UIApplicationSceneManifest": []]
        cameraAnimatorsRunnerEnablable = MockMutableEnablable()
        displayLink = MockDisplayLink()
        locationProducer = MockLocationProducer()
        dependencyProvider = MockMapViewDependencyProvider()
        dependencyProvider.notificationCenter = notificationCenter
        dependencyProvider.bundle = bundle
        dependencyProvider.cameraAnimatorsRunnerEnablable = cameraAnimatorsRunnerEnablable
        dependencyProvider.makeDisplayLinkStub.defaultReturnValue = displayLink
        dependencyProvider.makeLocationProducerStub.defaultReturnValue = locationProducer
        orientationProvider = MockInterfaceOrientationProvider()
        attributionURLOpener = MockAttributionURLOpener()
        mapView = MapView(
            frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)),
            mapInitOptions: MapInitOptions(),
            dependencyProvider: dependencyProvider,
            orientationProvider: orientationProvider,
            urlOpener: attributionURLOpener)
        window = UIWindow()
        window.addSubview(mapView)

        metalView = try XCTUnwrap(dependencyProvider.makeMetalViewStub.invocations.first?.returnValue)
        // reset is required here to ignore the draw() invocation during initialization
        metalView.drawStub.reset()
    }

    override func tearDown() {
        metalView = nil
        window = nil
        mapView = nil
        attributionURLOpener = nil
        orientationProvider = nil
        dependencyProvider = nil
        locationProducer = nil
        displayLink = nil
        cameraAnimatorsRunnerEnablable = nil
        bundle = nil
        notificationCenter = nil
        super.tearDown()
    }

    func testDisplayLinkResumedWhenSceneMovingToForeground() throws {
        guard #available(iOS 13.0, *) else {
            throw XCTSkip("Test requires iOS 13 or higher.")
        }

        notificationCenter.post(name: UIScene.willEnterForegroundNotification, object: window.parentScene)

        XCTAssertEqual(displayLink.$isPaused.setStub.invocations.map(\.parameters), [false])
    }

    func testDisplayLinkPausedWhenSceneMovingToBackground() throws {
        guard #available(iOS 13.0, *) else {
            throw XCTSkip("Test requires iOS 13 or higher.")
        }

        notificationCenter.post(name: UIScene.didEnterBackgroundNotification, object: window.parentScene)

        XCTAssertEqual(displayLink.$isPaused.setStub.invocations.map(\.parameters), [true])
    }

    func testMetalViewHasCorrectParameters() {
        let mapViewSize = CGSize(width: 100, height: 100)
        mapView = MapView(
            frame: CGRect(origin: .zero, size: mapViewSize),
            mapInitOptions: MapInitOptions(),
            dependencyProvider: dependencyProvider,
            orientationProvider: orientationProvider,
            urlOpener: attributionURLOpener)

        let metalView = mapView.getMetalView(for: nil)

        XCTAssertEqual(metalView?.translatesAutoresizingMaskIntoConstraints, false)
        XCTAssertEqual(metalView?.autoResizeDrawable, true)
        XCTAssertEqual(metalView?.contentScaleFactor, window.screen.scale)
        XCTAssertEqual(metalView?.contentMode, .center)
        XCTAssertEqual(metalView?.isOpaque, true)
        XCTAssertEqual(metalView?.layer.isOpaque, true)
        XCTAssertEqual(metalView?.isPaused, true)
        XCTAssertEqual(metalView?.enableSetNeedsDisplay, false)
        XCTAssertEqual(metalView?.presentsWithTransaction, false)
        XCTAssertEqual(metalView?.bounds.size, mapViewSize)
    }

    func testMetalViewHasMinimumSize() {
        let mapViewSize = CGSize.zero
        let minimumMetalViewSize = CGSize(width: 1, height: 1)
        mapView = MapView(
            frame: CGRect(origin: .zero, size: mapViewSize),
            mapInitOptions: MapInitOptions(),
            dependencyProvider: dependencyProvider,
            orientationProvider: orientationProvider,
            urlOpener: attributionURLOpener)

        let metalView = mapView.getMetalView(for: nil)

        XCTAssertEqual(metalView?.bounds.size, minimumMetalViewSize)
    }
}
