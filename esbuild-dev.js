const esbuild = require('esbuild')
const { esbuildConfig } = require('./esbuild')

let ctx
async function run() {
  ctx = await esbuild.context(esbuildConfig)
  await ctx.watch()
}

run().catch(console.error).finally(ctx && ctx.dispose())
