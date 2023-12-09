require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do

    it 'saves successfully when all fields are set' do
      user = User.new(
        first_name: 'Ola',
        last_name: 'Nordmann',
        email: 'test@example.com',
        password: 'pass1234',
        password_confirmation: 'pass1234'
      )

      expect(user.save).to be_truthy
    end


    it 'requires password and password_confirmation to be present' do
      user = User.new(
        first_name: 'Ola',
        last_name: 'Nordmann',
        email: 'test@example.com',
        password: nil,
        password_confirmation: nil
      )

      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'requires password and password_confirmation to match' do
      # Matching passwords should be valid
      user_matching = User.new(
        first_name: 'Ola',
        last_name: 'Nordmann',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(user_matching).to be_valid

      # Non-matching passwords should be invalid
      user_non_matching = User.new(
        first_name: 'Ola',
        last_name: 'Nordmann',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'differentpassword'
      )

      expect(user_non_matching).to_not be_valid
      expect(user_non_matching.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'requires emails to be unique in a case-insensitive manner' do
      # Create a user
      User.create!(
        first_name: 'Ola',
        last_name: 'Nordmann',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )

      # Create another user with the same email
      duplicate_user = User.new(
        first_name: 'Buck',
        last_name: 'Neil',
        email: 'TEST@example.COM',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(duplicate_user.save).to be_falsey
      expect(duplicate_user.errors[:email]).to include('has already been taken')

    end

    it 'requires first and last name be present' do
      user = User.new(
        first_name: nil,
        last_name: nil,
        email: 'TEST@example.COM',
        password: 'password123',
        password_confirmation: 'password123'
      )

      expect(user).to_not be_valid
      expect(user.errors.full_messages).to include("First name can't be blank")
      expect(user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'requires the password be minimum 8 characters long' do
      short_password_user = User.new(
        first_name: "Tim",
        last_name: 'Cook',
        email: 'TEST@example.COM',
        password: 'pass123',
        password_confirmation: 'pass123'
      )
      
      expect(short_password_user).to_not be_valid
      short_password_user.save
      expect(short_password_user.errors.full_messages).to include("Password is invalid")
    end


  end

  describe '.authenticate_with_credentials' do
    before(:each) do
      # Create a user for testing
      @user = User.create!(
        first_name: 'Ola',
        last_name: 'Nordmann',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
    end
    it 'authenticates a user with valid credentials' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password123')
      expect(authenticated_user).to eq(@user)
    end

    it 'does not authenticate a user with invalid email' do
      authenticated_user = User.authenticate_with_credentials('invalid_email@example.com', 'password123')
      expect(authenticated_user).to be_nil
    end

    it 'does not authenticate a user with incorrect password' do
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'incorrect_password')
      expect(authenticated_user).to be_nil
    end

    it 'authenticates a user with email containing leading/trailing whitespaces' do
      authenticated_user = User.authenticate_with_credentials('  test@example.com  ', 'password123')
      expect(authenticated_user).to eq(@user)
    end

    it 'authenticates a user with email in different case' do
      authenticated_user = User.authenticate_with_credentials('TEST@example.COM', 'password123')
      expect(authenticated_user).to eq(@user)
    end
  end
end
