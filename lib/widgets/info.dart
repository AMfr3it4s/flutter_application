import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
         statBox(const Stats(value: "345", unit: "Kcal", label: "Burned")),
         statBox(const Stats(value: "3.6", unit: "Km", label: "Distance")),
         statBox(const Stats(value: "1.5", unit: "Hr", label: "Hours")),
        ],
    );
  }
}

class Stats extends StatelessWidget {
  final String value;
  final String unit;
  final String label;


  const Stats({
    super.key,
    required this.value,
    required this.unit, 
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
           TextSpan(text: value,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.white
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(text:unit,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500, color: Colors.white)),
          ]
          ),
        ),
        const SizedBox(height:2),
        Text(label, 
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          
        ),
      ),
      ],
    );
  }
}

Widget statBox(Stats stats){
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromRGBO(47, 62, 70, 1), // Cor de fundo
      borderRadius: BorderRadius.circular(10), // Bordas arredondadas
      border: Border.all(color: Colors.grey, width: 1), // Cor e largura da borda
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // Sombra
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 3), // Posição da sombra
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10), // Espaçamento interno
    child: stats,
  );
}