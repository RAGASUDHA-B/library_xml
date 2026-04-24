<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Add Book | Library XML-JSP</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0f0e17; --surface: #1a1828; --surface2: #22203a;
            --accent: #7c5cbf; --accent2: #56cfb2; --accent3: #f7b731;
            --text: #fffffe; --text-muted: #a7a9be; --border: rgba(255,255,255,0.08); --radius: 12px;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }
        nav {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 2rem; height: 64px;
            background: rgba(26,24,40,0.9); backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 100;
        }
        .nav-brand { display: flex; align-items: center; gap: .6rem; font-weight: 700; font-size: 1.1rem; }
        .nav-badge { background: var(--accent); color: #fff; font-size: .65rem; padding: 2px 8px; border-radius: 20px; font-weight: 600; }
        .btn {
            display: inline-flex; align-items: center; gap: .4rem;
            padding: .5rem 1.1rem; border-radius: 8px; font-size: .85rem;
            font-weight: 600; cursor: pointer; border: none; transition: all .2s;
            text-decoration: none; font-family: inherit;
        }
        .btn-outline { background: transparent; color: var(--text-muted); border: 1px solid var(--border); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }

        .page { max-width: 620px; margin: 3rem auto; padding: 0 1.5rem 4rem; }
        .page-title { font-size: 1.5rem; font-weight: 700; margin-bottom: .4rem; }
        .page-sub { color: var(--text-muted); font-size: .9rem; margin-bottom: 2rem; }

        .form-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 2rem;
        }
        .form-group { margin-bottom: 1.3rem; }
        label { display: block; font-size: .82rem; font-weight: 600; color: var(--text-muted); margin-bottom: .4rem; letter-spacing: .3px; }
        label .xml-hint { font-weight: 400; color: var(--accent2); font-family: monospace; margin-left: .4rem; }
        input, select {
            width: 100%; background: var(--surface2); border: 1px solid var(--border);
            border-radius: 8px; color: var(--text); padding: .65rem 1rem;
            font-family: inherit; font-size: .9rem; outline: none; transition: border .2s;
        }
        input:focus, select:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(124,92,191,.15); }
        input::placeholder { color: var(--text-muted); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .form-actions { display: flex; gap: 1rem; margin-top: 1.5rem; }
        .btn-submit {
            flex: 1; background: var(--accent); color: #fff; padding: .75rem;
            border: none; border-radius: 8px; font-size: .95rem; font-weight: 600;
            cursor: pointer; transition: all .2s; font-family: inherit;
        }
        .btn-submit:hover { background: #9270d8; transform: translateY(-1px); box-shadow: 0 4px 16px rgba(124,92,191,.4); }
        .btn-cancel {
            background: transparent; color: var(--text-muted); border: 1px solid var(--border);
            border-radius: 8px; padding: .75rem 1.5rem; font-family: inherit; font-size: .9rem;
            cursor: pointer; text-decoration: none; display: flex; align-items: center;
        }
        .btn-cancel:hover { border-color: var(--text-muted); }

        select option { background: #1a1828; }
    </style>
</head>
<body>
<nav>
    <div class="nav-brand">
        <span>📚</span> Library XML-JSP
        <span class="nav-badge">XML + Servlet</span>
    </div>
    <a href="<%= request.getContextPath() %>/library" class="btn btn-outline">← Back to Library</a>
</nav>

<div class="page">
    <div class="page-title">➕ Add New Book</div>
    <div class="page-sub">Book will be saved as a new <code>&lt;book&gt;</code> element in <code>books.xml</code></div>

    <div class="form-card">
        <form method="post" action="<%= request.getContextPath() %>/library">
            <input type="hidden" name="action" value="add"/>

            <div class="form-group">
                <label>Book Title <span class="xml-hint">&lt;title&gt;</span></label>
                <input type="text" name="title" placeholder="e.g. Introduction to Java" required/>
            </div>

            <div class="form-group">
                <label>Author <span class="xml-hint">&lt;author&gt;</span></label>
                <input type="text" name="author" placeholder="e.g. James Gosling" required/>
            </div>

            <div class="form-group">
                <label>ISBN <span class="xml-hint">&lt;isbn&gt;</span></label>
                <input type="text" name="isbn" placeholder="e.g. 978-0-13-468599-1"/>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Category <span class="xml-hint">&lt;category&gt;</span></label>
                    <select name="category">
                        <option value="Technology">Technology</option>
                        <option value="Engineering">Engineering</option>
                        <option value="Science">Science</option>
                        <option value="Fiction">Fiction</option>
                        <option value="Non-Fiction">Non-Fiction</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Quantity <span class="xml-hint">&lt;quantity&gt;</span></label>
                    <input type="number" name="quantity" value="1" min="0" required/>
                </div>
            </div>

            <div class="form-group">
                <label>Price ($) <span class="xml-hint">&lt;price&gt;</span></label>
                <input type="number" name="price" step="0.01" value="9.99" min="0" required/>
            </div>

            <div class="form-actions">
                <a href="<%= request.getContextPath() %>/library" class="btn-cancel">Cancel</a>
                <button type="submit" class="btn-submit">✅ Save to XML</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
