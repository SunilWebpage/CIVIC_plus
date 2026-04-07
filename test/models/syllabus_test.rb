require "test_helper"

class SyllabusTest < ActiveSupport::TestCase
  test "requires an attached pdf file" do
    syllabus = Syllabus.new(
      category: "Banking",
      exam_name: "IBPS PO",
      title: "IBPS PO Syllabus"
    )

    assert_not syllabus.valid?
    assert_includes syllabus.errors[:pdf_file], "must be attached"
  end
end
