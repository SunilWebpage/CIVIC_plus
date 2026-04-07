require "test_helper"

class SyllabusesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    Syllabus.stub :distinct, Syllabus do
      Syllabus.stub :order, Syllabus do
        Syllabus.stub :pluck, [] do
          Syllabus.stub :ordered, [] do
            get syllabuses_url
          end
        end
      end
    end

    assert_response :success
  end

  test "filters syllabus by category" do
    filtered_scope = Minitest::Mock.new
    filtered_scope.expect(:group_by, { "NEET" => [] }, [ Symbol ])
    ordered_scope = Minitest::Mock.new
    ordered_scope.expect(:where, filtered_scope, [ String, "neet" ])

    Syllabus.stub :distinct, Syllabus do
      Syllabus.stub :order, Syllabus do
        Syllabus.stub :pluck, [ "NEET", "JEE" ] do
          Syllabus.stub :ordered, ordered_scope do
            get syllabuses_url(filter: "neet")
          end
        end
      end
    end

    assert_response :success
    ordered_scope.verify
    filtered_scope.verify
  end
end
