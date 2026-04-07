require "test_helper"

class QuestionPaperTest < ActiveSupport::TestCase
  test "rejects unsafe pdf_url values" do
    paper = QuestionPaper.new(
      title: "Class 10 Tamil",
      category: "Tamil",
      year: 2026,
      pdf_url: "javascript:alert('xss')"
    )

    assert_not paper.valid?
    assert_includes paper.errors[:pdf_url], "must be an absolute path or an http/https URL"
  end

  test "allows relative and https pdf_url values" do
    relative_paper = QuestionPaper.new(
      title: "Class 10 Tamil",
      category: "Tamil",
      year: 2026,
      pdf_url: "/pdfs/class-10-tamil.pdf"
    )
    https_paper = QuestionPaper.new(
      title: "Class 10 Science",
      category: "Science",
      year: 2026,
      pdf_url: "https://example.com/papers/class-10-science.pdf"
    )

    assert relative_paper.valid?
    assert https_paper.valid?
  end
end
