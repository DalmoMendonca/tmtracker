require 'test_helper'

class SpeechesControllerTest < ActionController::TestCase
  setup do
    @speech = speeches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:speeches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create speech" do
    assert_difference('Speech.count') do
      post :create, speech: { chart_id: @speech.chart_id, club: @speech.club, comment: @speech.comment, date: @speech.date, manual: @speech.manual, project: @speech.project, title: @speech.title }
    end

    assert_redirected_to speech_path(assigns(:speech))
  end

  test "should show speech" do
    get :show, id: @speech
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @speech
    assert_response :success
  end

  test "should update speech" do
    patch :update, id: @speech, speech: { chart_id: @speech.chart_id, club: @speech.club, comment: @speech.comment, date: @speech.date, manual: @speech.manual, project: @speech.project, title: @speech.title }
    assert_redirected_to speech_path(assigns(:speech))
  end

  test "should destroy speech" do
    assert_difference('Speech.count', -1) do
      delete :destroy, id: @speech
    end

    assert_redirected_to speeches_path
  end
end
