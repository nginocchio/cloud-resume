const toggle = document.querySelector('.dropdown__toggle');
if (toggle) {
  toggle.addEventListener('click', (event) => {
    const dropdown = event.currentTarget.parentNode;
    dropdown.classList.toggle('is-open');
  });
}

const projectFilters = document.querySelectorAll('.project-filter');
const projectCards = document.querySelectorAll('.project-card');
const projectCount = document.querySelector('.project-count');

if (projectFilters.length && projectCards.length && projectCount) {
  projectFilters.forEach((filter) => {
    filter.addEventListener('click', () => {
      const category = filter.dataset.filter;
      let visibleProjects = 0;

      projectFilters.forEach((button) => {
        const isActive = button === filter;
        button.classList.toggle('is-active', isActive);
        button.setAttribute('aria-pressed', String(isActive));
      });

      projectCards.forEach((card) => {
        const isVisible = category === 'all' || card.dataset.categories.split(' ').includes(category);
        card.hidden = !isVisible;
        visibleProjects += Number(isVisible);
      });

      projectCount.textContent = `${visibleProjects} ${visibleProjects === 1 ? 'project' : 'projects'}`;
    });
  });
}
