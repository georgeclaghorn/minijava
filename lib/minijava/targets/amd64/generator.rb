module MiniJava
  module AMD64
    class Generator < Visitor
      LIBRARY = File.expand_path("../library.s", __FILE__)

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
          IO.copy_stream(LIBRARY, destination)
        end


        def resolve(operand)
          case operand
          when MiniJava::Protocode::RegisterOperand
            "%r12"
          when Integer
            "$#{operand}"
          end
        end
    end
  end
end
