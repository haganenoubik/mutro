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
        event.preventDefault();  // デフォルトの矢印キーの動作を防止
        this.navigateResults(event.key);
      }
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

  navigateResults(key) {
    const items = Array.from(this.resultsTarget.querySelectorAll('a'));
    const activeIndex = items.findIndex(item => item.classList.contains('active'));

    // アクティブなアイテムからクラスを削除
    if (activeIndex !== -1) {
      items[activeIndex].classList.remove('active', 'bg-cyan-100', 'rounded-lg');
    }

    let newIndex;
    if (key === 'ArrowDown') {
      newIndex = activeIndex >= 0 && activeIndex < items.length - 1 ? activeIndex + 1 : 0;
    } else if (key === 'ArrowUp') {
      newIndex = activeIndex > 0 ? activeIndex - 1 : items.length - 1;
    }

    // 新しいアイテムにクラスを追加
    if (newIndex !== undefined) {
      items[newIndex].classList.add('active', 'bg-cyan-100', 'rounded-lg');
      items[newIndex].scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }

  clearResults() {
    const resultsTarget = this.element.querySelector('[data-autocomplete-target="results"]');
    if (resultsTarget) {
      resultsTarget.innerHTML = '';  // 結果表示エリアをクリア
    }
  }
}
