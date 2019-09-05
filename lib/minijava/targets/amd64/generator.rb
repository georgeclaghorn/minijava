module MiniJava
  module AMD64
    class Generator < Visitor
      LIBRARY_PATH = File.expand_path("../library.s", __FILE__)

      attr_reader :destination
      delegate :puts, :print, to: :@destination

      def initialize(destination)
        @destination = destination
      end

      def generate(instructions, entrypoint)
        puts ".text"
        puts ".globl _main"
        puts

        puts "_main:"
        puts "call #{entrypoint}"
        puts "xor %rax, %rax"
        puts "ret"
        puts

        visit_all instructions
        puts

        inject_library
      end


      def visit_label(label)
        puts "#{label.name}:"
      end

      def visit_add(add)
        case add.destination
        when add.left
          puts "add #{resolve(add.right)}, #{resolve(add.left)}"
        when add.right
          puts "add #{resolve(add.left)}, #{resolve(add.right)}"
        else
          puts "mov #{resolve(add.left)}, #{resolve(add.destination)}"
          puts "add #{resolve(add.right)}, #{resolve(add.destination)}"
        end
      end

      def visit_subtract(subtract)
        case subtract.destination
        when subtract.left
          puts "sub #{resolve(subtract.right)}, #{resolve(subtract.left)}"
        when subtract.right
          puts "neg #{resolve(subtract.right)}"
          puts "add #{resolve(subtract.left)}, #{resolve(subtract.right)}"
        else
          puts "mov #{resolve(subtract.left)}, #{resolve(subtract.destination)}"
          puts "sub #{resolve(subtract.right)}, #{resolve(subtract.destination)}"
        end
      end

      def visit_multiply(multiply)
        case multiply.destination
        when multiply.left
          puts "mul #{resolve(multiply.right)}, #{resolve(multiply.left)}"
        when multiply.right
          puts "mul #{resolve(multiply.left)}, #{resolve(multiply.right)}"
        else
          puts "mov #{resolve(multiply.left)}, #{resolve(multiply.destination)}"
          puts "mul #{resolve(multiply.right)}, #{resolve(multiply.destination)}"
        end
      end

      def visit_copy(copy)
        puts "mov #{resolve(copy.source)}, #{resolve(copy.destination)}"
      end

      def visit_parameter(parameter)
        puts "mov #{resolve(parameter.source)}, %rdi"
      end

      def visit_call(call)
        puts "call #{call.label}"
      end

      def visit_return(instruction)
        puts "ret"
      end

      private
        def inject_library
          IO.copy_stream(LIBRARY_PATH, destination)
        end


        REGISTERS = %w[ %r12 %r13 %r14 %r15 %rbx ]

        def resolve(operand)
          case operand
          when MiniJava::Protocode::RegisterOperand
            REGISTERS[operand.number] || raise("Too many registers")
          when Integer
            "$#{operand}"
          end
        end
    end
  end
end
