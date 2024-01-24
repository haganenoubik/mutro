import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.searchInput = this.element.querySelector('input[type="text"]');

    this.searchInput.addEventListener('input', (event) => {
      this.performSearch(event.target.value);
    });

    const searchForm = this.element.closest('form');
    if (searchForm) {
      searchForm.addEventListener('submit', () => {
        this.clearResults();  // 検索実行後に結果をクリアする
      });
    }
  }

  performSearch(query) {
    if (query.length < 2) return; // 最低文字数の制限

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

    resultsTarget.innerHTML = ''; // 結果表示エリアをクリア

    data.forEach(track => {
      const listItem = document.createElement('li');
      const link = document.createElement('a');
      link.textContent = `${track.artist} - ${track.name}`; // アーティスト名と曲名を組み合わせて表示
      link.href = '#';
      link.classList.add('block', 'p-2', 'hover:bg-gray-100');
      link.addEventListener('click', (event) => {
        event.preventDefault();
        this.searchInput.value = `${track.artist} ${track.name}`; // フォームにアーティスト名と曲名を設定
        this.searchInput.focus(); // 入力フィールドにフォーカス
      });
      listItem.appendChild(link);
      resultsTarget.appendChild(listItem);
    });
  }

  clearResults() {
    const resultsTarget = this.element.querySelector('[data-autocomplete-target="results"]');
    if (resultsTarget) {
      resultsTarget.innerHTML = '';  // 結果表示エリアをクリア
    }
  }
}
