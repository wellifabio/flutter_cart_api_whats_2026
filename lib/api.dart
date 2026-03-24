class Api {
  static const String baseUrl =
      'https://raw.githubusercontent.com/wellifabio/senai2025/refs/heads/main/assets/mockups';

  static String getUsuarios() {
    return '$baseUrl/usuarios.json';
  }

  static String getProdutos() {
    return '$baseUrl/produtos.json';
  }
}
