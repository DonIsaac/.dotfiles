#!/usr/bin/env node

const fs = require('fs').promises
const { link, shell }  = require('./conf.json')

const forceReplace = true

/**
 * Creates symlinks for a set of dotfiles.
 *
 * @param {ArrayLike<[string, string]>} links the links to create. Each element
 * is in the format `[/path/to/new/symlink, /path/to/dotfile/being/linked]`.
 *
 * @returns {Promise<void>[]} a list of promises that resolve when all dotfiles are linked.
 */
function linkFiles(links) {
	if (!links || !(links instanceof Array))
		throw new Error("links must be a non-null list")

	/** @type {Promise<void>[]} **/
	const promises = links.map(
		([ to, from ]) => fs.link(from, to)
		.catch(err => `Could link dotfile ${from} to ${to}: ${err.stack || err.message || err}`)
	)

	return Promise.all(promises)
}

for (const [ to, from ] of Object.entries(link)) {
	console.log(to, from)
	console.log('next')
}

