package com.ecommerce.controller;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
  private ProductDAO productDAO;

  @Override
  public void init() throws ServletException {
    productDAO = new ProductDAO();
  }

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    request.getRequestDispatcher("/cart.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String action = request.getParameter("action");
    int productId = Integer.parseInt(request.getParameter("productId"));

    HttpSession session = request.getSession();
    @SuppressWarnings("unchecked")
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    if (cart == null) {
      cart = new ArrayList<>();
    }

    // Stok kontrolü yapabilmek için ürünü veritabanından çekiyoruz
    Product product = productDAO.getProductById(productId);

    if ("add".equals(action)) {
      boolean exists = false;
      for (CartItem item : cart) {
        if (item.getProduct().getId() == productId) {
          // Mevcut adedin üzerine 1 eklerken stok aşılıyor mu kontrol et
          if (item.getQuantity() + 1 <= product.getStock()) {
            item.setQuantity(item.getQuantity() + 1);
          } else {
            request.setAttribute("errorMessage",
                "Stok yetersiz! Bu üründen en fazla " + product.getStock() + " adet alabilirsiniz.");
          }
          exists = true;
          break;
        }
      }
      if (!exists) {
        if (product.getStock() >= 1) {
          CartItem newItem = new CartItem();
          newItem.setProduct(product);
          newItem.setQuantity(1);
          cart.add(newItem);
        } else {
          request.setAttribute("errorMessage", "Maalesef bu ürün stokta kalmamıştır.");
        }
      }
    }
    // GÜNCELLEME İŞLEMİ
    else if ("update".equals(action)) {
      int newQuantity = Integer.parseInt(request.getParameter("quantity"));

      for (CartItem item : cart) {
        if (item.getProduct().getId() == productId) {
          if (newQuantity > product.getStock()) {
            // İstenen sayı stoktan büyükse hata ver
            request.setAttribute("errorMessage",
                "Stok yetersiz! Maksimum ekleyebileceğiniz adet: " + product.getStock());
          } else if (newQuantity <= 0) {
            // 0 veya eksi girilirse ürünü sepetten çıkar
            cart.remove(item);
          } else {
            // Her şey uygunsa adedi güncelle
            item.setQuantity(newQuantity);
          }
          break;
        }
      }
    } else if ("remove".equals(action)) {
      cart.removeIf(item -> item.getProduct().getId() == productId);
    }

    session.setAttribute("cart", cart);

    // Eğer bir stok hatası oluştuysa mesajla birlikte sepete dön, sorun yoksa
    // normal sayfaya dön
    if (request.getAttribute("errorMessage") != null) {
      request.getRequestDispatcher("/cart.jsp").forward(request, response);
    } else {
      response.sendRedirect(request.getContextPath() + "/cart");
    }
  }
}