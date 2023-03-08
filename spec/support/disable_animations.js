/*
 * Disable transition, transform, and animation css rules
 * for all feature specs. This produces faster specs that are less prone
 * to flakes due to race conditions of element loading.
 */
var disableAnimationStyles = '-webkit-transition: none !important;' +
                             '-moz-transition: none !important;' +
                             '-ms-transition: none !important;' +
                             '-o-transition: none !important;' +
                             'transition: none !important;' +
                             '-webkit-transform: none !important;' +
                             '-moz-transform: none !important;' +
                             '-ms-transform: none !important;' +
                             '-o-transform: none !important;' +
                             'transform: none !important;' +
                             '-webkit-animation: none !important;' +
                             '-moz-animation: none !important;' +
                             '-ms-animation: none !important;' +
                             '-o-animation: none !important;' +
                             'animation: none !important;'

window.onload = function() {
  var animationStyles = document.createElement('style');
  animationStyles.type = 'text/css';
  animationStyles.innerHTML = '* {' + disableAnimationStyles + '}';
  document.head.appendChild(animationStyles);
};
