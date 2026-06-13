import 'package:flutter/material.dart';
import 'package:pbl2/theme/colors.dart';
import 'package:pbl2/models/model_torneio.dart';

class CardTorneio extends StatelessWidget {
  final Torneio torneio;
  final VoidCallback onTap;

  const CardTorneio({
    super.key,
    required this.torneio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.fundoCardTransparente,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          // Adicionado const aqui para otimizar
          color: AppColors.bordaWidget,
          width: 0.9,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap, // <--- Agora o Flutter já sabe quem é o onTap!
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //===============================================================================
                //icone cor de fundo
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (torneio.cor ?? const Color.fromARGB(255, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(torneio.icone ?? Icons.help,
                      size: 30, color: Colors.white),
                ),
                //===============================================================================

                const SizedBox(width: 20),
                //===============================================================================

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      torneio.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //===============================================================================
                    const SizedBox(height: 5),
                    //===============================================================================
                    Text(
                      '${torneio.totalEquipas} equipas',
                      style: TextStyle(
                        color: AppColors.letraTransparente,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),

                const Spacer(),
                //===============================================================================

                Icon(Icons.arrow_forward_ios,
                    color: AppColors.iconeTransparente, size: 14),
                const SizedBox(width: 10),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: torneio.corStatus,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
