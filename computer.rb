require('./errors')
#
# Computer Class which simulates computer
#
class Computer
  # For Unit testing, only for reading instance variables
  attr_reader :memory_stack, :memory_stack_size, :program_counter,
              :stack_pointer
  def initialize(computer_memory_size)
    # Memory stack array of this computer
    @memory_stack = Array.new(computer_memory_size)
    # Memory stack size to reduce to call size method
    @memory_stack_size = computer_memory_size
    # Initial position of program counter is at the first of memory stack
    @program_counter = 0
    # Initial position of stack pointer is at the end of memory stack
    @stack_pointer = @memory_stack_size - 1
  end

  #
  # Public Methods
  #
  def set_address(address)
    raise InvalidAddressTypeError.new unless address.is_a?(Integer)
    raise InvalidAddressPointerError.new \
      unless address >= 0 && address <= @memory_stack_size - 1
    @program_counter = address
    self
  end

  def insert(instruction, operand = nil)
    # instruction arg must be String
    raise InvalidInstructionTypeError.new unless instruction.is_a?(String)
    # Assign Hash of instruction and operand into Memory stack
    @memory_stack[@program_counter] = { instruction: instruction,
                                        operand: operand }
    # Increment current program counter to next cell
    @program_counter += 1
    # return self for method chain
    self
  end

  def execute
    run
  end

  #
  # Private Methods
  #
  private

  def run
  end
end
