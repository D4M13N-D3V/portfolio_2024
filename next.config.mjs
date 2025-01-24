// next.config.mjs
const nextConfig = {
    output: 'standalone', // This enables standalone output
    experimental: {
      // These options help optimize the build
      outputFileTracingRoot: undefined,
      outputFileTracingExcludes: {
        '*': [
          'node_modules/@swc/core-linux-x64-gnu',
          'node_modules/@swc/core-linux-x64-musl',
          'node_modules/@esbuild/linux-x64',
        ],
      },
    }
  }
  
  export default nextConfig;