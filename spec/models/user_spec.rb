require 'spec_helper'

describe User do

  let(:validate_fields) { true }
  let(:school) { 'NYU School' }
  let(:dob) { '01/01/1971' }
  let(:user) { create(:user, validate_fields: validate_fields, school: school, dob: dob) }

  describe 'validations' do
    subject { user }
    context 'when username is missing' do
      let(:user) { build(:user, username: nil) }
      it { is_expected.to be_invalid }
    end
    context 'when email is missing' do
      let(:user) { build(:user, email: nil) }
      it { is_expected.to be_invalid }
    end
    context 'when validate fields attribute is true' do
      context 'when all required fields are present' do
        it { is_expected.to be_valid }
      end
      context 'when school is missing' do
        let(:school) { nil }
        it { is_expected.to be_invalid }
      end
      context 'when dob is missing' do
        let(:dob) { nil }
        it { is_expected.to be_invalid }
      end
    end
    context 'when validate fields attribute is false' do
      let(:validate_fields) { false }
      context 'when school is missing' do
        let(:school) { nil }
        it { is_expected.to be_valid }
      end
      context 'when dob is missing' do
        let(:dob) { nil }
        it { is_expected.to be_valid }
      end
    end
  end

  describe '#authorized?' do
    subject { user.authorized? }
    context 'when patron status is not a valid Marli status' do
      it { is_expected.to be false }
    end
    context 'when patron status is a valid Marli status' do
      let(:user) { create(:valid_patron) }
      it { is_expected.to be true }
    end
  end

  describe '#admin?' do
    subject { user.admin? }
    context 'when user is not an admin' do
      it { is_expected.to be false }
    end
    context 'when user is an admin' do
      let(:user) { create(:admin) }
      it { is_expected.to be true }
    end
  end

  describe '#override_access?' do
    subject { user.override_access? }
    context 'when user does not have override access' do
      it { is_expected.to be false }
    end
    context 'when user has override access' do
      let(:user) { create(:override_access) }
      it { is_expected.to be true }
    end
  end

  describe "#fullname" do
    subject { user.fullname }
    it { is_expected.to eql "#{user.firstname} #{user.lastname}" }
  end

end
