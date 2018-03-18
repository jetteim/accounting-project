require 'tensorflow'

class ImagesDetectorController < ApplicationController
  before_action :build_form

  def show
	render html: @form.html_safe
  end

  def submit
	File.open(fname = Rails.root.join('tmp', "#{SecureRandom.hex(10)}.jpg"), 'wb') { |file| file.write(params[:file].read) }
  	render json: classify(fname).to_json
  end

  def classify (filename)
  	raise ArgumentError, "Cannot find image file: #{filename}" unless File.file?(filename)
	scope_class = Tensorflow::Scope.new
  	input = Const(scope_class, filename.to_s)
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('ReadFile', 'ReadFile', nil, [input]))
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('DecodeJpeg', 'DecodeJpeg', Hash['channels' => 3], [output.output(0)]))
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('Cast', 'Cast', Hash['DstT' => 1], [output.output(0)]))
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('ExpandDims', 'ExpandDims', nil, [output.output(0), Const(scope_class.subscope('make_batch'), 0, :int32)]))
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('ResizeBilinear', 'ResizeBilinear', nil, [output.output(0), Const(scope_class.subscope('size'), [224, 224], :int32)]))
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('Sub', 'Sub', nil, [output.output(0), Const(scope_class.subscope('mean'), 117.00, :float)]))
	output = input.operation.g.AddOperation(Tensorflow::OpSpec.new('Div', 'Div', nil, [output.output(0), Const(scope_class.subscope('scale'), 1.00, :float)])).output(0)
	graph = scope_class.graph
	session_op = Tensorflow::Session_options.new
	session = Tensorflow::Session.new(graph, session_op)
	out_tensor = session.run({}, [output], [])
	graph = Tensorflow::Graph.new
	# тут надо подгружать модель, которую мы натренируем
	graph.read_file(Rails.root.join('lib', 'tensorflow_inception_graph.pb'))
	tensor = Tensorflow::Tensor.new(out_tensor[0], :float)
	sess = Tensorflow::Session.new(graph)
	hash = {}
	hash[graph.operation('input').output(0)] = tensor
	predictions = sess.run(hash, [graph.operation('output').output(0)], [])
	predictions.flatten!
	labels = {}
	j = 0
	File.foreach(Rails.root.join('lib', 'imagenet_comp_graph_label_strings.txt')) do |line|
	    labels[line] = predictions[j]
	    j += 1
	end
	result = labels.sort { |a, b| b[1].to_f <=> a[1].to_f }
end


	def build_form
		form = []
		form << '<h1>Анализ картинки</h1><form method="POST" enctype="multipart/form-data">'
		form << '<label for="file">Картинка</label><br>'
		form << '<input name="file" type="file" id="file"' + " value=\"#{params[:sentences]}\"" + '></input><br>'
		form << '<input type="submit" value="Submit"></form>'
		@form = form.join
	end


end
