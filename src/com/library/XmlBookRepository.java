package com.library;

import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;
import java.util.*;

public class XmlBookRepository {

    private final String xmlPath;

    public XmlBookRepository(String xmlPath) {
        this.xmlPath = xmlPath;
    }

    public List<Book> getAllBooks() throws Exception {
        List<Book> books = new ArrayList<>();
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(new File(xmlPath));
        doc.getDocumentElement().normalize();

        NodeList nodeList = doc.getElementsByTagName("book");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Node node = nodeList.item(i);
            if (node.getNodeType() == Node.ELEMENT_NODE) {
                Element el = (Element) node;
                Book book = new Book();
                book.setId(Integer.parseInt(getText(el, "id")));
                book.setTitle(getText(el, "title"));
                book.setAuthor(getText(el, "author"));
                book.setIsbn(getText(el, "isbn"));
                book.setCategory(getText(el, "category"));
                book.setQuantity(Integer.parseInt(getText(el, "quantity")));
                book.setPrice(Double.parseDouble(getText(el, "price")));
                books.add(book);
            }
        }
        return books;
    }

    public List<Book> searchBooks(String keyword) throws Exception {
        List<Book> all = getAllBooks();
        List<Book> result = new ArrayList<>();
        String kw = keyword.toLowerCase();
        for (Book b : all) {
            if (b.getTitle().toLowerCase().contains(kw)
                    || b.getAuthor().toLowerCase().contains(kw)
                    || b.getCategory().toLowerCase().contains(kw)) {
                result.add(b);
            }
        }
        return result;
    }

    public void addBook(Book book) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(new File(xmlPath));
        doc.getDocumentElement().normalize();

        // determine next id
        NodeList nodeList = doc.getElementsByTagName("book");
        int maxId = 0;
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element el = (Element) nodeList.item(i);
            int id = Integer.parseInt(getText(el, "id"));
            if (id > maxId) maxId = id;
        }
        book.setId(maxId + 1);

        Element newBook = doc.createElement("book");
        appendChild(doc, newBook, "id", String.valueOf(book.getId()));
        appendChild(doc, newBook, "title", book.getTitle());
        appendChild(doc, newBook, "author", book.getAuthor());
        appendChild(doc, newBook, "isbn", book.getIsbn());
        appendChild(doc, newBook, "category", book.getCategory());
        appendChild(doc, newBook, "quantity", String.valueOf(book.getQuantity()));
        appendChild(doc, newBook, "price", String.valueOf(book.getPrice()));

        doc.getDocumentElement().appendChild(newBook);
        saveDoc(doc);
    }

    public void deleteBook(int id) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(new File(xmlPath));
        doc.getDocumentElement().normalize();

        NodeList nodeList = doc.getElementsByTagName("book");
        for (int i = 0; i < nodeList.getLength(); i++) {
            Element el = (Element) nodeList.item(i);
            if (Integer.parseInt(getText(el, "id")) == id) {
                doc.getDocumentElement().removeChild(el);
                break;
            }
        }
        saveDoc(doc);
    }

    private void saveDoc(Document doc) throws Exception {
        javax.xml.transform.TransformerFactory tf = javax.xml.transform.TransformerFactory.newInstance();
        javax.xml.transform.Transformer transformer = tf.newTransformer();
        transformer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT, "yes");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        javax.xml.transform.dom.DOMSource source = new javax.xml.transform.dom.DOMSource(doc);
        javax.xml.transform.stream.StreamResult result =
                new javax.xml.transform.stream.StreamResult(new File(xmlPath));
        transformer.transform(source, result);
    }

    private String getText(Element el, String tag) {
        NodeList nl = el.getElementsByTagName(tag);
        if (nl.getLength() > 0 && nl.item(0).getChildNodes().getLength() > 0) {
            return nl.item(0).getChildNodes().item(0).getNodeValue().trim();
        }
        return "";
    }

    private void appendChild(Document doc, Element parent, String tag, String value) {
        Element el = doc.createElement(tag);
        el.appendChild(doc.createTextNode(value));
        parent.appendChild(el);
    }
}
