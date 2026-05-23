package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.model.Product;
import com.ecommerce.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-product")
public class AdminProductServlet extends HttpServlet {
  private ProductDAO productDAO;
  private CategoryDAO categoryDAO;

  @Override
  public void init() throws ServletException {
    productDAO = new ProductDAO();
    categoryDAO = new CategoryDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    // GÜVENLİK KONTROLÜ
    HttpSession session = request.getSession();
    if (session.getAttribute("adminUser") == null) {
      response.sendRedirect(request.getContextPath() + "/admin-login");
      return;
    }

    String action = request.getParameter("action");
    if (action == null) {
      action = "list";
    }

    try {
      switch (action) {
        case "new":
          showNewForm(request, response);
          break;
        case "edit":
          showEditForm(request, response);
          break;
        case "delete":
          deleteProduct(request, response);
          break;
        default:
          listProducts(request, response);
          break;
      }
    } catch (Exception ex) {
      throw new ServletException(ex);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");

    if ("insert".equals(action)) {
      insertProduct(request, response);
    } else if ("update".equals(action)) {
      updateProduct(request, response);
    }
  }

  // --- YARDIMCI METOTLAR ---

  private void listProducts(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    List<Product> listProduct = productDAO.getAllProductsForAdmin();
    // Arayüzde kategori isimlerini kolayca eşleştirebilmek için kategorileri de
    // gönderiyoruz
    List<Category> listCategory = categoryDAO.getAllCategoriesForAdmin();

    request.setAttribute("listProduct", listProduct);
    request.setAttribute("listCategory", listCategory);
    request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
  }

  private void showNewForm(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    List<Category> listCategory = categoryDAO.getAllCategoriesForAdmin();
    request.setAttribute("listCategory", listCategory);
    request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
  }

  private void showEditForm(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    Product existingProduct = productDAO.getProductById(id);
    List<Category> listCategory = categoryDAO.getAllCategoriesForAdmin();

    request.setAttribute("product", existingProduct);
    request.setAttribute("listCategory", listCategory);
    request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
  }

  private void insertProduct(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String name = request.getParameter("name");
    String categoryIdStr = request.getParameter("categoryId");
    String description = request.getParameter("description");
    String priceStr = request.getParameter("price");
    String stockStr = request.getParameter("stock");
    String imageUrl = request.getParameter("imageUrl");
    boolean isActive = request.getParameter("isActive") != null;

    // SUNUCU TARAFINDAN FORM DOĞRULAMA (Madde 6.4 ve Madde 11 İsteri)
    if (name == null || name.trim().isEmpty() || categoryIdStr == null || priceStr == null || stockStr == null) {
      sendValidationError(request, response, "Lütfen tüm zorunlu alanları doldurun!", "new", null);
      return;
    }

    int categoryId = Integer.parseInt(categoryIdStr);
    double price = Double.parseDouble(priceStr);
    int stock = Integer.parseInt(stockStr);

    if (price <= 0) {
      sendValidationError(request, response, "Ürün fiyatı 0'dan büyük olmalıdır!", "new", null);
      return;
    }
    if (stock < 0) {
      sendValidationError(request, response, "Stok miktarı negatif olamaz!", "new", null);
      return;
    }
    if (categoryId <= 0) {
      sendValidationError(request, response, "Lütfen geçerli bir kategori seçin!", "new", null);
      return;
    }

    // Doğrulama başarılıysa nesneyi oluştur ve veritabanına kaydet
    Product newProduct = new Product();
    newProduct.setCategoryId(categoryId);
    newProduct.setName(name);
    newProduct.setDescription(description);
    newProduct.setPrice(price);
    newProduct.setStock(stock);
    newProduct.setImageUrl(imageUrl);
    newProduct.setActive(isActive);

    productDAO.addProduct(newProduct);
    response.sendRedirect("admin-product?action=list");
  }

  private void updateProduct(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    int stock = Integer.parseInt(request.getParameter("stock"));
    String imageUrl = request.getParameter("imageUrl");
    boolean isActive = request.getParameter("isActive") != null;

    // GÜNCELLEME İÇİN DE SUNUCU TARAFINDAN FORM DOĞRULAMA
    if (name == null || name.trim().isEmpty() || price <= 0 || stock < 0 || categoryId <= 0) {
      Product product = new Product(); // Hata durumunda form boş kalmasın diye geri dolduruyoruz
      product.setId(id);
      product.setName(name);
      product.setDescription(description);
      product.setPrice(price);
      product.setStock(stock);
      product.setImageUrl(imageUrl);
      product.setActive(isActive);

      sendValidationError(request, response, "Hatalı veya eksik veri girişi! Lütfen kriterleri kontrol edin.", "edit",
          product);
      return;
    }

    Product product = new Product();
    product.setId(id);
    product.setCategoryId(categoryId);
    product.setName(name);
    product.setDescription(description);
    product.setPrice(price);
    product.setStock(stock);
    product.setImageUrl(imageUrl);
    product.setActive(isActive);

    productDAO.updateProduct(product);
    response.sendRedirect("admin-product?action=list");
  }

  private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
      throws IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    productDAO.deleteProduct(id);
    response.sendRedirect("admin-product?action=list");
  }

  // Hata durumunda formu dolduran ve mesaj veren fonksiyon
  private void sendValidationError(HttpServletRequest request, HttpServletResponse response,
      String message, String formAction, Product product) throws ServletException, IOException {
    request.setAttribute("errorMessage", message);
    request.setAttribute("listCategory", categoryDAO.getAllCategoriesForAdmin());
    if (product != null) {
      request.setAttribute("product", product);
    }
    request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
  }
}