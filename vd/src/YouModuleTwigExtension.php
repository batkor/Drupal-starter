<?php

namespace Drupal\YOU_MODULE;

use Drupal\Core\Messenger\MessengerInterface;

/**
 * Twig vd extension.
 */
class YouModuleTwigExtension extends \Twig_Extension {

  /**
   * The messenger.
   *
   * @var \Drupal\Core\Messenger\MessengerInterface
   */
  protected $messenger;

  /**
   * Constructs a new YouModuleTwigExtension object.
   *
   * @param \Drupal\Core\Messenger\MessengerInterface $messenger
   *   The messenger.
   */
  public function __construct(MessengerInterface $messenger) {
    $this->messenger = $messenger;
  }

  /**
   * {@inheritdoc}
   */
  public function getFunctions() {
    return [
      new \Twig_SimpleFunction('vd', 'vd'),
    ];
  }

}
