import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(discord_timecard_botTests.allTests),
    ]
}
#endif
