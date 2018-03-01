class MarkovTextController < ApplicationController
	def show
		render html: "<h1>Генератор текста по цепям Маркова</h1>"
	end

	def generate
		redirect_to :show
	end
end
