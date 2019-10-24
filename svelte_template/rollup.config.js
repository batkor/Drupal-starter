import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import svelte from 'rollup-plugin-svelte';

// Plugins.
const plugins = [
  svelte({
    dev: true,
  }),
  resolve({
    browser: true,
  }),
  commonjs(),
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
  entry('you_input_main.js', 'you_output_main.js'),
  entry('you_input_main_2.js', 'you_output_main_2.js'),
];
