import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'urlBase.dart';
//import 'package:dio/dio.dart';

class ApiService {
  
  final String baseUrl = ApiUrlPage.baseUrl;
  
  // Stockage sécurisé pour le token
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // ======================== Inscription ========================
Future<http.Response> register(Map<String, String> data) async {
  final url = Uri.parse('$baseUrl/api/auth/register/');
  final body = jsonEncode(data); // encode directement le map en JSON

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  return response; 
}



  // ======================== Connexion ========================
  Future<bool> login(Map<String,dynamic> data) async {

    final url = Uri.parse('$baseUrl/api/auth/token/');
    final body = jsonEncode(data);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    final responseBody = response.body;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(responseBody);

      // Stocker access token
      if (data.containsKey('access')) {
        await storage.write(key: 'access_token', value: data['access']);
      }

      // Stocker refresh token
      if (data.containsKey('refresh')) {
        await storage.write(key: 'refresh_token', value: data['refresh']);
      }

      return true;
    } else {
      print("Erreur login: $responseBody");
      return false;
    }
  }

   /// ================= Recuperer lid du user=================
  Future<String?> getUserId() async {
    // Récupère l'ID stocké si login a déjà été fait
    String? userId = await storage.read(key: 'user_id');

    if (userId != null) {
      return userId;
    }

    // Sinon, essaie de décoder le token pour obtenir l'ID
    String? token = await storage.read(key: 'access_token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['user_id']?.toString();
    }

    // Pas de token ou token expiré
    return null;
  }


  // ======================== Déconnexion ========================
 Future<void> logout() async {
  try {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
    await storage.delete(key: 'user_id');
  } catch (e) {
    // Tu peux logger ou gérer l'erreur ici
    print('Erreur lors de la déconnexion: $e');
  } finally {
    // Cache le modal même en cas d'erreur
    Get.offAllNamed('/login');
  }
}


  // ======================== Vérifier si token valide ========================
  Future<bool> isAccessTokenValid() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

    // ======================== Recupere le token ou refrachir  ========================
  Future<String?> getAccessToken() async {
  var token = await storage.read(key: 'access_token');

  // Si pas de token → essai refresh
  if (token == null) {
    final refreshed = await refreshAccessToken();
    if (!refreshed) return null;
    token = await storage.read(key: 'access_token');
  }

  return token;
}


  // ======================== Rafraîchir token ========================
Future<bool> refreshAccessToken() async {
  final refreshToken = await storage.read(key: 'refresh_token');
  if (refreshToken == null) return false;

  final url = Uri.parse('$baseUrl/api/auth/token/refresh/');
  final body = jsonEncode({"refresh": refreshToken});

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  final responseBody = response.body;

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final data = jsonDecode(responseBody);
    if (data.containsKey('access')) {
      await storage.write(key: 'access_token', value: data['access']);
      return true;
    }
  }
  return false;
}


Future<Map<String, dynamic>> getProfile() async {
  final token = await getAccessToken();
  if (token == null) return {};

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/profile/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", 
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('Erreur serveur : ${response.statusCode}');
      return {};
    }
  } catch (e) {
    print('Erreur lors de la récupération du profil : $e');
    return {};
  }
}



Future<bool> updateProfil(Map<String, dynamic> data) async {
  // Récupération du token
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    // Requête POST pour mettre à jour le profil
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/update_infos/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data), 
    );

    // Vérification de la réponse HTTP
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = jsonDecode(response.body);
      print('Réponse serveur: $responseData');
      return true;
    } else {
      print('Erreur HTTP: ${response.statusCode}');
      print('Message: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exception: $e');
    return false;
  }
}



// ======================== Mettre à jour son pseudo name ========================
Future<bool> updateSpeudoName(String name) async {
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/update_pseudo/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "pseudo": name, 
      }),
    );

    if (response.statusCode == 200) {
      print("Pseudo mis à jour avec succès !");
      return true;
    } else {
      print('Erreur serveur : ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Erreur lors de la mise à jour du pseudo : $e');
    return false;
  }
}





// ======================== Mettre à jour son pseudo name ========================
Future<List<Map<String, dynamic>>?> getMagasin() async {
  final token = await getAccessToken();
  if (token == null) return null;

  try {
    final uri = Uri.parse('$baseUrl/api/magasin/list/');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final magasins = data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      print("Magasins récupérés : $magasins");
      return magasins;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération des magasins : $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>?> getProduits() async {
  final token = await getAccessToken();
  if (token == null) return null;
  try {
    final uri = Uri.parse('$baseUrl/api/produit/list/');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final magasins = data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      print("Magasins récupérés : $magasins");
      return magasins;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération des magasins : $e');
    return null;
  }
}


// ======================== Détail d'un produit ========================
Future<Map<String, dynamic>?> getProduitDetail(String id) async {
  final token = await getAccessToken();
  if (token == null) return null;

  try {
    final uri = Uri.parse('$baseUrl/api/produit/$id/retreive/');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print("Détails du produit récupérés : $data");
      return data;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération du détail produit : $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>?> getmouvements() async {
  final token = await getAccessToken();
  if (token == null) return null;
  try {
    final uri = Uri.parse('$baseUrl/api/mouvement/list/');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final magasins = data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      print("Mouvements récupérés : $magasins");
      return magasins;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération des mouvements: $e');
    return null;
  }
}



Future<List<Map<String, dynamic>>?> getStocks() async {
  final token = await getAccessToken();
  if (token == null) return null;
  try {
    final uri = Uri.parse('$baseUrl/api/stock/list/');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final magasins = data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      print("Produits récupérés : $magasins");
      return magasins;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération des mouvements: $e');
    return null;
  }
}



Future<Map<String, dynamic>?> getStocksDetails(String productId) async {
  final token = await getAccessToken();
  if (token == null) return null;

  try {
    // ⚡ Utilisation de l'URL de détail avec l'ID du produit
    final uri = Uri.parse('$baseUrl/api/produit/$productId/detail/');

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      // On décode la réponse qui est un objet Map pour un détail produit
      final Map<String, dynamic> data = json.decode(response.body);
      
      print("Détails du produit récupérés : $data");
      return data;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération des détails du produit: $e');
    return null;
  }
}


Future<bool> createMouvement(Map<String, dynamic> mouvementData) async {
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    final uri = Uri.parse('$baseUrl/api/mouvement/create/');

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(mouvementData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Mouvement créé avec succès : ${response.body}');
      return true;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erreur lors de la création du mouvement: $e');
    return false;
  }
}


/// updateMouvement prend l'id du mouvement et les données à mettre à jour
Future<bool> updateMouvement(String idMouvement, Map<String, dynamic> mouvementData) async {
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    // URL corrigée avec http et id dynamique
    final uri = Uri.parse('$baseUrl/api/mouvement/$idMouvement/update/');

    final response = await http.put(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(mouvementData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Mouvement mis à jour avec succès : ${response.body}');
      return true;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erreur lors de la mise à jour du mouvement: $e');
    return false;
  }
}


/// updateMouvement prend l'id du mouvement et les données à mettre à jour
Future<bool> createCommande(Map<String, dynamic> commandeData) async {
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    // URL pour la création d'une nouvelle commande
    final uri = Uri.parse('$baseUrl/api/commandes/create/'); 

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(commandeData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Commande créée avec succès : ${response.body}');
      return true;
    } else {
      print('Erreur serveur : ${response.statusCode} => ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erreur lors de la création de la commande: $e');
    return false;
  }
}


Future<bool> updateCommande(String idCommande, Map<String, dynamic> commandeData) async {
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    final uri = Uri.parse('$baseUrl/api/commandes/$idCommande/update/'); 

    final response = await http.put( 
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(commandeData),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Commande mise à jour avec succès');
      return true;
    } else {
      print('Erreur update : ${response.statusCode} => ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erreur lors de la mise à jour: $e');
    return false;
  }
}

Future<List<dynamic>?> fetchCommandes() async {
  final token = await getAccessToken();
  if (token == null) return null;

  try {
    // URL pour récupérer la liste des commandes de l'utilisateur
    final uri = Uri.parse('$baseUrl/api/commandes/list'); 

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Erreur serveur : ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return null;
  }
}

Future<Map<String, dynamic>?> fetchCommandeDetail(String idCommande) async {
  final token = await getAccessToken();
  if (token == null) return null;

  try {

    final uri = Uri.parse('$baseUrl/api/commandes/${idCommande}/retrieve/'); 
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      // On décode l'objet unique (Map)
      print("cool details comande");
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('Erreur serveur : ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur lors de la récupération : $e');
    return null;
  }
}

// Future<Map<String, dynamic>?> fetchCommandeDetail(String idCommande) async {
//   final token = await getAccessToken();
//   if (token == null) return null;

//   final dio = Dio(
//     BaseOptions(
//       baseUrl: baseUrl,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   );

//   try {
//     final response = await dio.get(
//       '/api/commandes/$idCommande/retrieve/',
//     );

//     if (response.statusCode == 200) {
//       // Dio décode déjà le JSON
//       return response.data as Map<String, dynamic>;
//     } else {
//       print('Erreur serveur : ${response.statusCode}');
//       return null;
//     }
//   } on DioException catch (e) {
//     print('Erreur Dio : ${e.response?.statusCode}');
//     print('Message : ${e.message}');
//     return null;
//   } catch (e) {
//     print('Erreur inconnue : $e');
//     return null;
//   }
// }

Future<bool> cancelCommande(String idCommande) async {
  final token = await getAccessToken();
  if (token == null) return false;

  try {
    final uri = Uri.parse('$baseUrl/api/commandes/$idCommande/cancel/');

    final response = await http.post( 
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      print('Erreur annulation : ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Exception lors de l\'annulation : $e');
    return false;
  }
}


}


