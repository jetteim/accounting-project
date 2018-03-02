
class MarkovTextController < ApplicationController
	before_action :build_form

	def show
		render html: @form.html_safe
	end

	def generate
		render html: "#{@form}<blockquote>#{creative}</blockquote>".html_safe
	end

	def creative
		markov = MarkyMarkov::Dictionary.new('dictionary')
		p markov.parse_string(params[:dictionary]).join
		res = []
		res << "<h2>#{params[:sentences]} фразы:</h2><p>#{markov.generate_n_sentences params[:sentences].to_i}</p>"
		res << "<h2>фраза из #{params[:words]} слов:</h2><p>#{markov.generate_n_words params[:words].to_i}</p>"
		res.join.html_safe
	end

	def build_form
		form = []
		form << '<h1>Генератор текста по цепям Маркова</h1><form method="POST">'
		form << '<label for="sentences">сгенерировать N фраз</label><br>'
		form << '<input name="sentences" type="number" id="sentences"></input><br>'
		form << '<label for="words">сгенерировать фразу из N слов</label><br>'
		form << '<input name="words" type="number" id="words"></input><br>'
		form << '<label for="dictionary" >Побольше текста</label><br>'
		form << '<textarea rows="8" cols="80" type="textarea" name="dictionary" id="dictionary"></textarea> <br>'
		form << '<input type="submit" value="Submit"></form>'
		@form = form.join
	end

end
