class Bustime {
    String time;
    String busname;

    Bustime({
        required this.time,
        required this.busname,
    });

    factory Bustime.fromJson(Map<String, dynamic> json) => Bustime(
        time: json["time"],
        busname: json["busname"],
    );

    Map<String, dynamic> toJson() => {
        "time": time,
        "busname": busname,
    };

  
}