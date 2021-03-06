require 'spec_helper'

describe UsersController do

  let!(:user) { create(:user) }
  let(:username) { 'newsername' }
  let(:email) { "#{username}@school.edu" }
  let(:admin) { '0' }
  let(:override_access) { '0' }

  context 'when user is not logged in' do

  end
  context 'when user is logged in' do
    before { @request.cookies[:_check_passive_login] = true }
    describe 'GET /index' do
      context 'when user is not an admin' do
        login_user
        before { get :index }
        subject { response }
        it { is_expected.to redirect_to root_url }
      end
      context 'when user is an admin' do
        login_admin
        let(:q) { 'user' }
        let(:format) { 'html' }
        before { get :index, params: {q: q, format: format} }
        subject { response }
        context 'when there is a search keyword' do
          it 'should return all users objects' do
            expect(assigns(:users)).to_not be_nil
          end
        end
        context 'when there is keyword search' do
          let(:q) { nil }
          it 'should return all users objects matching keyword' do
            expect(assigns(:users)).to_not be_nil
          end
        end
        context 'when csv format is requested' do
          let(:format) { "csv" }
          it 'should return downloadable file' do
            expect(response.headers["Content-Type"]).to eql 'text/csv'
            expect(response.headers["Content-Disposition"]).to eql "attachment; filename=\"marli_users_#{DateTime.now.strftime("%Y%m%d%H%m")}.csv\""
          end
        end
        it { is_expected.to render_template :index }
      end
    end

    describe 'GET /new' do
      login_admin
      before { get :new }
      subject { response }
      it 'should initialize a new user' do
        expect(assigns(:user)).to be_a_new User
      end
    end

    describe 'POST /create' do
      login_admin
      before { post :create, params: {user: { username: username, email: email, admin: admin, override_access: override_access}} }
      subject { response }
      context 'when username and email are present' do
        it 'should create a new user' do
          expect(assigns(:user)).to_not be_nil
          expect(assigns(:user).username).to eql "newsername"
          expect(assigns(:user).email).to eql "newsername@school.edu"
          expect(assigns(:user).admin).to be false
          expect(assigns(:user).admin?).to be false
          expect(assigns(:user).override_access).to be false
          expect(flash[:notice]).to eql 'User created'
        end
      end
      context 'when admin is true' do
        let(:admin) { '1' }
        it 'should create an admin user' do
          expect(assigns(:user).admin).to be true
          expect(assigns(:user).admin?).to be true
        end
      end
      context 'when override access is true' do
        let(:override_access) { '1' }
        it 'should create an override access exception user' do
          expect(assigns(:user).override_access).to be true
          expect(assigns(:user).override_access?).to be true
        end
      end
      context 'when username is missing' do
        let(:username) { nil }
        it 'should not be able to save an invalid user' do
          expect(assigns(:user)).to be_invalid
          expect(assigns(:user).errors[:username]).to include "can't be blank"
        end
      end
      context 'when email is missing' do
        let(:email) { nil }
        it 'should not be able to save an invalid user' do
          expect(assigns(:user)).to be_invalid
          expect(assigns(:user).errors[:email]).to include "can't be blank"
        end
      end
    end

    describe 'GET /show' do
      login_admin
      before { get :show, params: { id: user } }
      subject { response }
      it 'should assign user' do
        expect(assigns(:user)).to_not be_nil
      end
      it { is_expected.to render_template :show }
    end

    describe 'PATCH /update' do
      login_admin
      let(:username) { 'newsername2' }
      let(:email) { "#{username}@school.edu" }
      before { patch :update, params: {id: user, user: { username: username, email: email, admin: admin, override_access: override_access}} }
      context 'when trying to change username or email' do
        it 'should not change username or email' do
          expect(assigns(:user)).to_not be_nil
          expect(assigns(:user).username).to eql "#{user.username}"
          expect(assigns(:user).email).to eql "#{user.email}"
        end
      end
      context 'when trying to change admin' do
        let(:admin) { '1' }
        it 'should create an admin user' do
          expect(assigns(:user).admin?).to be true
        end
      end
      context 'when trying to change override access' do
        let(:override_access) { '1' }
        it 'should create an override access exception user' do
          expect(assigns(:user).override_access?).to be true
        end
      end
      it { is_expected.to redirect_to user_url(user) }
    end

    describe 'DELETE /destroy' do
      login_admin
      before { delete :destroy, params: {id: user} }
      it 'should delete user' do
        expect(assigns(:user).destroyed?).to be true
      end
      it { is_expected.to redirect_to users_url }
    end

    describe 'GET /reset_submissions' do
      login_admin
      let!(:before_user) { create(:user, submitted_at: Time.now, submitted_request: true) }
      let(:user_id) { create(:user, submitted_at: Time.now, submitted_request: true).id }
      before { get :reset_submissions, params: { id: user_id } }
      subject { response }
      context 'when user id is specified' do
        it 'should reset submission for specified user' do
          expect(assigns(:user)).to_not be_nil
          expect(assigns(:user).submitted_request).to be_nil
        end
      end
      context 'when user id is not specified' do
        let(:user_id) { nil }
        it 'should reset submission for all users' do
          expect(assigns(:users)).to_not be_nil
        end
      end
      it { expect(flash[:success]).to eql 'Reset successful' }
      it { is_expected.to redirect_to users_url }
    end

    describe 'GET /clear_patron_data' do
      login_admin
      before { get :clear_patron_data }
      subject { response }
      it 'should delete all non-admin users' do
        expect(User.where(admin: [nil, false])).to be_empty
      end
      it { expect(flash[:success]).to eql 'Deleted all non-admin patron data' }
      it { is_expected.to redirect_to users_url }
    end

    describe 'GET /new_registration' do
      login_admin
      before { get :new_registration }
      it 'should assign current user to instance variable' do
        expect(assigns(:user)).to_not be_nil
        expect(assigns(:user)).to be controller.current_user
      end
      it { is_expected.to render_template :new_registration }
    end

    describe 'PATCH /create_registration' do
      login_admin
      let(:barcode) { '12345' }
      let(:marli_renewal) { '1' }
      before { post :create_registration, params: {user: { barcode: barcode }} }
      subject { response }
      it 'should be a valid user' do
        expect(assigns(:user).valid?).to be true
      end
    end

    describe '#sort_column' do
      subject { controller.sort_column }
      it { should eql 'lastname' }
    end

  end
end
