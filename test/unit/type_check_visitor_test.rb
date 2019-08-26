require "test_helper"

class MiniJava::TypeCheckVisitorTest < MiniTest::Test
  def test_simple_assignment_to_class_name
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            NumberPicker = 1;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid l-value: NumberPicker is a class", error.message
  end

  def test_simple_assignment_to_method_name
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            pick = 1;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid l-value: pick is a method", error.message
  end

  def test_simple_assignment_from_class_name
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            number = NumberPicker;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid r-value: NumberPicker is a class", error.message
  end

  def test_simple_assignment_from_method_name
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            number = pick;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid r-value: pick is a method", error.message
  end

  def test_array_element_assignment_from_class_name
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          int[] numbers;

          public int pick() {
            numbers = new int[1];
            numbers[0] = NumberPicker;
            return numbers[0];
          }
        }
      JAVA
    end

    assert_equal "Invalid r-value: NumberPicker is a class", error.message
  end

  def test_array_element_assignment_from_method_name
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          int[] numbers;

          public int pick() {
            numbers = new int[1];
            numbers[0] = pick;
            return numbers[0];
          }
        }
      JAVA
    end

    assert_equal "Invalid r-value: pick is a method", error.message
  end

  def test_less_than_with_class_name_on_left
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (NumberPicker < 0)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: NumberPicker is a class", error.message
  end

  def test_less_than_with_class_name_on_right
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (0 < NumberPicker)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: NumberPicker is a class", error.message
  end

  def test_less_than_with_method_name_on_left
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (pick < 0)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: pick is a method", error.message
  end

  def test_less_than_with_method_name_on_right
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (0 < pick)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: pick is a method", error.message
  end

  def test_calling_a_method_on_a_primitive
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick(3));
          }
        }

        class NumberPicker {
          public int pick(int bar) {
            return bar.baz();
          }
        }
      JAVA
    end

    assert_equal "Attempt to call non-method baz", error.message
  end

  def test_calling_a_method_on_a_primitive
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick(3));
          }
        }

        class NumberPicker {
          public int pick(int bar) {
            return bar.baz();
          }
        }
      JAVA
    end

    assert_equal "Attempt to call non-method baz", error.message
  end

  def test_calling_an_undefined_method
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          public int bar() {
            return 3;
          }
        }
      JAVA
    end

    assert_equal "Attempt to call undefined method baz", error.message
  end

  def test_binary_arithmetic_operation_with_non_integer_operand_on_left
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (bar < 3)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: expected int, got boolean", error.message
  end

  def test_binary_arithmetic_operation_with_non_integer_operand_on_right
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (3 < bar)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: expected int, got boolean", error.message
  end

  def test_logical_and_with_non_boolean_operand_on_left
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (3 && bar)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: expected boolean, got int", error.message
  end

  def test_logical_and_with_non_boolean_operand_on_right
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (bar && 3)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: expected boolean, got int", error.message
  end

  def test_logical_not_with_non_boolean_operand
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int glorp;

            if (!glorp)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Invalid operand: expected boolean, got int", error.message
  end

  private
    def check(source)
      program = MiniJava::Parser.program_from(source)
      scope = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::TypeCheckVisitor.check(program, scope)
    end
end