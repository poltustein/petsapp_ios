import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pwd_app/models/AddDogRequest.dart';
import 'package:pwd_app/models/AddDogResponse.dart';
import 'package:pwd_app/models/AddImage.dart';
import 'package:pwd_app/models/CategoriesResponse.dart';
import 'package:pwd_app/models/HomeResponse.dart';
import 'package:pwd_app/models/IssueResponse.dart';
import 'package:pwd_app/models/MyDogsResponse.dart';
import 'package:pwd_app/models/SaveVideoResponse.dart';
import 'package:pwd_app/models/SavedVideosResponse.dart';
import 'package:pwd_app/models/SubscriptionInit.dart';
import 'package:pwd_app/models/SubscriptionPlans.dart';
import 'package:pwd_app/models/SubscriptionResponse.dart';
import 'package:pwd_app/models/login/login.dart';
import 'package:pwd_app/models/otp_response.dart';
import 'package:pwd_app/models/signup_response.dart';
import 'package:path/path.dart' as p;

class WebService {
  Future<Login> loginUser(String email, String password, String loginMethod, String fullName, String imageUrl) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer J0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9sdkjdskjh'
    };

    Map<String, String> body = {"emailId": email, "password": password, "method": loginMethod, "fullName": fullName, "imageUrl": imageUrl};

    String url =
        "https://protectiondogs.club:443/petsProtection/prelogin/login/";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Login.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }


  Future<Login> forgotPassword(String email, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token
    };
    Map<String, String> body = {"emailId": email};

    String url =
        "https://protectiondogs.club:443/petsProtection/prelogin/forgotPassword";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Login.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<Login> changePassword(String email, String password, String otp ,String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token
    };
    Map<String, String> body = {"emailId": email, "password": password, "otp": otp};

    String url =
        "https://protectiondogs.club:443/petsProtection/prelogin/changePassword";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Login.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }




  Future<SignupResponse> signupUser(
      String name, String email, String phone, String password) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer J0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9sdkjdskjh'
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/prelogin/signup/";

    Map<String, String> body = {
      "emailId": email,
      "password": password,
      "fullName": name,
      "contactNumber": phone,
    };

    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SignupResponse.fromJson(json);
    } else {
      throw Exception("Error signing in user!");
    }
  }

  Future<SignupResponse> updateUser(
      String name, String email, String phone, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid': email
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/user/update";

    Map<String, String> body = {
      "emailId": email,
      "fullName": name,
      "contactNumber": phone,
    };

    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SignupResponse.fromJson(json);
    } else {
      throw Exception("Error signing in user!");
    }
  }

  Future<OtpResponse?> verifyOTP(String email, String otp) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer J0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9sdkjdskjh'
    };

    Map<String, String> body = {"emailId": email, "otp": otp};

    String url =
        "https://protectiondogs.club:443/petsProtection/prelogin/verifyOtp/";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OtpResponse.fromJson(json);
    } else {
      return null;
    }
  }

  Future<SubscriptionPlans> subscriptionPlans(String email, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer ' + token,
      'emailid': email
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/plans";
    final response = await http.get(Uri.parse(url),
         headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SubscriptionPlans.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<SubscriptionInit> createSubscription(String email, String singlePlanId, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer ' + token,
      'emailid': email
    };

    Map<String, String> body = {"singlePlanId": singlePlanId};
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/create/subscription";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SubscriptionInit.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<IssueResponse> support(String email, String issue, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    Map<String, String> body = {"issue": issue};
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/support";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return IssueResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<AddDogResponse> addDog(String email,AddDogRequest request, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/add/dog";
    final response = await http.post(Uri.parse(url),
        body: json.encode(request.toJson()), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return AddDogResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<AddImageResponse> addDogImage(String email,AddDogResponse dogResponse,  String token,PickedFile file) async {
    Map<String, String> requestHeaders = {
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/file/upload/dogimage/"+dogResponse!.dogId!;
    final request = await new http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(requestHeaders);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: new MediaType('image',p.extension(file.path)),
    ));

    final response = await request.send();
    final body = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final json = jsonDecode(body);
        return AddImageResponse.fromJson(json);
      } else {
        throw Exception("Error logging in user!");
      }
  }

  Future<MyDogsResponse> mydogs(String email, int pageSize, int pageIndex,  String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    Map<String, int> body = {"pageSize": pageSize, "pageIndex": pageIndex};
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/dogs";
    final  response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return MyDogsResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<AddImageResponse> addProfileImage(String email,String token,PickedFile file) async {
    Map<String, String> requestHeaders = {
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/file/upload/profileimage/"+email.split("@")[0];
    final request = await new http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll(requestHeaders);
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      file.path,
      contentType: new MediaType('image',p.extension(file.path)),
    ));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final json = jsonDecode(body);
      return AddImageResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }


  Future<HomeResponse> getHomeRequest(String email, String token, int pageSize, int pageIndex) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    Map<String, int> body = {"pageSize": pageSize, "pageIndex": pageIndex};
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/home";
    final  response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return HomeResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }


  Future<SaveVideoResponse> saveVideoRequest(String email, String token, String videoId, String videoUrl) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    Map<String, String> body = {"videoId": videoId, "videoUrl": videoUrl};
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/save/videos";
    final  response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SaveVideoResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<SavedVideosResponse> getSavedVideos(String email, String token, int pageSize, int pageIndex) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

    Map<String, int> body = {"pageSize": pageSize, "pageIndex": pageIndex};
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/saved/videos";
    final  response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SavedVideosResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<CategoriesResponse> getCategories(String email, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      'emailid':email
    };

   String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/categories";
    final  response = await http.get(Uri.parse(url),
         headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return CategoriesResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<HomeResponse> getCategoryVideos(String email, String token, int pageSize, int pageIndex, String categoryId) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer ' + token,
      'emailid': email
    };
    Map<String, Object> body = {
      "pageSize": pageSize,
      "pageIndex": pageIndex,
      "categoryId": categoryId
    };
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/category/videos";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return HomeResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }


  Future<HomeResponse> getSearchVideos(String email, String token, int pageSize, int pageIndex, String searchTerm) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer ' + token,
      'emailid': email
    };
    Map<String, Object> body = {
      "pageSize": pageSize,
      "pageIndex": pageIndex,
      "searchTerm": searchTerm
    };
    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/search/videos";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return HomeResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }


  Future<SubscriptionResponse> subscribe(String email, String token, String singlePlanId, String subscriptionPlanId) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      "emailId": email
    };
    Map<String, String> body = {"singlePlanId": singlePlanId,"subscriptionPlanId": subscriptionPlanId};

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/provide/subscription";
    final response = await http.post(Uri.parse(url),
        body: json.encode(body), headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SubscriptionResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

  Future<SubscriptionResponse> unsubscribe(String email, String token) async {
    Map<String, String> requestHeaders = {
      "Content-type": "application/json",
      'Authorization': 'Bearer '+token,
      "emailId": email
    };

    String url =
        "https://protectiondogs.club:443/petsProtection/postlogin/unsubscribe";
    final response = await http.get(Uri.parse(url),headers: requestHeaders);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SubscriptionResponse.fromJson(json);
    } else {
      throw Exception("Error logging in user!");
    }
  }

}
