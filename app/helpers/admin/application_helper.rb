module Admin::ApplicationHelper
  def my_text_field
    '<div class="form-group">'
    label :email, "email"
    text_field :email, :class => "form-control"
    '</div>'
  end
end
