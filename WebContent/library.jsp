<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.library.Book" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    String msg = (String) request.getAttribute("msg");
    String keyword = (String) request.getAttribute("keyword");
    Boolean searchMode = (Boolean) request.getAttribute("searchMode");
    if (searchMode == null) searchMode = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Library XML-JSP | Book Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0f0e17;
            --surface: #1a1828;
            --surface2: #22203a;
            --accent: #7c5cbf;
            --accent2: #56cfb2;
            --accent3: #f7b731;
            --danger: #e05c65;
            --text: #fffffe;
            --text-muted: #a7a9be;
            --border: rgba(255,255,255,0.08);
            --radius: 12px;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── NAV ── */
        nav {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem; height: 64px;
            background: rgba(26,24,40,0.9);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { display: flex; align-items: center; gap: .6rem; font-weight: 700; font-size: 1.1rem; }
        .nav-brand .icon { font-size: 1.4rem; }
        .nav-badge { background: var(--accent); color: #fff; font-size: .65rem; padding: 2px 8px; border-radius: 20px; font-weight: 600; letter-spacing: .5px; }
        .nav-actions { display: flex; gap: .75rem; align-items: center; }

        /* ── BUTTONS ── */
        .btn {
            display: inline-flex; align-items: center; gap: .4rem;
            padding: .5rem 1.1rem; border-radius: 8px; font-size: .85rem;
            font-weight: 600; cursor: pointer; border: none; transition: all .2s;
            text-decoration: none; font-family: inherit;
        }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: #9270d8; transform: translateY(-1px); box-shadow: 0 4px 16px rgba(124,92,191,.4); }
        .btn-danger { background: transparent; color: var(--danger); border: 1px solid var(--danger); font-size: .78rem; padding: .3rem .7rem; }
        .btn-danger:hover { background: var(--danger); color: #fff; }
        .btn-outline { background: transparent; color: var(--text-muted); border: 1px solid var(--border); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }

        /* ── HERO ── */
        .hero {
            background: linear-gradient(135deg, #1a1428 0%, #0d1b2a 60%, #0f0e17 100%);
            padding: 3rem 2rem 2rem;
            position: relative; overflow: hidden;
        }
        .hero::before {
            content: ''; position: absolute; top: -60px; right: -60px;
            width: 300px; height: 300px; border-radius: 50%;
            background: radial-gradient(circle, rgba(124,92,191,.25) 0%, transparent 70%);
        }
        .hero-inner { max-width: 1100px; margin: 0 auto; }
        .hero h1 { font-size: 1.8rem; font-weight: 700; margin-bottom: .4rem; }
        .hero h1 span { color: var(--accent2); }
        .hero p { color: var(--text-muted); font-size: .95rem; }

        /* ── STATS ── */
        .stats { display: flex; gap: 1rem; margin-top: 1.5rem; flex-wrap: wrap; }
        .stat {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: .9rem 1.4rem;
            display: flex; align-items: center; gap: .75rem; min-width: 140px;
        }
        .stat-icon { font-size: 1.5rem; }
        .stat-val { font-size: 1.4rem; font-weight: 700; line-height: 1; }
        .stat-label { font-size: .75rem; color: var(--text-muted); margin-top: 2px; }

        /* ── MAIN ── */
        .main { max-width: 1100px; margin: 2rem auto; padding: 0 2rem 4rem; }

        /* ── TOOLBAR ── */
        .toolbar {
            display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        .search-box {
            flex: 1; display: flex; align-items: center;
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 8px; overflow: hidden; min-width: 200px;
        }
        .search-box input {
            flex: 1; background: transparent; border: none; color: var(--text);
            padding: .65rem 1rem; font-family: inherit; font-size: .9rem; outline: none;
        }
        .search-box input::placeholder { color: var(--text-muted); }
        .search-box button {
            background: var(--accent); border: none; color: #fff; padding: .65rem 1rem;
            cursor: pointer; font-size: .85rem; font-weight: 600; transition: background .2s;
        }
        .search-box button:hover { background: #9270d8; }

        /* ── ALERT ── */
        .alert {
            padding: .75rem 1.2rem; border-radius: 8px; font-size: .88rem;
            margin-bottom: 1.2rem; display: flex; align-items: center; gap: .5rem;
        }
        .alert-success { background: rgba(86,207,178,.15); border: 1px solid rgba(86,207,178,.3); color: var(--accent2); }
        .alert-info    { background: rgba(124,92,191,.15); border: 1px solid rgba(124,92,191,.3); color: #c4a8ff; }

        /* ── TABLE CARD ── */
        .card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); overflow: hidden;
        }
        .card-header {
            padding: 1rem 1.5rem; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .card-header h2 { font-size: 1rem; font-weight: 600; }
        .count-badge {
            background: var(--surface2); color: var(--text-muted);
            font-size: .75rem; padding: 2px 10px; border-radius: 20px;
        }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: var(--surface2); }
        th {
            text-align: left; padding: .75rem 1rem; font-size: .78rem;
            font-weight: 600; color: var(--text-muted); letter-spacing: .5px; text-transform: uppercase;
        }
        td { padding: .85rem 1rem; font-size: .88rem; border-top: 1px solid var(--border); vertical-align: middle; }
        tr:hover td { background: rgba(255,255,255,.03); }

        .id-badge {
            background: var(--surface2); color: var(--accent); font-weight: 700;
            font-size: .8rem; padding: 2px 8px; border-radius: 6px;
        }
        .title-cell { font-weight: 600; }
        .author-cell { color: var(--text-muted); }
        .isbn-cell { font-size: .78rem; color: var(--accent2); font-family: monospace; }
        .cat-badge {
            display: inline-block; padding: 3px 10px; border-radius: 20px;
            font-size: .72rem; font-weight: 600; letter-spacing: .3px;
        }
        .cat-Technology { background: rgba(124,92,191,.2); color: #c4a8ff; }
        .cat-Engineering { background: rgba(247,183,49,.15); color: #f7b731; }
        .cat-Science { background: rgba(86,207,178,.15); color: var(--accent2); }
        .cat-Fiction { background: rgba(224,92,101,.15); color: #ff8a92; }
        .qty-cell { font-weight: 600; }
        .price-cell { color: var(--accent3); font-weight: 600; }
        .empty-row td { text-align: center; padding: 3rem; color: var(--text-muted); }

        /* ── XML TAG ── */
        .xml-tag { font-family: monospace; font-size: .75rem; color: var(--text-muted); margin-top: .2rem; }

        /* ── FOOTER ── */
        .footer { text-align: center; color: var(--text-muted); font-size: .8rem; padding: 2rem; }
        .footer span { color: var(--accent); }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <div class="nav-brand">
        <span class="icon">📚</span>
        Library XML-JSP
        <span class="nav-badge">XML + Servlet</span>
    </div>
    <div class="nav-actions">
        <a href="<%= request.getContextPath() %>/library?action=list" class="btn btn-outline">📋 All Books</a>
        <a href="<%= request.getContextPath() %>/library?action=add"  class="btn btn-primary">+ Add Book</a>
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="hero-inner">
        <h1>📖 Library Book <span>XML Management</span></h1>
        <p>Data stored in <code>books.xml</code> — parsed with Java DOM Parser &amp; rendered via JSP</p>

        <div class="stats">
            <div class="stat">
                <span class="stat-icon">📚</span>
                <div>
                    <div class="stat-val"><%= books != null ? books.size() : 0 %></div>
                    <div class="stat-label"><%= searchMode ? "Search Results" : "Total Books" %></div>
                </div>
            </div>
            <div class="stat">
                <span class="stat-icon">🗂️</span>
                <div>
                    <div class="stat-val">XML</div>
                    <div class="stat-label">Data Storage</div>
                </div>
            </div>
            <div class="stat">
                <span class="stat-icon">⚙️</span>
                <div>
                    <div class="stat-val">DOM</div>
                    <div class="stat-label">XML Parser</div>
                </div>
            </div>
            <div class="stat">
                <span class="stat-icon">🌐</span>
                <div>
                    <div class="stat-val">JSP</div>
                    <div class="stat-label">View Layer</div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MAIN -->
<div class="main">

    <% if ("added".equals(msg)) { %>
    <div class="alert alert-success">✅ Book added successfully to <code>books.xml</code>!</div>
    <% } else if ("deleted".equals(msg)) { %>
    <div class="alert alert-success">🗑️ Book deleted from <code>books.xml</code> successfully!</div>
    <% } %>

    <% if (searchMode && keyword != null) { %>
    <div class="alert alert-info">🔍 Showing results for: <strong>"<%= keyword %>"</strong>
        — <a href="<%= request.getContextPath() %>/library" style="color:inherit;">Clear search</a></div>
    <% } %>

    <!-- TOOLBAR -->
    <div class="toolbar">
        <form method="get" action="<%= request.getContextPath() %>/library" class="search-box">
            <input type="hidden" name="action" value="search"/>
            <input type="text" name="keyword" placeholder="Search by title, author, or category..."
                   value="<%= keyword != null ? keyword : "" %>"/>
            <button type="submit">🔍 Search</button>
        </form>
        <a href="<%= request.getContextPath() %>/library?action=add" class="btn btn-primary">+ Add Book</a>
    </div>

    <!-- TABLE -->
    <div class="card">
        <div class="card-header">
            <h2>📋 Books Library</h2>
            <span class="count-badge"><%= books != null ? books.size() : 0 %> books</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>ISBN</th>
                    <th>Category</th>
                    <th>Qty</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (books == null || books.isEmpty()) { %>
                <tr class="empty-row"><td colspan="8">📭 No books found.</td></tr>
                <% } else {
                    for (Book b : books) {
                        String catClass = "cat-" + b.getCategory().replace(" ", "");
                %>
                <tr>
                    <td><span class="id-badge"><%= b.getId() %></span></td>
                    <td class="title-cell">
                        <%= b.getTitle() %>
                        <div class="xml-tag">&lt;title&gt;</div>
                    </td>
                    <td class="author-cell"><%= b.getAuthor() %></td>
                    <td class="isbn-cell"><%= b.getIsbn() %></td>
                    <td><span class="cat-badge <%= catClass %>"><%= b.getCategory() %></span></td>
                    <td class="qty-cell"><%= b.getQuantity() %></td>
                    <td class="price-cell">$<%= String.format("%.2f", b.getPrice()) %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/library?action=delete&id=<%= b.getId() %>"
                           class="btn btn-danger"
                           onclick="return confirm('Delete this book from XML?')">🗑 Delete</a>
                    </td>
                </tr>
                <% }} %>
            </tbody>
        </table>
    </div>
</div>

<div class="footer">
    Library XML-JSP &nbsp;|&nbsp; Data: <span>books.xml</span> &nbsp;|&nbsp; Parser: <span>Java DOM</span> &nbsp;|&nbsp; View: <span>JSP</span>
</div>

</body>
</html>
