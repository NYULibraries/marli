require 'spec_helper'

describe Marli::ApplicationDetails do
  include Marli::ApplicationDetails

  let(:purpose) { 'my_purpose' }
  before { create(:application_detail, purpose: purpose)}

  describe '#detail_by_purpose' do
    subject { detail_by_purpose(purpose) }
    it { is_expected.to be_a ApplicationDetail }
  end

  describe '#get_sanitized_detail' do
    subject { get_sanitized_detail(purpose) }
    it { is_expected.to eql "You have already submitted your information" }
  end

  describe '#text_exists?' do
    subject { text_exists?(purpose) }
    it { is_expected.to be true }
  end

end
