'use strict'

path = require 'path'
fs = require 'fs'
_ = require 'underscore'
lantfile = require './file'

class Common

	constructor: ->
		# console.log(this)

	@getMdFiles: (files_path) ->
		files = []
		raw_files = fs.readdirSync(files_path)
		_.each(
			raw_files,
			(file) ->
				full_path = files_path + "/#{file}"
				f = new lantfile(full_path)
				stat = fs.statSync(full_path)
				if stat.isDirectory() and not /^\./.test(path.basename(full_path))
					files.push(Common.getMdFiles(full_path))
				else
					if(stat.isFile() and f.isValid())
						files.push(
							name:
								f.name()
							full_path:
								f.full_path
							url:
								f.url()
							content:
								f.content()
							markup:
								f.render()
						)

		)

		return _.flatten files

_.each(
	Common.getMdFiles(process.cwd()), (file) ->
		console.log(file.url)
)
module.exports = Common
