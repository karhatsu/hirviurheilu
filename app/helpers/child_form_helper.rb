module ChildFormHelper
  def remove_child_link(name, f, hide_class, confirm_question, class_name = '')
    onclick = "remove_fields(this, '#{hide_class}', '#{confirm_question}');"
    f.hidden_field(:_destroy) + tag(:input, {:type => 'button', :value => name, :onclick => onclick, class: class_name })
  end

  def add_child_link(name, f, method, id=nil, class_name='')
    fields = new_child_fields(f, method)
    onclick = "insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\");"
    tag(:input, {:type => 'button', :value => name, :onclick => onclick, :id => id, class: class_name})
  end

  def new_child_fields(form_builder, method, index=nil, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    index_str = (index ? "_#{index}" : '')
    form_builder.fields_for(method, options[:object], :child_index => "new#{index_str}_#{method}") do |f|
      render(:partial => options[:partial],
             :locals => { options[:form_builder_local] => f, :index => index })
    end
  end
end
