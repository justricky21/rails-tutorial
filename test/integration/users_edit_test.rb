require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user1 = users(:michael)
    @user2 = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user1)
    get edit_user_path(@user1)
    assert_template 'users/edit'
    patch user_path(@user1), params: { user: { name: "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.alert', "The form contains 4 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user1)
    log_in_as(@user1)
    assert_redirected_to edit_user_url(@user1)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user1), params: { user: {name: name,
                                               email: email,
                                               password:              "",
                                               password_confirmation: ""} }
    assert_not flash.empty?
    assert_redirected_to @user1
    @user1.reload
    assert_equal name, @user1.name
    assert_equal email, @user1.email
    log_in_as(@user1)
    assert_redirected_to user_url(@user1)
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@user2)
    get edit_user_path(@user1)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@user2)
    patch user_path(@user1), params: { user: { name: @user1.name,
                                             email: @user1.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end



end
