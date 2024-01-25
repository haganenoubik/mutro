import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.searchInput = this.element.querySelector('input[type="text"]');
    this.resultsTarget = this.element.querySelector('[data-autocomplete-target="results"]');

    this.searchInput.addEventListener('input', (event) => {
      this.performSearch(event.target.value);
    });

    this.searchInput.addEventListener('keydown', (event) => {
      if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
        event.preventDefault();
        this.navigateResults(event.key);
      } else if (event.key === 'Enter') {
        event.preventDefault();
        this.selectActiveItem();
      }
    });

    const searchForm = this.element.closest('form');
    if (searchForm) {
      searchForm.addEventListener('submit', () => {
        this.clearResults();
      });
    }
  }

  performSearch(query) {
    if (query.length < 2) return;

    fetch(`/tracks/search.json?search=${encodeURIComponent(query)}`, {
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => response.json())
    .then(data => {
      this.displayResults(data);
    })
    .catch(error => console.error("Error:", error));
  }

  displayResults(data) {
    const resultsTarget = this.element.querySelector('[data-autocomplete-target="results"]');

    resultsTarget.innerHTML = '';

    data.forEach(track => {
      const listItem = document.createElement('li');
      const link = document.createElement('a');
      link.textContent = `${track.artist} - ${track.name}`;
      link.href = '#';
      link.classList.add('block', 'p-2', 'hover:bg-gray-100');
      link.addEventListener('click', (event) => {
        event.preventDefault();
        this.searchInput.value = `${track.artist} ${track.name}`;
        this.searchInput.focus();
      });
      listItem.appendChild(link);
      resultsTarget.appendChild(listItem);
    });
  }

  navigateResults(key) {
    const items = Array.from(this.resultsTarget.querySelectorAll('a'));
    const activeIndex = items.findIndex(item => item.classList.contains('active'));

    if (activeIndex !== -1) {
      items[activeIndex].classList.remove('active', 'bg-cyan-100', 'rounded-lg');
    }

    let newIndex;
    if (key === 'ArrowDown') {
      newIndex = activeIndex < items.length - 1 ? activeIndex + 1 : 0;
    } else if (key === 'ArrowUp') {
      newIndex = activeIndex > 0 ? activeIndex - 1 : items.length - 1;
    }

    if (newIndex !== undefined) {
      items[newIndex].classList.add('active', 'bg-cyan-100', 'rounded-lg');
      items[newIndex].scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }

  clearResults() {
    const resultsTarget = this.element.querySelector('[data-autocomplete-target="results"]');
    if (resultsTarget) {
      resultsTarget.innerHTML = '';
    }
  }

  selectActiveItem() {
    const activeItem = this.resultsTarget.querySelector('.active');
    if (activeItem) {
      const activeItemText = activeItem.textContent || '';
      this.searchInput.value = activeItemText.trim();
      this.searchInput.focus();
      this.clearResults();

      const searchForm = this.element.closest('form');
      if (searchForm) {
        searchForm.requestSubmit();
      }
    } else {
      const searchForm = this.element.closest('form');
      if (searchForm && this.searchInput.value.trim() !== '') {
        searchForm.requestSubmit();
      }
    }
  }

}

