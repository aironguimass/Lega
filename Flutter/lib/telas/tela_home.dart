import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pbl2/services/torneioController.dart';
import 'package:pbl2/widgets/fundo_padrao.dart';
import 'package:pbl2/theme/colors.dart';
import 'package:pbl2/models/model_torneio.dart';
import 'package:pbl2/widgets/card_torneio.dart';
import 'package:pbl2/widgets/efeito_borda.dart';

class TelaHome extends StatelessWidget {
  TelaHome({super.key});
  final TorneioService torneioController = TorneioService();

  @override
  Widget build(BuildContext context) {
    return FundoPadrao(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(
              20.0), // Espaco entre as bordas da tela e o conteudo, podem modificar.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//===============================================================================

              Row(
                // Linha para o ícone do perfil
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      print('Ícone do perfil clicado.');
                    },
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
//===============================================================================

              const SizedBox(
                  height:
                      20), // Espaco entre o ícone do perfil e o titulo. (podem modificar)
//===============================================================================

              const Align(
                //Titulo centralizado "TORNEIOS"
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  'Torneios',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
//===============================================================================

              const SizedBox(
                  height:
                      20), // Espaco entre o titulo e os cards de torneios. (podem modificar)
//===============================================================================

              TextField(
                // Barra de pesquisa para os torneios
                style: const TextStyle(
                  color: Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ),
                ), // Cor do texto digitado pelo usuário
                decoration: InputDecoration(
                  hintText: 'Pesquisar torneios',

                  hintStyle: TextStyle(
                    color: AppColors.letraTransparente,
                  ), // Cor do texto "Pesquisar torneios"
                  prefixIcon: Icon(
                    //icone pesquisar
                    Icons.search,
                    color: AppColors.iconeTransparente,
                  ),
                  filled: true,
                  fillColor: AppColors.fundoCardTransparente,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    borderSide:
                        BorderSide(color: AppColors.bordaWidget, width: 1.0),
                  ),
                ),
              ),
//===============================================================================

              const SizedBox(
                  height:
                      20), // Espaco entre a barra de pesquisa e os cards de torneios. (podem modificar)
//===============================================================================
              Align(
                // Botão de filtro para ordenar os torneios
                alignment: AlignmentGeometry.centerRight,
                child: PopupMenuButton<String>(
                  icon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ordenar por',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(width: 8), // Espaço entre o texto e o ícone
                      Icon(Icons.filter_list,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ],
                  ),
                  //===============================================================================

                  itemBuilder: (BuildContext context) {
                    return {'A-Z', 'Z-A', 'Mais recentes', 'Por Status'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  onSelected: (String escolha) {
                    print(
                        'Opção selecionada: $escolha'); // Ação ao selecionar uma opção de filtro (pode ser modificada)
                  },
                ),
              ),
//===============================================================================

              const SizedBox(height: 5),
//===============================================================================

              // const Divider( //linha divisoria
              //     color: Color.fromARGB(60, 255, 255, 255), thickness: 2.0),
//===============================================================================
              Expanded(
                // card dos torneios
                child: FutureBuilder<List<Torneio>>(
                  future: torneioController.fetchTorneios(),
                  builder: (context, snapshot) {
                    // 1. Enquanto carrega
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    //===============================================================================

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_off,
                                  size: 60, color: Colors.white70),
                              const SizedBox(height: 12),
                              Text(
                                '${snapshot.error}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    //===============================================================================

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: CustomPaint(
                            foregroundPainter: DottedBorderPainter(
                              color: Colors.white30,
                              dashLength: 8.0, //espacamento linha
                              gap: 5.0,
                              radius: 15.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 90,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Sem torneios disponíveis.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //===============================================================================

                    // 2. Se houver erro
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar dados: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    //===============================================================================

                    // 4. Sucesso
                    final listaTorneios = snapshot.data!;

                    return ListView.builder(
                      itemCount: listaTorneios.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final itemTorneio = listaTorneios[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CardTorneio(
                            torneio: itemTorneio,
                            onTap: () {
                              print(
                                  'Clicou no torneio com ID: ${itemTorneio.torneioId}');
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

//===============================================================================
              const SizedBox(height: 10),
//===============================================================================

              // const Divider( //linha divisoria
              //     color: Color.fromARGB(60, 255, 255, 255), thickness: 2.0),
//===============================================================================

              const SizedBox(height: 20),
//===============================================================================

              //botao Meus torneios
              Center(
                child: SizedBox(
                  width: 220,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Botao meus torneios clicado');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.fundoCardTransparente,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                              color: AppColors.bordaWidget, width: 1.0)),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Meus torneios',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
//===============================================================================
      ),
    );
  }
}
