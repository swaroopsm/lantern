'use strict'

fs = require 'fs'
path = require 'path'
_ = require 'underscore'
_s = require 'underscore.string'
marked = require 'marked'

class File

	ALLOWED_EXTENSIONS = ['.md', '.markdown', '.mdown']
	URL_PREFIX = "_lantern"

	constructor: (full_path) ->
		@full_path = full_path

	name: ->
		path.basename @full_path

	extension: ->
		path.extname @full_path

	url: ->
		file_with_ext = path.join(File::URL_PREFIX, _s.strRight(@full_path, process.cwd()))
		"#{_s.strLeft(file_with_ext, path.extname(@full_path))}?e=#{_s.strRight(this.extension(), ".")}"

	content: ->
		fs.readFileSync(@full_path, "utf8")

	render: ->
		marked(this.content())

	isValid: ->
		_.contains(File::ALLOWED_EXTENSIONS, this.extension())
		

file = new File(path.join(process.cwd(), "README.md"))
console.log file.render()
