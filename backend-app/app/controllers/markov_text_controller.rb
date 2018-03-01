class MarkovTextController < ApplicationController
	def show
		render html: "<body></body>"
	end

	def generate
		redirect_to :show
	end
end
