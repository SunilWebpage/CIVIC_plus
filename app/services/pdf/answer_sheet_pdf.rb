module Pdf
  class AnswerSheetPdf
    def initialize(answer_sheet)
      @answer_sheet = answer_sheet
    end

    def render
      lines = build_lines
      content = +"BT\n/F1 12 Tf\n50 790 Td\n14 TL\n"
      lines.each_with_index do |line, index|
        content << "#{pdf_text(line)} Tj\n"
        content << "T*\n" unless index == lines.length - 1
      end
      content << "ET"

      stream = "<< /Length #{content.bytesize} >>\nstream\n#{content}\nendstream"

      objects = []
      objects << "<< /Type /Catalog /Pages 2 0 R >>"
      objects << "<< /Type /Pages /Count 1 /Kids [3 0 R] >>"
      objects << "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>"
      objects << "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>"
      objects << stream

      build_pdf(objects)
    end

    private

    def build_lines
      exam = @answer_sheet.exam_practice

      [
        "Study App Answer Sheet",
        "",
        "Student: #{@answer_sheet.user.email}",
        "Exam: #{exam.title}",
        "Subject: #{exam.subject}",
        "Type: #{exam.exam_type}",
        "Submitted: #{@answer_sheet.submitted_at.strftime('%Y-%m-%d %H:%M')}",
        "",
        "Questions:",
        *wrap_lines(exam.questions_text),
        "",
        "Answers:",
        *wrap_lines(@answer_sheet.answers_text)
      ].flat_map { |line| line.is_a?(Array) ? line : [ line ] }.first(45)
    end

    def wrap_lines(text, width = 78)
      text.to_s.split("\n").flat_map do |paragraph|
        next [ "" ] if paragraph.empty?

        paragraph.scan(/.{1,#{width}}(?:\s|\z)|\S+/).map(&:strip)
      end
    end

    def pdf_text(text)
      "(#{escape(text)})"
    end

    def escape(text)
      text.to_s.gsub("\\", "\\\\\\").gsub("(", "\\(").gsub(")", "\\)")
    end

    def build_pdf(objects)
      pdf = +"%PDF-1.4\n"
      offsets = []

      objects.each_with_index do |object, index|
        offsets << pdf.bytesize
        pdf << "#{index + 1} 0 obj\n#{object}\nendobj\n"
      end

      xref_position = pdf.bytesize
      pdf << "xref\n0 #{objects.length + 1}\n"
      pdf << "0000000000 65535 f \n"
      offsets.each do |offset|
        pdf << format("%010d 00000 n \n", offset)
      end
      pdf << "trailer\n<< /Size #{objects.length + 1} /Root 1 0 R >>\nstartxref\n#{xref_position}\n%%EOF"
      pdf
    end
  end
end
