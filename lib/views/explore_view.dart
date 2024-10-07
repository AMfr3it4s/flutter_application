import 'package:flutter/material.dart';
import 'package:flutter_application/constants/routes.dart';
import 'package:flutter_application/services/auth/auth.service.dart';
import 'package:flutter_application/views/resume_view.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Text(
            'Health Care Categories',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(47, 62, 70, 1),
            ),
          ),
          const SizedBox(height: 50),
          // Activity Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), // Cor de fundo do card
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(activityRoute);
              },
              child: const SizedBox(
                width: 500,
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.local_fire_department,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 60, // Tamanho do ícone
                      ),
                    ),
                    Text(
                      'Activity',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Espaço entre os cards
          // Heart Rate Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), // Cor de fundo do card
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(heartRoute);
              },
              child: const SizedBox(
                width: 500,
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.heart_broken_rounded,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 60, // Tamanho do ícone
                      ),
                    ),
                    Text(
                      'Heart Rate',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Nutrition Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), // Cor de fundo do card
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(nutritionRoute); // Ajuste conforme sua rota de nutrição
              },
              child: const SizedBox(
                width: 500,
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.local_restaurant_rounded,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 60, // Tamanho do ícone
                      ),
                    ),
                    Text(
                      'Nutrition',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Settings Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), // Cor de fundo do card
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () {
                Navigator.of(context).pushNamed(settingsRoute); // Ajuste conforme sua rota de configurações
              },
              child: const SizedBox(
                width: 500,
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.settings,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 60, // Tamanho do ícone
                      ),
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Logout Card
          Card(
            color: const Color.fromRGBO(47, 62, 70, 1), // Cor de fundo do card
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: const Color.fromRGBO(47, 62, 70, 0.8),
              onTap: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
              },
              child: const SizedBox(
                width: 500,
                height: 100,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Color.fromRGBO(249, 110, 70, 1),
                        size: 60, // Tamanho do ícone
                      ),
                    ),
                    Text(
                      'LogOut',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
