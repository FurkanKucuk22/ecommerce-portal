package com.ecommerce.controller;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin-category")
public class AdminCategoryServlet extends HttpServlet {
  private CategoryDAO categoryDAO;

  @Override
  public void init() throws ServletException {
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
          deleteCategory(request, response);
          break;
        default:
          listCategories(request, response);
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
      insertCategory(request, response);
    } else if ("update".equals(action)) {
      updateCategory(request, response);
    }
  }

  // --- YARDIMCI METOTLAR ---

  private void listCategories(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    List<Category> listCategory = categoryDAO.getAllCategoriesForAdmin();
    request.setAttribute("listCategory", listCategory);
    request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
  }

  private void showNewForm(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
  }

  private void showEditForm(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    Category existingCategory = categoryDAO.getCategoryById(id);
    request.setAttribute("category", existingCategory);
    request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
  }

  private void insertCategory(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    boolean isActive = request.getParameter("isActive") != null;

    // --- SUNUCU TARAFLI FORM DOĞRULAMA (SERVER-SIDE VALIDATION) ---
    if (name == null || name.trim().isEmpty()) {
      request.setAttribute("errorMessage", "Kategori adı boş bırakılamaz!");
      request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
      return;
    }

    Category newCategory = new Category();
    newCategory.setName(name);
    newCategory.setDescription(description);
    newCategory.setActive(isActive);

    categoryDAO.addCategory(newCategory);
    response.sendRedirect("admin-category?action=list");
  }

  private void updateCategory(HttpServletRequest request, HttpServletResponse response)
      throws IOException, ServletException {
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    boolean isActive = request.getParameter("isActive") != null;

    // --- SUNUCU TARAFLI FORM DOĞRULAMA (SERVER-SIDE VALIDATION) ---
    if (name == null || name.trim().isEmpty()) {
      request.setAttribute("errorMessage", "Kategori adı boş bırakılamaz!");
      // Hata durumunda mevcut id'yi tekrar gönderip formun doğru açılmasını
      // sağlıyoruz
      Category category = new Category();
      category.setId(id);
      category.setName(name);
      category.setDescription(description);
      category.setActive(isActive);
      request.setAttribute("category", category);
      request.getRequestDispatcher("/admin/category-form.jsp").forward(request, response);
      return;
    }

    Category category = new Category();
    category.setId(id);
    category.setName(name);
    category.setDescription(description);
    category.setActive(isActive);

    categoryDAO.updateCategory(category);
    response.sendRedirect("admin-category?action=list");
  }

  private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
      throws IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    categoryDAO.deleteCategory(id);
    response.sendRedirect("admin-category?action=list");
  }
}