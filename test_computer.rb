require('test/unit')
require('./computer')

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
end
