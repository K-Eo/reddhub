module FormHelper
  def pod_form_data
    actions = [
      "ajax:beforeSend->pods--form#beforeSend",
      "ajax:error->pods--form#error"
    ]

    {
      remote: true,
      type: "json",
      controller: "pods--form",
      action: actions.join(" ")
    }
  end

  def attachment_form_data
    {
      "pods--attachments-url" => pod_attachments_path("id"),
      "pods--attachments-no-gif" => t(".errors.nogif"),
      "pods--attachments-no-img" => t(".errors.noimg"),
      "pods--attachments-too-big" => t(".errors.toobig"),
      remote: true,
      controller: "pods--attachments",
      action: "ajax:error->pods--attachments#ajaxError"
    }
  end
end
