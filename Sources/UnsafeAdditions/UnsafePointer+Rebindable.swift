public extension UnsafePointer {
  func withUnsafeRebindablePointer<R>(_ body: (UnsafeRebindablePointer) throws -> R) rethrows -> R {
    try body(.init(UnsafeRawPointer(self)))
  }
}

