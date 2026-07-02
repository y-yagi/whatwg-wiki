(function () {
  const nav = document.getElementById('nav');
  const content = document.getElementById('content');
  const search = document.getElementById('search');

  function currentPage() {
    return new URLSearchParams(location.search).get('p');
  }

  function wikilinksToMarkdown(text) {
    return text.replace(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g, (_, target, label) => {
      const t = target.trim();
      return `[${(label || t).trim()}](?p=${encodeURIComponent(t)})`;
    });
  }

  function parseFrontmatter(text) {
    const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
    if (!match) return { meta: {}, body: text };
    const meta = {};
    for (const line of match[1].split(/\r?\n/)) {
      const idx = line.indexOf(':');
      if (idx === -1) continue;
      const key = line.slice(0, idx).trim();
      let value = line.slice(idx + 1).trim();
      if (value.startsWith('[') && value.endsWith(']')) {
        value = value.slice(1, -1).split(',').map((v) => v.trim()).filter(Boolean);
      }
      meta[key] = value;
    }
    return { meta, body: text.slice(match[0].length) };
  }

  function renderMeta(meta) {
    const badges = [];
    if (meta.spec) badges.push(`<span class="badge badge-spec">${meta.spec}</span>`);
    if (Array.isArray(meta.tags)) {
      for (const tag of meta.tags) badges.push(`<span class="badge badge-tag">${tag}</span>`);
    }
    if (meta.updated) badges.push(`<span class="badge badge-updated">updated ${meta.updated}</span>`);
    if (badges.length === 0) return '';
    return `<div class="meta">${badges.join('')}</div>`;
  }

  async function fetchPage(name) {
    const res = await fetch(`wiki/${name}.md`);
    if (!res.ok) throw new Error('not found');
    return res.text();
  }

  async function renderContent() {
    const page = currentPage();
    const name = page || 'index';
    content.innerHTML = 'Loading…';
    try {
      const raw = await fetchPage(name);
      const { meta, body } = parseFrontmatter(raw);
      const html = marked.parse(wikilinksToMarkdown(body));
      content.innerHTML = renderMeta(meta) + html;
      document.title = page ? `${page} — WHATWG Wiki` : 'WHATWG Wiki';
    } catch (err) {
      content.innerHTML = `
        <div class="not-found">
          <h1>Page not found</h1>
          <p>Couldn't load <code>wiki/${name}.md</code>.</p>
          <p><a href="index.html">Back to index</a></p>
        </div>`;
    }
    highlightActive(page);
  }

  function highlightActive(page) {
    const links = nav.querySelectorAll('a');
    links.forEach((a) => {
      const href = new URL(a.href).searchParams.get('p');
      a.classList.toggle('active', page ? href === page : !href);
    });
  }

  async function renderSidebar() {
    try {
      const raw = await fetchPage('index');
      const { body } = parseFrontmatter(raw);
      nav.innerHTML = marked.parse(wikilinksToMarkdown(body));
    } catch (err) {
      nav.innerHTML = '<p>Failed to load index.</p>';
    }
    highlightActive(currentPage());
  }

  search.addEventListener('input', () => {
    const q = search.value.trim().toLowerCase();
    nav.querySelectorAll('li').forEach((li) => {
      li.style.display = !q || li.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
  });

  window.addEventListener('popstate', renderContent);

  renderSidebar();
  renderContent();
})();
