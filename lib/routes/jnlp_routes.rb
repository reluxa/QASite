get '/poller.jnlp' do
  content_type "application/x-java-jnlp-file"
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.jnlp :spec => "1.0+", :codebase=>base_url do
      xml.information do
        xml.title "Lufthansa Systems QA Poller"
        xml.vendor "Lufthansa"
      end
      xml.resources do
        xml.j2se :version=>"1.6+", :href=>"http://java.sun.com/products/autodl/j2se"
        xml.jar :href=>"poller/poller.jar", :main=>"true"
        xml.jar :href=>"poller/horrorss-2.2.0.jar"
        xml.jar :href=>"poller/JCarrierPigeon-1.3.jar"
        xml.jar :href=>"poller/sparta.jar"
        xml.jar :href=>"poller/timingframework-classic-1.1.jar"
      end
      xml.tag!("application-desc", :name => "Poller", :"main-class"=>"Poller")
      xml.security do
        xml.tag!("all-permissions")
      end
      xml.update :check=>"background"
    end
  end
end