import pluginJs from "@eslint/js"
import pluginReact from "eslint-plugin-react"
import pluginReactHooks from "eslint-plugin-react-hooks"
import globals from "globals"

export default [
  pluginJs.configs.recommended,
  pluginReact.configs.flat.recommended,
  pluginReact.configs.flat['jsx-runtime'],
  {
    plugins: {
      react: pluginReact,
      "react-hooks": pluginReactHooks,
    },

    languageOptions: {
      globals: { ...globals.browser },
      ecmaVersion: "latest",
    },

    settings: {
      react: {
        version: "detect",
      },
    },

    rules: {
      "comma-dangle": ["error", "always-multiline"],
      "max-len": ["error", { code: 120 }],
      "react/prop-types": "off",
      "semi": ["off", "error"],
      "space-before-function-paren": ["error", "never"],
    },
  }]
