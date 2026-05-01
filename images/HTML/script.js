function toggleMenu() {
    const menu = document.querySelector(".menu-links");
    const icon = document.querySelector(".hamburger-icon");
    menu.classList.toggle("open");
    icon.classList.toggle("open");
}

/* Scroll animation */

ScrollReveal({
    reset: true,             
    distance: '60px',        
    duration: 1000,          
    delay: 200               
  });
  

  ScrollReveal().reveal('.section__text', { origin: 'left' });
  ScrollReveal().reveal('.section__pic-container', { origin: 'right' });
  ScrollReveal().reveal('.about-pic', { origin: 'bottom' });
  ScrollReveal().reveal('.details-container', { origin: 'top' });
  ScrollReveal().reveal('.text-container', { origin: 'top' });
  ScrollReveal().reveal('.btn', { origin: 'bottom' });
  ScrollReveal().reveal('.icon', { origin: 'bottom', interval: 100 });
  