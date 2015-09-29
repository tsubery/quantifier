class ProviderDecorator < Draper::Decorator
  delegate_all
  attr_accessor :credential
  delegate :status, to: :credential

  def initialize(object, credential = nil)
    super(object)
    self.credential = (credential || Credential.new).decorate
  end

  def logo(logged_in:)
    greyed = logged_in && !credential?
    h.image_tag("logos/#{name}.png",
                alt: "#{name} Logo",
                class: "logo #{greyed && "greyed"}",
                title: status)
  end

  def credential_link
    if credential?
      h.edit_credential_path(credential)
    else
      h.new_credential_path(provider_name: name)
    end
  end

  def credential?
    credential.persisted?
  end

  def metric_links
    metrics.map do |metric|
      h.link_to metric.title,
                metric_path(metric),
                title: metric.description + ". Click to add or configure."
    end
  end

  def metric_path(metric)
    "/goals/#{name}/#{metric.key}"
  end
end
