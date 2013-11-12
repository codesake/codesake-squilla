require 'singleton'
require 'mechanize'



module Codesake
  module Squilla
    class Engine
      include Singleton

      attr_reader :payloads
      attr_accessor :options

      ## XXX: similiar as cross... only the name prefix change
      def create_log_filename(target)
        begin
          return "squilla_#{URI.parse(target).hostname.gsub('.', '_')}_#{Time.now.strftime("%Y%m%d")}.log"
        rescue
          return "squilla_#{Time.now.strftime("%Y%m%d")}.log"
        end
      end

      # Starts the engine
      ## XXX: similiar as cross
      def start(options = {:exploit_url=>false, :debug=>false, :oneshot=>false, :sample_post=>"", :parameter_to_tamper=>"", :auth=>{:username=>nil, :password=>nil}, :target=>"", :payloads=>[]})
        @agent = Mechanize.new {|a| a.log = Logger.new(create_log_filename(options[:target]))}
        @agent.user_agent_alias = 'Mac Safari'
        @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @options = options
        @target = options[:target]
        @payloads = options[:payloads]
        @options = options
        @results = []
      end 


      ## XXX: similiar to cross
      def inject
        start if @agent.nil?

        $logger.log "Authenticating to the app using #{@options[:auth][:username]}:#{@options[:auth][:password]}" if debug? && authenticate?

        @agent.add_auth(@target, @options[:auth][:username], @options[:auth][:password]) if authenticate?
        begin
          page = @agent.get(@target)
        rescue Mechanize::UnauthorizedError
          $logger.err 'Authentication failed. Giving up.'
          return false
        rescue Mechanize::ResponseCodeError
          $logger.err 'Server gave back 404. Giving up.'
          return false
        rescue Net::HTTP::Persistent::Error => e
          $logger.err e.message
          return false
        end


        if page.forms.size == 0
          $logger.log "no forms found, please try to exploit #{@target} with the -u flag"
          return false
        else
          $logger.log "#{page.forms.size} form(s) found" if debug?
        end

        @payloads.each do |pattern|
          attack_form(page, pattern)
        end
        @results.empty?
      end



      private

      ## XXX private section is equal to cross
      
      def debug?
        @options[:debug]
      end
      def authenticate?
        ! ( @options[:auth][:username].nil?  &&  @options[:auth][:password].nil? )
      end


      def attack_form(page = Mechanize::Page.new, pattern)
        $logger.log "using attack vector: #{pattern}" if debug?

        page.forms.each do |f|
          f.fields.each do |ff|
            if  options[:sample_post].empty?
              ff.value = pattern if options[:parameter_to_tamper].empty?
              ff.value = pattern if ! options[:parameter_to_tamper].empty? && ff.name==options[:parameter_to_tamper]
            else
              ff.value = find_sample_value_for(options[:sample_post], ff.name) unless ff.name==options[:parameter_to_tamper]
              ff.value = pattern if ff.name==options[:parameter_to_tamper]

            end
          end

          begin
            pp = @agent.submit(f)
            $logger.log "header: #{pp.header}" if debug? && ! pp.header.empty?
            $logger.log "body: #{pp.body}" if debug? && ! pp.body.empty?
            $logger.err "Page is empty" if pp.body.empty?
          rescue => e
            return false
          end
        end 

        false
      end

      def find_sample_value_for(sample, name)
        v=sample.split('&')
        v.each do |post_param|
          post_param_v = post_param.split('=')
          return post_param_v[1] if post_param_v[0] == name
        end

        return ""
      end
    end

  end
end
