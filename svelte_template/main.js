import CartCount from './CartCount.svelte'
import Drupal from 'drupalCore';

Drupal.behaviors.cartCount = {
  attach: function (context) {
    context = context || document;
    let target = context.querySelector('#app-cart_count');
    if (target) {
      Drupal.app.methods.removeChild(target);
      new CartCount({
        target: target
      });
    }
  },
};