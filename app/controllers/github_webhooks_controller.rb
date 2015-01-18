class GithubWebhooksController < ApplicationController
  def repo_hook
    event = request.headers['X-GitHub-Event']
    payload = JSON.parse(params[:payload] || '{}', :object_class => Hashie::Mash)

    Rails.logger.info(event.inspect)
    Rails.logger.info(params)

    owner_name = payload.repository_.owner_.name
    repo_name = payload.repository_.name

    if owner_name && repo_name
      commit_group = CommitGroup.new(owner_name, repo_name)

      if event == 'push'
        commit_group.set_from_payload(payload)
      end

      if commit_group.length > 0
        commit_group.check_and_update
      end
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
