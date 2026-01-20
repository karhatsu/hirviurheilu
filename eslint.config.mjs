import pluginJs from '@eslint/js'
import pluginReact from 'eslint-plugin-react'
import pluginReactHooks from 'eslint-plugin-react-hooks'
import globals from 'globals'
import eslintConfigPrettier from 'eslint-config-prettier/flat'

export default [
  pluginJs.configs.recommended,
  pluginReact.configs.flat.recommended,
  pluginReact.configs.flat['jsx-runtime'],
  eslintConfigPrettier,
  {
    plugins: {
      react: pluginReact,
      'react-hooks': pluginReactHooks,
    },

    languageOptions: {
      globals: { ...globals.browser },
      ecmaVersion: 'latest',
    },

    settings: {
      react: {
        version: 'detect',
      },
    },

    rules: {
      'comma-dangle': ['error', 'always-multiline'],
      'react/prop-types': 'off',
      'space-before-function-paren': ['error', 'never'],
    },
  },
]
