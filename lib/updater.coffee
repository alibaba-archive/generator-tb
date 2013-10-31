fs = require 'fs'
levDist = require './levdist'
constructorsPath = 'src/apps/web/constructors.coffee'
mainLessPath = 'src/apps/web/main.less'
zhLocalesPath = 'src/locales/zh.json'
enLocalesPath = 'src/locales/en.json'
DEPS_REG = /^\s\s'.*'$/gm
LESS_IMPORT_REG = /^@import\s"\.\.\/\.\.\/stylesheets.*";$/gm
LOCALES_REG = /^[ ]{4}".*"(?=,)/gm

__updater = (realReference, filePath, matchReg, replaceReference) ->
  fileContent = fs.readFileSync filePath, {
    encoding: 'utf8'
  }
  if fileContent.indexOf(realReference) > -1
    return

  references = fileContent.match matchReg

  referenceLevDist = Number.MAX_VALUE

  for ref in references
    if referenceLevDist > levDist(realReference, ref)
      referenceLevDist = levDist(realReference, ref)
      mostSimilarRef = ref
  insertIndex = fileContent.indexOf(mostSimilarRef) + mostSimilarRef.length
  fileContent = fileContent.substring(0, insertIndex) + replaceReference + fileContent.substring(insertIndex)
  fs.writeFileSync(filePath, fileContent, {
    encoding: 'utf8'
  })

updateConstructors = (reference) ->
  realReference = "'#{reference}'"
  replaceReference = "\n  #{realReference}"
  __updater(realReference, constructorsPath, DEPS_REG, replaceReference)

updateMainLess = (reference) ->
  realReference = "@import \"../../stylesheets/#{reference}\";"
  replaceReference = "\n#{realReference}"
  __updater(realReference, mainLessPath, LESS_IMPORT_REG, replaceReference)

updateLocales = (reference) ->
  realReference = "    \"#{reference}\""
  replaceReference = ",\n#{realReference}"
  __updater(realReference, zhLocalesPath, LOCALES_REG, replaceReference)
  __updater(realReference, enLocalesPath, LOCALES_REG, replaceReference)

exports.updateConstructors = updateConstructors
exports.updateMainLess = updateMainLess
exports.updateLocales = updateLocales