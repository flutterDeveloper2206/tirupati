import 'package:flutter/material.dart';
import 'package:crm_demo/screens/appFlow/menu/new_clients_details/content/client_proposal_dropdown_and_form_list.dart';
import 'package:crm_demo/screens/appFlow/menu/new_clients_details/content/client_proposal_product_list.dart';
import 'package:crm_demo/screens/appFlow/menu/new_clients_details/provider/client_create_proposal_provider.dart';
import 'package:provider/provider.dart';


class ClientCreateProposalScreen extends StatelessWidget {
  int clientId;
  ClientCreateProposalScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Proposal", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: ChangeNotifierProvider(
        create: (_) => ClientCreateProposalProvider(),
        child: Consumer<ClientCreateProposalProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ClientProposalDropDownAndFormList(provider: provider,),
                    Container(
                      margin: const EdgeInsets.symmetric( horizontal: 14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14,),
                           ClientProposalProductList(clientCreateProposalProvider: provider, clientId: clientId, wareHouseId: provider.clientInvoiceWarehouse?.id ?? 0 ,),
                          ],
                        ),
                      ),
                    ),
                    const  SizedBox(height: 20,)
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
