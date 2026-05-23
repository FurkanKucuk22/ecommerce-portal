package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
  private ProductDAO productDAO;

  @Override
  public void init() throws ServletException {
    productDAO = new ProductDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String idParam = request.getParameter("id");

    if (idParam != null && !idParam.isEmpty()) {
      try {
        int id = Integer.parseInt(idParam);
        Product product = productDAO.getProductById(id);

        if (product != null) {
          // Ürün bulunduysa sayfaya gönder
          request.setAttribute("product", product);
          request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
          return;
        }
      } catch (NumberFormatException e) {
        // ID sayı değilse hatayı yut ve ana sayfaya at
      }
    }

    // Ürün bulunamazsa veya ID yoksa ana sayfaya yönlendir
    response.sendRedirect(request.getContextPath() + "/home");
  }
}