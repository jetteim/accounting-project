FORM = '<h1>Генератор текста по цепям Маркова</h1> <form method="POST"> <label for="keywords" >Ключевые слова или слоган</label> <input type="text" name="keywords" id="keywords"><br> <label for="dictionary" >Побольше текста</label><br> <textarea rows="8" cols="80" type="textarea" name="dictionary" id="dictionary"></textarea> <br> <input type="submit" value="Submit"></form>'

class MarkovTextController < ApplicationController
	def show
		render html: FORM.html_safe
	end

	def generate
		p params[:keywords]
		p params[:dictionary]
		render html: "<blockquote>#{creative}</blockquote>".html_safe
	end

	def creative
		markov = MarkyMarkov::TemporaryDictionary.new
		p markov.parse_string params[:keywords]
		p markov.parse_string params[:dictionary]
		"<h2>три фразы: </h2><p>#{markov.generate_3_sentences}</p><h2>20 слов: </h2><p>#{markov.generate_20_words}</p>".html_safe
	end

end
