#
# Invalid Address Type Error
#
class InvalidAddressTypeError < StandardError
  def initialize
    super('Invalid Address Type: Address type must be int.')
  end
end

#
# Invalid Address Pointer Error
#
class InvalidAddressPointerError < StandardError
  def initialize
    super('Invalid Address Pointer: Address is out of range on memory stack')
  end
end
