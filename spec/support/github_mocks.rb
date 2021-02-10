# frozen_string_literal: true

module GithubMocks
  def github_mock_repo_list
    stub = stub_request(:get, %r{https://api.github.com/user/repos\?access_token=\w*})
    stub.to_return(
      body: [{ id: '1', name: 'My Repo', owner: { login: 'foo' } }].to_json
    )
  end
end
