require 'test_helper'

class StagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stage = stages(:one)
  end

  test "should get index" do
    get stages_url
    assert_response :success
  end

  test "should get new" do
    get new_stage_url
    assert_response :success
  end

  test "should create stage" do
    assert_difference('Stage.count') do
      post stages_url, params: { stage: { ApplicationID_id: @stage.ApplicationID_id, StageDate: @stage.StageDate, StageText: @stage.StageText } }
    end

    assert_redirected_to stage_url(Stage.last)
  end

  test "should show stage" do
    get stage_url(@stage)
    assert_response :success
  end

  test "should get edit" do
    get edit_stage_url(@stage)
    assert_response :success
  end

  test "should update stage" do
    patch stage_url(@stage), params: { stage: { ApplicationID_id: @stage.ApplicationID_id, StageDate: @stage.StageDate, StageText: @stage.StageText } }
    assert_redirected_to stage_url(@stage)
  end

  test "should destroy stage" do
    assert_difference('Stage.count', -1) do
      delete stage_url(@stage)
    end

    assert_redirected_to stages_url
  end
end
