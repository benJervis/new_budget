require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( name: "Example User",
                      email: "user@example.com",
                      password: 'foobar',
                      password_confirmation: 'foobar' )
  end

  test 'user should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '         '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '    '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * (256 - '@example.com'.length) + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should only accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@bax.cn]
    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, "#{addr.inspect} should be valid"
    end
  end

  test 'email should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example foo@bar_baz.com foo@bar+baz.com user@example..com]
    invalid_addresses.each do |addr|
      @user.email = addr
      assert_not @user.valid?, "#{addr.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be case insensitive' do
    mixed_case_email = 'USER@exAmple.COm'
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.email, mixed_case_email.downcase
  end

  test 'password should be present (non-blank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
