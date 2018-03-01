FORM = "<h1>Генератор текста по цепям Маркова</h1>
<form method='POST'>
	<label for="keywords" >Ключевые слова или слоган/label>
	<input type="text" name="keywords" id="keywords"><br>
	<label for="dictionary" >Побольше текста/label><br>
	<input type="textarea" name="dictionary" id="dictionary"/><br>
	<input type="submit" value="Submit">
</form>".html_safe

class MarkovTextController < ApplicationController
	def show
		render html: FORM
	end

	def generate
		p params[:keywords]
		p params[:dictionary]
		creative = params[:keywords] + params[:keywords]
		render html: "<blockquote>#{creative}</blockquote>"
	end
end
