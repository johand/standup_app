# frozen_string_literal: true

module GithubMocks
  def github_mock_repo_list
    stub = stub_request(:get, %r{https://api.github.com/user/repos\?access_token=\w*})
    stub.to_return(
      body: [{ id: '1', name: 'My Repo', owner: { login: 'foo' } }].to_json
    )
  end

  def github_mock_webhook_add(user, repo)
    stub = stub_request(:post, %r{https://api.github.com/repos/#{user}/#{repo}/hooks\?access_token=\w*})
    stub.to_return(
      body: { config: { url: 'https://awes.ome' } }.to_json
    )
  end

  def github_mock_webhook_remove(user, repo, hook_id)
    stub = stub_request(:delete, %r{https://api.github.com/repos/#{user}/#{repo}/hooks/#{hook_id}\?access_token=\w*})

    stub.to_return(
      body: { config: { url: 'https://awes.ome' } }.to_json
    )
  end
end
