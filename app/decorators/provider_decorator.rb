class ProviderDecorator < DelegateClass(Provider)
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::AssetTagHelper

  attr_accessor :credential

  delegate :status, to: :credential

  def initialize(object, credential = nil)
    super(object)

    credential ||= Credential.new
    self.credential = CredentialDecorator.new(credential)
  end

  def credential_link
    if credential?
      routes.edit_credential_path(credential)
    else
      routes.new_credential_path(provider_name: name)
    end
  end

  def credential?
    credential.persisted?
  end

  def metric_links
    metrics.map do |metric|
      link_to metric.title,
              metric_path(metric),
              title: metric.description + ". Click to add or configure."
    end
  end

  def metric_path(metric)
    "/goals/#{name}/#{metric.key}"
  end

  private

  def routes
    Rails.application.routes.url_helpers
  end
end
