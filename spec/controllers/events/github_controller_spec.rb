# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::GithubController, type: :controller do
  let!(:team) { FactoryBot.create(:team) }

  describe 'POST #create' do
    it 'signature passes' do
      token = 'sha1=' + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'),
        team.id,
        '{}'
      )

      request.headers['HTTP_X_HUB_SIGNATURE'] = token
      post :create, params: { team_id: team.id }, body: {}.to_json
      expect(response).to have_http_status(:success)
    end

    it 'signature fails' do
      token = 'sha1=' + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'),
        team.id,
        '23rtegf'
      )

      request.headers['HTTP_X_HUB_SIGNATURE'] = token
      post :create, params: { team_id: team.id }, body: {}.to_json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'triggers push event' do
      token = 'sha1=' + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'),
        team.id,
        '{}'
      )

      request.headers['HTTP_X_HUB_SIGNATURE'] = token
      request.headers['HTTP_X_HUB_EVENT'] = 'push'
      post :create, params: { team_id: team.id }, body: {}.to_json
      expect(response).to have_http_status(:success)
    end

    it 'triggers pull request event' do
      token = 'sha1=' + OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'),
        team.id,
        '{}'
      )

      request.headers['HTTP_X_HUB_SIGNATURE'] = token
      request.headers['HTTP_X_HUB_EVENT'] = 'pull_request'
      post :create, params: { team_id: team.id }, body: {}.to_json
      expect(response).to have_http_status(:success)
    end
  end
end
