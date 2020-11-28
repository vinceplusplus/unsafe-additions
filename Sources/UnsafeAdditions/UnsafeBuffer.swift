public final class UnsafeBuffer<T> {
  public let pointer: UnsafePointer<T>
  public let bufferPointer: UnsafeBufferPointer<T>
  
  private init(pointer: UnsafePointer<T>, bufferPointer: UnsafeBufferPointer<T>) {
    self.pointer = pointer
    self.bufferPointer = bufferPointer
  }
  
  deinit {
    pointer.deallocate()
  }
  
  public static func allocate<Container>(copying collection: Container) -> Self where
    Container: Collection, Container.Element == T
  {
    let pointer = UnsafeMutablePointer<T>.allocate(capacity: collection.count)
    let bufferPointer = UnsafeMutableBufferPointer(start: pointer, count: collection.count)
    
    _ = bufferPointer.initialize(from: collection)
    
    return .init(pointer: .init(pointer), bufferPointer: .init(bufferPointer))
  }
}

