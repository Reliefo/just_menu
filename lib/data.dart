class JustMenu {
  String oid;
  String name;
  List<String> menu;
  DateTime created;
  List visits;
  String qr;

  JustMenu({
    this.oid,
    this.name,
    this.menu,
    this.created,
    this.visits,
    this.qr,
  });

  JustMenu.fromJson(Map<String, dynamic> json) {
    if (json['_id']['\$oid'] != null) {
      oid = json['_id']['\$oid'];
    }
    print("objectcc");
    if (json['name'] != null) {
      name = json['name'];
    }
    print("objectcc2");
    if (json['menu'] != null) {
      menu = new List<String>();
      json['menu'].forEach((v) {
        menu.add(v);
      });
    }
    print("objectcc3");
    if (json['created'] != null) {
      created = DateTime.parse(json['created']);
    }

    if (json['qr'] != null) {
      qr = json['qr'];
    }

    print("objectcc4");
  }
}
