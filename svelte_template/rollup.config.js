import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import svelte from 'rollup-plugin-svelte';
import { terser } from 'rollup-plugin-terser';
import babel from 'rollup-plugin-babel';
import cleanup from 'rollup-plugin-cleanup';

const is_watch = process.env.ROLLUP_WATCH;

const plugins = [
  svelte({
    dev: is_watch,
    onwarn: (warning, handler) => {
      // Disable warning missing attributes.
      if (warning.code === 'a11y-missing-attribute') return;
      handler(warning);
    }
  }),
  resolve({
    browser: true,
  }),
  commonjs(),
  babel({
    exclude: 'node_modules/**',
    presets: [
      [
        "@babel/preset-env",
        {
          "targets": "last 2 versions",
          "loose": true
        }
      ]
    ]
  }),
  cleanup(),
  !is_watch && terser()
];

// Entry create.
const entry = (input, output) => {
  return {
    input: input,
    output: [
      {
        file: output,
        format: 'iife',
        // Set name from output.file name without extension.
        name: output.replace(/^.*[\\\/]/, '').split('.').slice(0, -1).join('.'),
        globals: {
          drupalCore: 'Drupal',
          drupalSettingsCore: 'drupalSettings',
        },
      },
    ],
    external: ['drupalCore', 'drupalSettingsCore'],
    plugins: plugins,
  }
};

// Return entries
export default [
  entry('js/main.js', 'js/myApp.js'),
  entry('you_second_input.js', 'you_second_ouput.js'),
];
