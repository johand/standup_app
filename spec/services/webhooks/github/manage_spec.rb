# frozen_string_literal: true

require 'rails_helper'

describe Webhooks::Github::Manage do
  subject(:manage) { Webhooks::Github::Manage }

  describe 'create an account' do
    context 'form for input' do
      let(:team) do
        FactoryBot.create(:team,
                          integration_settings: {
                            github_repos: ['test|one']
                          })
      end

      it 'adds a webhook' do
        team.integration_settings = {
          github_repos: ['test|one', 'test|two']
        }

        expect(Webhooks::Github::Add).to receive(:perform_later).once
        manage.new(team).manage
      end

      it 'removes a webhook' do
        team.integration_settings = {
          github_repos: []
        }

        expect(Webhooks::Github::Remove).to receive(:perform_later).once
        manage.new(team).manage
      end
    end
  end
end
