import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/main.dart';
import 'package:pawlly/models/user_data_model.dart';
import 'package:pawlly/utils/constants.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class GoogleSignInAuthService {
  static final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  static Future<UserData> signInWithGoogle() async {
    // Limpiar la caché de inicio de sesión de Google si existe
    await googleSignIn.signOut();

    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await auth.signInWithCredential(credential);
      final User user = authResult.user!;
      assert(!user.isAnonymous);
      final User currentUser = auth.currentUser!;
      assert(user.uid == currentUser.uid);

      log('CURRENTUSER: $currentUser');

      // Identificar si el usuario es nuevo
      bool isNewUser = authResult.additionalUserInfo?.isNewUser ?? false;

      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').isNotEmpty) {
        firstName = currentUser.displayName.splitBefore(' ');
      }
      if (currentUser.displayName.validate().split(' ').length >= 2) {
        lastName = currentUser.displayName.splitAfter(' ');
      }

      /// Crear y devolver un objeto UserData con isNewUser
      UserData tempUserData = UserData()
        ..mobile = currentUser.phoneNumber.validate()
        ..email = currentUser.email.validate()
        ..firstName = firstName.validate()
        ..lastName = lastName.validate()
        ..profileImage = currentUser.photoURL.validate()
        ..loginType = LoginTypeConst.LOGIN_TYPE_GOOGLE
        ..userName = currentUser.displayName.validate()
        ..isNewUser = isNewUser; // Agregar isNewUser al objeto

      return tempUserData;
    } else {
      throw USER_NOT_CREATED;
    }
  }

  static Future<UserData> signInWithApple() async {
    if (await TheAppleSignIn.isAvailable()) {
      AuthorizationResult result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final authResult = await auth.signInWithCredential(credential);
          final User user = authResult.user!;
          assert(!user.isAnonymous);

          final User currentUser = auth.currentUser!;
          assert(user.uid == currentUser.uid);

          log('CURRENTUSER: $currentUser');

          String firstName = '';
          String lastName = '';
          log('result.credential ==> ${result.credential?.toMap()}');
          log('result.credential!.fullName ==> ${result.credential!.fullName!.toMap()}');

          if (result.credential != null && result.credential!.fullName != null) {
            firstName = result.credential!.fullName!.givenName.validate();
            lastName = result.credential!.fullName!.familyName.validate();
          }

          /// Create a temporary request to send
          UserData tempUserData = UserData()
            ..mobile = currentUser.phoneNumber.validate()
            ..email = currentUser.email.validate()
            ..firstName = firstName.validate()
            ..lastName = lastName.validate()
            ..profileImage = currentUser.photoURL.validate()
            ..loginType = LoginTypeConst.LOGIN_TYPE_APPLE
            ..userName = "${firstName.validate()} ${lastName.validate()}";

          return tempUserData;
        case AuthorizationStatus.error:
          throw ("${locale.value.signInFailed}: ${result.error!.localizedDescription}");
        case AuthorizationStatus.cancelled:
          throw (locale.value.userCancelled);
      }
    } else {
      throw locale.value.appleSigninIsNot;
    }
  }
}
