const esbuild = require('esbuild')

const esbuildConfig = {
  entryPoints: [
    'app/javascript/fi.js',
    'app/javascript/sv.js',
    'app/javascript/official-fi.js',
    'app/javascript/official-sv.js',
    'app/javascript/public-application.js',
    'app/javascript/official-application.js',
  ],
  bundle: true,
  loader: { '.js': 'jsx' },
  sourcemap: true,
  outdir: 'app/assets/builds',
}

esbuild.build(esbuildConfig).catch(() => process.exit(1))

module.exports = { esbuildConfig }
