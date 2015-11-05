require 'spec_helper'

describe User do

  let(:user) { create(:user) }

  context 'when user has an invalid patron status' do
    subject { user }
    it { is_expected.to be_valid }
  end

end
