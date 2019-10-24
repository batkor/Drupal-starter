import App from './App.svelte'
import Drupal from 'drupalCore';

Drupal.behaviors.App = {
  attach: function (context) {
    context = context || document;
    let target = context.querySelector('you_selector');
    if (target && !target.classList.contains('once')) {
      new App({
        target: target
      });
      target.classList.add('once');
    }
  },
};
