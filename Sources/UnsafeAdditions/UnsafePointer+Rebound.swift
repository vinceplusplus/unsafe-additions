public extension UnsafePointer {
  func withReboundUnsafePointer<T, R>(to type: T.Type, _ body: (UnsafePointer<T>) throws -> R) rethrows -> R {
    try body(UnsafeRawPointer(self).assumingMemoryBound(to: type))
  }
}

