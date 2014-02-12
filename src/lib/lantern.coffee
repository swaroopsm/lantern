express = require "express"
app = express()
server = require("http").createServer(app)
io = require("socket.io").listen(server)
path = require "path"
fs = require "fs"
_ = require "underscore"
_s = require 'underscore.string'
lantfile = require './file'
lantcommon = require './commons'

app.set('views', path.join(__dirname, '../views'))
app.set('view engine', 'ejs')
app.use("/_lantern", express.static(path.join(__dirname, '../public/')))
app.use("/", express.static(process.cwd()))

server.listen(1619)

app.get(
	'/', (request, response) ->
		response.render(
			'index',
			files:
				lantcommon.getMdFiles(process.cwd())
		)
)

app.get(
	'/_lantern/*', (request, response) ->
		file_path = request.params[0]
		extension = request.query.e
		full_path = path.join(process.cwd(), "#{file_path}.#{extension}")

		file = new lantfile(full_path)

		response.render(
			'markup',
			file:
				file
		)
)

io.sockets.on(
	'connection', (socket) ->

		_.each(
				lantcommon.getMdFiles(process.cwd()), (file) ->
					fs.watchFile(
						(file.full_path),
						interval:
							100
						(curr, prev) ->
							# _.extend(file, {content: output_md(file.full_path)})
							file = new lantfile(file.full_path)
							socket.emit(
								'changes',
								data:
									cleanurl:
										file.cleanurl()
									url:
										file.url()
									content:
										file.render()
							)
					)
			)
)

