# CONTEXTO — Sistema Compartilhar (continuação de sessão)

## REGRA CRÍTICA
**NUNCA usar o Edit tool no index.html. TODAS as modificações via scripts Python no bash.**

---

## O Projeto
- **Nome:** Sistema Compartilhar
- **Arquivo principal:** `Z:\COMPARTILHAR VENDAS\CLAUDE\Marcos\Sistema Pontti\index.html`
- **Path no bash:** `/sessions/.../mnt/Sistema Pontti/index.html`
- **Backup atual:** `index_backup_v2.html` (o `index_backup.html` original é read-only pelo bash)
- Single-file HTML app, **todos os dados em localStorage**, sem backend
- **7657 linhas, ~787 KB**

---

## Identidade Visual
| Elemento | Valor |
|---|---|
| Navy | `#272A4A` |
| Vermelho | `#D82621` |
| Laranja | `#DE7926` |
| Header gradiente | `linear-gradient(90deg,#D82621,#DE7926) bottom/100% 3px no-repeat, linear-gradient(135deg,#272A4A 0%,#3d4180 60%,#2e4a7a 100%)` |
| Sidebar escura | `linear-gradient(180deg,#272A4A 0%,#1e2240 100%)` |
| Ícones | Tabler Icons (`ti ti-*`) + FontAwesome (`fas fa-*`) |

---

## Layout Padrão de Página
```
pg-two-col  →  grid-template-columns: 230px 1fr; gap:12px; align-items:start
pg-side     →  sidebar escura, border-radius:12px, overflow:hidden, position:sticky;top:10px
```
- Cada página tem: **header gradiente** + **pg-two-col** (sidebar filtros + painel direito branco)
- Painel direito: `background:#fff; border-radius:12px; box-shadow:...; overflow:hidden`

---

## Páginas Implementadas
| ID | Módulo |
|---|---|
| `page-home` | Dashboard com Chart.js |
| `page-meta-list/form` | Metas |
| `page-cat-cliente-list/form` | Categoria de Clientes |
| `page-cat-produto-list/form` | Categoria de Produtos |
| `page-fornecedor-list/form` | Fornecedores |
| `page-transp-list/form` | Transportadoras |
| `page-empresa-view/form` | Empresa |
| `page-cliente-list/form` | Clientes |
| `page-produto-list/form` | Produtos |
| `page-catalogo-list` | Catálogos (viewer PDF flip-book) |
| `page-tabpreco-list/form` | Tabela de Preço |
| `page-consulta-preco` | Consulta de Preço |
| `page-sku-clientes-list/form` | SKU Clientes ← **último módulo implementado** |

---

## Funções de Dados (localStorage)
```javascript
getFornecedores()    // campo: nome_fantasia, razao_social, codigo, id
getClientes()        // campo: nome_fantasia, razao_social, codigo, id
getProdutos()        // campo: nome, codigo, id
getCatClientes()     // campo: nome, id, pai  ← "Redes" ficam aqui (ex: Hiperideal)
getSkuClientes()     // campo: id, tipo, fornId, fornNome, cliId, cliNome, prodId, prodNome, sku, forma, dtCadastro
setSkuClientes(d)
```

---

## Padrões de Código JS

### Autocomplete (padrão TabPreco/SKU)
```javascript
var _itemsArray = [];  // array global indexado
function _filtrar() {
  _itemsArray = getData().filter(...).slice(0,15);
  drop.innerHTML = _itemsArray.map(function(f, i){
    return '<div onclick="_sel('+i+')" ...>...</div>';
  }).join('');
}
function _sel(i) {
  var f = _itemsArray[i]; if (!f) return;
  document.getElementById('input-id').value = f.id;
  document.getElementById('input-txt').value = f.nome;
}
```
**NÃO usar `this.dataset` — usar índice no array global.**

### Escape HTML (fora do dashboard IIFE)
```javascript
function _skuEsc(s) { return String(s||'').replace(/[&<>"]/g, function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c];}); }
```
`escapeHtml` só existe dentro do dashboard IIFE (linha ~6506) — não é global.

### Normalização para busca
```javascript
_cpNorm(s)  // remove acentos, lowercase — já existe globalmente
```

### showPage
```javascript
function showPage(pageId, params) { ... }
// Ao adicionar nova página, inserir em PAGE_META e no bloco de if(pageId===...)
```

---

## Módulo SKU Clientes — Detalhes Técnicos

### Bug crítico resolvido
`_skuPerPage` retornava `undefined` dentro de `renderSkuList` por conflito de escopo.
**Solução:** hardcodar `var _PER = 20;` dentro da função.

### Estrutura atual de `renderSkuList`
- Usa `display:flex` nas linhas (não grid)
- Chama `renderSkuList()` diretamente no `initSkuClientesList` (sem setTimeout)
- Filtros: `sku-busca`, `sku-filtro-forn` (select), `sku-fil-cli-id` (hidden input), `sku-forma-filtro` (hidden input)

### Filtro Rede/Cliente (lateral)
Igual ao padrão Consulta de Preço:
- Toggle **Rede | Cliente** com visual de checkmark
- Rede → busca em `getCatClientes()` → `skuFilFiltrarRede()` / `_skuFilSelRede(i)`
- Cliente → busca em `getClientes()` → `skuFilFiltrarCli()` / `_skuFilSelCli(i)`
- ID selecionado salvo em `#sku-fil-cli-id`
- Funções: `skuFilSetTipo(tipo)`, `skuFilFiltrarRede(q)`, `skuFilFiltrarCli(q)`

### Forma de Compra (sidebar)
Grid 2 colunas: Todas (full-width) / KG CX / UN PC
Função: `skuSetForma(v)` — atualiza `#sku-forma-filtro` e chips `.pg-chip.on`

### Campos do formulário SKU
- `sku-forn-input` / `sku-forn-id` — fornecedor (autocomplete com código)
- `sku-cli-input` / `sku-cli-id` — rede ou cliente
- `sku-prod-input` / `sku-prod-id` — produto (mínimo 4 chars para filtrar)
- `sku-codigo` — o SKU do cliente
- `sku-forma-val` — CX / UND / PC / KG
- `sku-edit-id` — ID para edição

---

## Catálogo (Viewer PDF)
- PDF.js 3.11.174 do CDN
- Dois canvas lado a lado: `cartilha-canvas-left` e `cartilha-canvas-right`
- Animação de virada de página (flip 3D)
- **Bug corrigido:** canvas têm `display:block` para eliminar gap de descender (linhas brancas)

---

## Validação JS
```bash
# Extrair JS e validar sintaxe
python3 -c "
filepath = '/sessions/.../mnt/Sistema Pontti/index.html'
with open(filepath, 'r', encoding='utf-8') as f: lines = f.readlines()
s=e=None
for i in range(len(lines)-1,-1,-1):
    if '</script>' in lines[i] and e is None: e=i
    elif '<script>' in lines[i] and s is None and e is not None: s=i; break
open('/tmp/chk.js','w').write(''.join(lines[s+1:e]))
"
node --check /tmp/chk.js
```

---

## Como modificar o index.html
```python
filepath = "/sessions/.../mnt/Sistema Pontti/index.html"
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# fazer substituições
content = content.replace(OLD, NEW, 1)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)
```
**Sempre verificar `if OLD not in content` antes de substituir.**

---

## CSS Classes Reutilizáveis
```css
.pg-two-col   → grid 230px + 1fr
.pg-side      → sidebar escura sticky
.pg-side-sec  → seção da sidebar (padding + border-bottom)
.pg-side-lbl  → label da seção (9px uppercase)
.pg-side-srch → campo de busca na sidebar
.pg-side-sel  → select estilizado na sidebar
.pg-chip      → botão chip de filtro
.pg-chip.on   → chip selecionado (laranja)
.pg-chip-col  → coluna de chips
.pg-stat-row  → linha de estatística KPI
.app-page     → display:none por padrão (showPage controla)
```

---

## Itens Pendentes / Possíveis Melhorias
- Edição de SKU pelo formulário (função `openSkuClientesForm` com params.id já existe)
- Validação de duplicata de SKU (mesmo fornecedor + cliente + produto)
- Exportação de dados para Excel/PDF
- Relatórios e dashboards por módulo
