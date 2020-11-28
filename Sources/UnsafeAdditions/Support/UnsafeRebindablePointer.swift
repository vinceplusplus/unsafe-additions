public struct UnsafeRebindablePointer {
  private let pointer: UnsafeRawPointer

  public init(_ pointer: UnsafeRawPointer) {
    self.pointer = pointer
  }
  
  public func rebound<T>() -> UnsafePointer<T> {
    pointer.assumingMemoryBound(to: T.self)
  }
}

