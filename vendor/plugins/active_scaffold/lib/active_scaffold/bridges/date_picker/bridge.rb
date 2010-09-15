ActiveScaffold::Bridges.bridge "DatePicker" do
  install do
    directory = File.dirname(__FILE__)
    source = File.join(directory, "public/javascripts/date_picker_bridge.js")
    destination = File.join(Rails.root, "public/javascripts/active_scaffold/default/")

    if ActiveScaffold.js_framework == :jquery
      require File.join(directory, "lib/datepicker_bridge.rb")
      begin
        FileUtils.cp(source, destination)
      rescue
        raise $! unless Rails.env == 'production'
      end
    else
      # make sure that jquery files are removed
      FileUtils.rm(File.join(destination, 'date_picker_bridge.js')) if File.exist?(File.join(destination, 'date_picker_bridge.js'))
    end
  end
  
  install? do
    true
  end
end
