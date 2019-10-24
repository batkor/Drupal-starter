import App from './App.svelte'
import Drupal from 'drupalCore';

Drupal.behaviors.App = {
  attach: function (context) {
    context = context || document;
    let target = context.querySelector('you_selector');
    if (target) {
      new App({
        target: target
      });
    }
  },
};