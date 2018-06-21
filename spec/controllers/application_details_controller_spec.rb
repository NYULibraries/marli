require 'spec_helper'

describe ApplicationDetailsController do
  before { @request.cookies[:_check_passive_login] = true }

  let(:application_detail) { create(:random_application_detail) }
  let(:pid_file) { "#{Rails.root}/config/app_is_inactive.pid" }

  describe 'GET /index' do
    context 'when user is not an admin' do
      login_user
      before { get :index }
      subject { response }
      it { is_expected.to redirect_to root_url }
    end
    context 'when user is an admin' do
      login_admin
      before { get :index }
      subject { response }
      it 'should return all application details objects' do
        expect(assigns(:application_details)).to_not be_nil
      end
      it { is_expected.to render_template :index }
    end
  end

  describe 'GET /edit' do
    login_admin
    before { get :edit, id: application_detail }
    subject { response }
    it 'should assign application detail' do
      expect(assigns(:application_detail)).to_not be_nil
    end
    it { is_expected.to render_template :edit }
  end

  describe 'PUT /update' do
    login_admin
    before { put :update, id: application_detail, application_detail: { the_text: 'new text', purpose: 'new purpose', description: 'new description' } }
    it 'should assign application detail' do
      expect(assigns(:application_detail)).to_not be_nil
      expect(assigns(:application_detail).the_text).to eql 'new text'
      expect(assigns(:application_detail).purpose).to eql 'new purpose'
      expect(assigns(:application_detail).description).to eql 'new description'
    end
    it { is_expected.to redirect_to application_details_url }
  end

  describe 'POST /toggle_application_status' do
    login_admin
    before { post :toggle_application_status }
    subject { response }
    it 'should return all application details objects' do
      expect(assigns(:application_details)).to_not be_nil
    end
    context 'when disable app file already exists' do
      before { File.open(pid_file, 'w'){|f| f.write Process.pid} }
      it 'should delete the file' do
        expect(File.exist?(pid_file)).to be true
      end
    end
    context 'when disable app file does not exist' do
      before { File.delete pid_file if File.exist?(pid_file) }
      it 'should delete the file' do
        expect(File.exist?(pid_file)).to be false
      end
    end
    context 'when format is html' do
      it { is_expected.to redirect_to application_details_url }
    end
  end
end
