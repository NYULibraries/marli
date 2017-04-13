require 'spec_helper'

xdescribe ApplicationController do
  before { @request.cookies[:_check_passive_login] = true }

  describe '#current_user_dev' do
    subject { @controller.send(:current_user_dev) }
    it { is_expected.to be_a User }
  end
  describe '#sort_column' do
    subject { @controller.send(:sort_column, "User") }
    it { is_expected.to eql 'title_sort' }
  end
  describe '#sort_direction' do
    subject { @controller.send(:sort_direction) }
    it { is_expected.to eql 'asc' }
  end
  describe '#is_in_admin_view' do
    subject { @controller.send(:is_in_admin_view) }
    it { is_expected.to be false }
  end
end
