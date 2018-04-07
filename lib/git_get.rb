require 'pry'
require 'github_api'

class PullRequest
  def initialize(github, state='all')
    @prs ||= github.pull_requests.list state: state
  end

  def pr_numbers
    @pr_numbers ||= @prs.map {|pr| pr[:number]}
  end
end

prs = PullRequest.new(Github.new user: 'nekomaho', repo: 'dotfiles')
p prs.pr_numbers

