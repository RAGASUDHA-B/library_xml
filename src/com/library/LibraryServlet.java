package com.library;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class LibraryServlet extends HttpServlet {

    private XmlBookRepository repo;

    @Override
    public void init() throws ServletException {
        // resolve xml path relative to webapp root
        String xmlPath = getServletContext().getRealPath("/books.xml");
        if (xmlPath == null) {
            // fallback: look in current dir
            xmlPath = new File("WebContent/books.xml").getAbsolutePath();
        }
        repo = new XmlBookRepository(xmlPath);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "search":
                    String kw = req.getParameter("keyword");
                    List<Book> results = repo.searchBooks(kw == null ? "" : kw);
                    req.setAttribute("books", results);
                    req.setAttribute("keyword", kw);
                    req.setAttribute("searchMode", true);
                    forward(req, resp, "/library.jsp");
                    break;
                case "delete":
                    int delId = Integer.parseInt(req.getParameter("id"));
                    repo.deleteBook(delId);
                    resp.sendRedirect(req.getContextPath() + "/library?action=list&msg=deleted");
                    break;
                case "add":
                    forward(req, resp, "/add_book.jsp");
                    break;
                default:
                    String msg = req.getParameter("msg");
                    List<Book> books = repo.getAllBooks();
                    req.setAttribute("books", books);
                    req.setAttribute("msg", msg);
                    forward(req, resp, "/library.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            try {
                Book book = new Book();
                book.setTitle(req.getParameter("title"));
                book.setAuthor(req.getParameter("author"));
                book.setIsbn(req.getParameter("isbn"));
                book.setCategory(req.getParameter("category"));
                book.setQuantity(Integer.parseInt(req.getParameter("quantity")));
                book.setPrice(Double.parseDouble(req.getParameter("price")));
                repo.addBook(book);
                resp.sendRedirect(req.getContextPath() + "/library?action=list&msg=added");
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String page)
            throws ServletException, IOException {
        req.getRequestDispatcher(page).forward(req, resp);
    }
}
