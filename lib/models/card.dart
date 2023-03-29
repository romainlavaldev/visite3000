class CardModel{
  final int cardId;
  final String phone;
  final String mail;
  final String role;
  final String firstname;
  final String lastName;

  CardModel(this.cardId, this.phone, this.mail, this.role, this.firstname, this.lastName);

  String get getPhone => phone;
}