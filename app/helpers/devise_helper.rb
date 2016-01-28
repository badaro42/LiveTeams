module DeviseHelper

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <script>
       noty({text: '#{sentence}',
             timeout: 6500, type: 'information', layout: 'bottomCenter'});
     </script>
    HTML

    puts "**************************************"
    puts "**************************************"
    puts "* CENA DOS ERROS E ALERTAS DO DEVISE *"
    puts "------------- messages ---------------"
    puts messages.inspect
    puts "------------- sentence ---------------"
    puts sentence.inspect
    puts "--------------- html -----------------"
    puts html.html_safe
    puts "**************************************"
    puts "**************************************"

    html.html_safe
  end
end