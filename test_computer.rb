require('test/unit')
require('./computer')
require('./errors')

# Test Case for Computer Class
class TCComputer < Test::Unit::TestCase
  def setup
    @computer = Computer.new(100)
  end

  def test_initialize
    assert_equal(100, @computer.memory_stack.size)
    assert_equal(nil, @computer.memory_stack[0])
    assert_equal(nil, @computer.memory_stack[99])
    assert_equal(100, @computer.memory_stack_size)
    assert_equal(0, @computer.program_counter)
    assert_equal(99, @computer.stack_pointer)
  end

  def test_set_address
    # address must be Integer
    assert_raise(InvalidAddressTypeError) do
      @computer.set_address('address')
    end
    # Address must be range of 0..99
    assert_raise(InvalidAddressPointerError) do
      @computer.set_address(-1)
    end
    assert_raise(InvalidAddressPointerError) do
      @computer.set_address(1000)
    end
    # Return value of set_address is Computer instanse itself
    assert_same(@computer, @computer.set_address(1))
    # set_address method assign address to program counter
    @computer.set_address(3)
    assert_equal(3, @computer.program_counter)
  end
end
