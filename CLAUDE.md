# Sistema CompartilharNE — instruções para o Claude

Quem pede os ajustes normalmente **não é programador**. Responda sempre em português simples, sem jargão, e explique o que mudou em termos de tela e uso (onde clicar, o que deve aparecer).

## O que é o sistema

- Site estático publicado pelo **GitHub Pages** a partir da branch `main` (raiz):
  https://compartilharrepresentacoes.github.io/Sistema-CompartilharNE/
- Depois que algo entra na `main`, o site atualiza em 1 a 2 minutos (o usuário dá Ctrl+F5 para ver).
- Os dados ficam no **Supabase** (banco na nuvem). Não há servidor próprio nem etapa de build.

## Estrutura

- `index.html` — o sistema inteiro (HTML, CSS e JavaScript num arquivo só, ~36 mil linhas, ~2,7 MB). **Não leia o arquivo inteiro**: localize o trecho com busca (Grep) por nome da tela, id (`tab-clientes`, `tab-produtos`...) ou texto visível, e leia só a região necessária.
- `supabase.js` — biblioteca oficial do Supabase, minificada. **Não editar.**
- `catalogos/*.pdf` — catálogos dos fornecedores.
- Imagens de logo na raiz (`LOGO*`, `Logo*`, etc.).
- `atualizar_github.bat` — script antigo que envia tudo direto para a `main`. **Não usar** no fluxo com o Claude.

## Regra do `.gitignore` (importante)

O `.gitignore` funciona como **lista de liberação**: tudo é ignorado, menos o que estiver liberado com `!`. Arquivo novo (imagem, PDF, script) **não vai para o site** a menos que seja liberado lá. Ao criar um arquivo novo, avise o usuário e libere só o que for necessário.

## Fluxo obrigatório

1. **Antes de mexer**, confirme em uma frase o que entendeu do pedido. Se estiver ambíguo, pergunte.
2. **Uma mudança por vez.** Se o pedido tiver várias coisas, faça uma, confirme, depois a próxima.
3. Trabalhe sempre numa **branch própria** (ex.: `ajuste/filtro-fornecedor-pedidos`). **Nunca** commite nem dê push direto na `main`.
4. **Mudança visual** (cor, tamanho, posição, texto de tela, layout): mostre uma **prévia antes** de aplicar (descrição clara + trecho/imagem de como vai ficar) e só aplique quando o usuário responder **"aplicar"**.
5. Depois de fazer, explique **como testar**: qual tela abrir, o que clicar, o que deve aparecer.
6. Só faça o **commit** depois que o usuário confirmar que está certo.
7. Só abra o **PR** quando o usuário pedir ("abre o PR"). No PR, descreva em português simples o que mudou e como testar. Lembre o usuário de avisar o **Marcos** para aprovar.

## Regras

- Mexa só no necessário para o pedido. Não reorganize, renomeie ou "melhore" código que não foi pedido.
- **Nunca** apague ou altere dados no Supabase (tabelas, registros, políticas) sem pedido explícito e confirmação.
- Não exponha chaves ou senhas em mensagens, commits ou PRs.
- Mensagens de commit em português, no padrão do histórico: `Tela: o que mudou` (ex.: `Relatorios: filtro Fornecedor aceita o codigo da fabrica`).
- Valores em dinheiro e quantidades: cuidado com arredondamento (já houve bug de `44.800000000000004`).
- Se algo der erro ou você não tiver certeza, diga isso claramente em vez de supor que funcionou.
