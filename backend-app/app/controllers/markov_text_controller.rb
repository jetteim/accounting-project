FORM = '<h1>Генератор текста по цепям Маркова</h1> <form method="POST"> <label for="keywords" >Ключевые слова или слоган</label> <input type="text" name="keywords" id="keywords"><br> <label for="dictionary" >Побольше текста</label><br> <textarea type="textarea" name="dictionary" id="dictionary"></textarea> <br> <input type="submit" value="Submit"></form>'

class MarkovTextController < ApplicationController
	def show
		render html: FORM.html_safe
	end

	def generate
		p params[:keywords]
		p params[:dictionary]
		creative = params[:keywords] + params[:keywords]
		render html: "<blockquote>#{creative}</blockquote>".html_safe
	end
end
