require 'spec_helper'

describe ApplicationDetail do

  let(:application_detail) { create(:application_detail) }

  describe 'validations' do
    subject { application_detail }
    context 'when all required fields are present' do
      it { is_expected.to be_valid }
    end
    context 'when there is no text' do
      let(:application_detail) { build(:application_detail, the_text: nil) }
      it { is_expected.to be_invalid }
    end
    context 'when there is no purpose (all hope is NOT lost)' do
      let(:application_detail) { build(:application_detail, purpose: nil) }
      it { is_expected.to be_invalid }
    end
    context 'when there is not a unique purpose' do
      before { create(:application_detail) }
      subject { build(:application_detail).valid? }
      it { is_expected.to be false }
    end
  end
end
