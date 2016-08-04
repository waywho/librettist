class TranslatorsController < ApplicationController
	before_action :get_token, :only => [:index]

	def index
		if params[:output]
			@output = params[:output]
		end

	end

	def show
	end

	def translate
		translator = BingTranslator.new(ENV['Microsoft_id'], ENV['Microsoft_secret'], false, ENV['Azure_account_key'])
		@text = translator_params[:libretto].squish.split(/\s*(?<=[.,;?])\s*|\s{2,}|[\r\n]+/x)
		# # @output = EasyTranslate.translate(@text, :to => :en, :key => ENV['Google_API_Key']).split(/\s*(?<=[.,;?])\s*|\s{2,}|[\r\n]+/x)
		@output = translator.translate_array2(@text, from: 'it', to: 'en')
		# .split(/\s*(?<=[.,;?])\s*|\s{2,}|[\r\n]+/x)
		# response = RestClient.post(
		# 	"http://api.microsofttranslator.com/V2/Http.svc/GetTranslations",
		# 		:Authorization => "Bearer #{@token['access_token']}",
		# 		:params => {
		# 			"text" => @text,
		# 			"from" => 'it',
		# 			"to" => 'en',
		# 			}
		# 	)
		# @output = response
		# .squish.split(/\s*(?<=[.,;?])\s*|\s{2,}|[\r\n]+/x)
		@text_array = @text
		# .squish.split(/\s*(?<=[.,;?])\s*|\s{2,}|[\r\n]+/x)
		respond_to do |format|
			format.js
		end
	end

	def translation

	end

	private

	def translator_params
		params.require(:translator).permit(:libretto)
	end

	def get_token
		begin
	    translator = BingTranslator.new(ENV['Microsoft_id'], ENV['Microsoft_secret'], false, ENV['Azure_account_key'])
	    @token = translator.get_access_token
	    @token[:status] = 'success'
	  rescue Exception => exception
	    YourApp.error_logger.error("Bing Translator: \"#{exception.message}\"")
	    @token = { :status => exception.message }
	  end

	  @token
	end

	# def translate_params(access_token, text, from, to, content_type = nil)
	# 	param_hash = {
	# 		:Authorization => "Bearer #{access_token}",
	# 		"text" => text,
	# 		"from" => from,
	# 		"to" => to,
	# 		"content_type" => content_type
	# 	}
	# 	param_hash
	# end

	def parse_xml(xml)
      xml_doc = Nokogiri::XML(xml)
      xml_doc.xpath("/").text
    end

	def set_google_api
		EasyTranslate.api_key = ENV['Google_API_KEY']
	end
end
