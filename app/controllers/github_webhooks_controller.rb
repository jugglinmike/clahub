class GithubWebhooksController < ApplicationController
  def repo_hook
    event = request.headers['X-GitHub-Event']

    Rails.logger.info(event.inspect)
    Rails.logger.info(params)

    if event == 'push'
      payload = GithubPush.new(params[:payload])
      PushStatusChecker.new(payload).check_and_update
    end
    # payload = params[:payload]
    # if event == 'push'
    #   commits = CommitGroup.fromPushPayload(payload)
    # elsif event == 'pull_request' && payload['action'] == 'synchronize'
    #   commits = CommitGroup.fromPullRequestPayload(payload)
    # end
    # if defined? commits
    #   commits.check_and_update
    # end

    render text: "OK", status: 200
  end
end
