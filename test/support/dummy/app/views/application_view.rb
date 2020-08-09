# frozen_string_literal: true

class ApplicationView < Viu::Html

  private

  def render_errors_if_available(errors)
    return if errors.blank?

    render partial: 'shared/errors', locals: { messages: errors.full_messages }
  end
end
