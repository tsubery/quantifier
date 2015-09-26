class ProviderDecorator < Draper::Decorator
  delegate_all
  attr_accessor :credential
  delegate :status, to: :credential

  def initialize(object, credential)
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
                "/goals/#{name}/#{metric.key}",
                title: metric.description + ". Click to add or configure."
    end
  end
end
