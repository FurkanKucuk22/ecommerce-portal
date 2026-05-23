package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Category;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({ "", "/home" })
public class HomeServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        // Servlet ilk çalıştığında DAO nesnelerimizi oluşturuyoruz
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kategorileri çek ve sol menüde listelenmesi için request'e ekle
        List<Category> categoryList = categoryDAO.getAllActiveCategories();
        request.setAttribute("categoryList", categoryList);

        String categoryIdParam = request.getParameter("categoryId");
        String searchQuery = request.getParameter("search");
        List<Product> productList;

        // EĞER ARAMA KUTUSU DOLDURULMUŞSA
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            productList = productDAO.searchProducts(searchQuery);
            request.setAttribute("searchQuery", searchQuery);
        }
        // EĞER BİR KATEGORİ SEÇİLMİŞSE
        else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdParam);
                productList = productDAO.getProductsByCategory(categoryId);
                request.setAttribute("selectedCategoryId", categoryId);
            } catch (NumberFormatException e) {
                productList = productDAO.getAllActiveProducts();
            }
        }
        // HİÇBİR ŞEY SEÇİLMEDİYSE -> SAYFALAMA (PAGINATION) YAP
        else {
            int page = 1; // Varsayılan sayfa numarası
            int recordsPerPage = 6; // Her sayfada gösterilecek ürün sayısı

            // Kullanıcı alt taraftaki sayfa numaralarına tıkladıysa o numarayı al
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            // Hangi kayıttan başlayacağını hesapla (Örn: 2. sayfa için (2-1)*6 = 6. sıradan
            // başla)
            int start = (page - 1) * recordsPerPage;

            // Veritabanından sadece o sayfanın ürünlerini çek
            productList = productDAO.getPaginatedProducts(start, recordsPerPage);

            // Toplam sayfa sayısını hesapla
            int totalRecords = productDAO.getTotalProductCount();
            int noOfPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            // Sayfalama verilerini JSP'ye yolla
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", page);
        }

        request.setAttribute("products", productList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}