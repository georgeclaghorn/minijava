require "test_helper"
require "active_support/core_ext/object/blank"

class MiniJava::AMD64::CompilationTest < MiniTest::Test
  def test_hello
    output = execute(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(5 + 4);
        }
      }
    JAVA

    assert_equal "9\n", output
  end

  def test_function
    output = execute(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          return 9;
        }
      }
    JAVA

    assert_equal "9\n", output
  end

  private
    def execute(source)
      program   = MiniJava::Parser.program_from(source)
      scope     = MiniJava::ScopeVisitor.scope_for(program)
      protocode = MiniJava::ProtocodeVisitor.protocode_for(program, scope)

      Tempfile.open([ "test", ".S" ]) do |assembly|
        MiniJava::AMD64::Generator.new(assembly).generate(protocode, "HelloWorld.main")

        Tempfile.open("test") do |binary|
          IO.popen([ "gcc", assembly.path, "-o", binary.path ], err: %i[ child out ]) do |out|
            out.read.then do |output|
              out.close
              assert $?.success?, "Assembling/linking failed: gcc: #{output.presence || "no output"}"
            end
          end

          binary.close

          IO.popen(binary.path, err: %i[ child out ]) do |out|
            out.read.tap do |output|
              out.close
              assert $?.success?, "Run failed: #{output.presence || "no output"}"
            end
          end
        end
      end
    end
end
