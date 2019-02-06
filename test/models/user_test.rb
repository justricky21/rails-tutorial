require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user1 = User.new(name: "test_user", email:"test.user@example.com",
                      password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user1.valid?
  end

  test "name should be present" do
    @user1.name = "        "
    assert_not @user1.valid?
  end

  test "email should be present" do
    @user1.email = "       "
    assert_not @user1.valid?
  end

  test "name should not be too long" do
    @user1.name = "a" * 51
    assert_not @user1.valid?
  end

  test "email should not be too long" do
    @user1.email = "a" * 244 + "@example.com"
    assert_not @user1.valid?
  end

  test "email validations should accept valid address" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user1.email = valid_address
      assert @user1.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid address" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com foo@bar....com]
    invalid_addresses.each do |invalid_address|
      @user1.email = invalid_address
      assert_not @user1.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address should be unique" do
    duplicate_user = @user1.dup
    duplicate_user.email = @user1.email.upcase
    @user1.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user1.email = mixed_case_email
    @user1.save
    assert_equal mixed_case_email.downcase, @user1.reload.email
  end

  test "password should be present (nonblank)" do
    @user1.password = @user1.password_confirmation = "  " * 6
    assert_not @user1.valid?
  end

  test "password should have a minimum length" do
    @user1.password = @user1.password_confirmation = "a" * 5
    assert_not @user1.valid?
  end

  test "authenticated? should return false for a user with not nil digest" do
    assert_not @user1.authenticated?('')
  end

end
