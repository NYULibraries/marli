require 'spec_helper'

describe Marli::Affiliations do
  include Marli::Affiliations

  let(:patron_status) { '54' }
  let(:current_user) { create(:user, patron_status: patron_status) }

  describe '#affiliation_text' do
    subject { current_user.affiliation_text }
    context 'when patron status is 54' do
      it { is_expected.to eql 'NYU PhD student' }
    end
    context 'when patron status is 50' do
      let(:patron_status) { '50' }
      it { is_expected.to eql 'NYU Full-time Faculty' }
    end
    context 'when patron status does not have known text' do
      let(:patron_status) { '03' }
      it { is_expected.to eql 'NYU PhD Student' }
    end
  end

  describe '#auth_types_collection' do
    subject { current_user.auth_types_collection }
    it { is_expected.to include("50" => "NYU Full-time Faculty") }
  end

  describe '#auth_types_array' do
    subject { current_user.auth_types_array }
    it { is_expected.to include "nyu_ag_noaleph_NYU_Emeritus/Retired_Faculty" }
  end

  describe '#auth_types' do
    subject { current_user.auth_types }
    context 'when http request is successful' do
      it { is_expected.to include({"id"=>88,
                                  "code"=>"nyu_ag_noaleph_NYU_Emeritus/Retired_Faculty",
                                  "original_text"=>nil,
                                  "web_text"=>"NYU Emeritus/Retired Faculty",
                                  "description"=>nil,
                                  "from_aleph"=>false,
                                  "created_at"=>"2010-02-03T02:00:38.000Z",
                                  "updated_at"=>"2015-11-18T15:23:21.000Z",
                                  "visible"=>true,
                                  "id_type"=>"NYU ID",
                                  "under_header"=>"NYU",
                                  "keywords"=>"Retired Faculty, Emeritus Faculty, Retired, Emeritus"}) }
    end
    context 'when http request results in a timeout to the privileges guide' do
      before { allow(HTTParty).to receive(:get).and_raise(Timeout::Error) }
      it 'raises a Timeout error' do
        expect { subject }.to raise_error Timeout::Error
      end
    end
  end

  describe '#attrs' do
    context 'when module is included in User model' do
      subject { current_user.attrs }
      it { is_expected.to include(:patron_status => "54") }
    end
    context 'when module is included as a helper' do
      subject { attrs }
      it { is_expected.to include(:patron_status => "54") }
    end
  end

end
