require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  describe '#app_is_active?' do
    let(:pid_file) { "#{Rails.root}/config/app_is_inactive.pid" }
    subject { app_is_active? }
    context 'when app is active' do
      before { File.delete pid_file if File.exist?(pid_file) }
      it { is_expected.to be true }
    end
    context 'when app is inactive' do
      before { File.open(pid_file, 'w'){|f| f.write Process.pid} }
      it { is_expected.to be false }
    end
  end

  describe '#word_break' do
    let(:word) { 'short' }
    subject { word_break(word) }
    context 'when the word is shorter than 10 characters' do
      it { is_expected.to eql 'short' }
    end
    context 'when the word is longer than 10 characters' do
      let(:word) { 'extralongwordhere' }
      it { is_expected.to eql '<abbr title="extralongwordhere">extralo...</abbr>' }
    end
  end

  describe '#sortable' do
    let(:sort_direction) { 'asc' }
    let(:sort_column) { 'author' }
    subject { sortable('title') }
    it { is_expected.to eql '<a href="http://test.host/admin/users?direction=asc&amp;id=&amp;sort=title">Title</a>' }
  end

  describe '#user_status' do
    subject { user_status(user) }
    context 'when user is an admin' do
      let(:user) { create(:admin) }
      it { is_expected.to eql "Admin" }
    end
    context 'when user is an override access user' do
      let(:user) { create(:override_access) }
      it { is_expected.to eql "Exception" }
    end
    context 'when user neither admin nor exception' do
      let(:user) { create(:user) }
      it { is_expected.to be_nil }
    end
  end

  describe '#renewal_checked?' do
    subject { renewal_checked? }
    context 'when submission is a renewal' do
      before { @user = create(:user, marli_renewal: "Renewal") }
      it { is_expected.to be true }
    end
    context 'when submission is not a renewal' do
      before { @user = create(:user, marli_renewal: "New Applicant") }
      it { is_expected.to be false }
    end
  end

  describe '#registration_emails' do
    let(:emails) {
      "test@nyu.edu:NYU Marli::test1@nypl.org:NY Public Lib"
    }
    before { ENV["REGISTRATION_EMAILS"] = emails }
    subject { registration_emails }

    context 'when env var is properly set' do
      it { is_expected.to be_instance_of Array }
      its(:size) { is_expected.to eql 2 }
      it { is_expected.to include("email"=>"test@nyu.edu", "institution"=>"NYU Marli") }
      it { is_expected.to include("email"=>"test1@nypl.org", "institution"=>"NY Public Lib") }
    end
    context 'when env var is improperly formatted' do
      let(:emails) { "test-123" }
      it { is_expected.to be_instance_of Array }
      its(:size) { is_expected.to eql 1 }
      it { is_expected.to include("email"=>"test-123", "institution"=>"test-123") }
    end
    context 'when env var is nil' do
      let(:emails) { nil }
      it { is_expected.to be_nil }
    end
  end

end
