import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jaswant Kumar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'SampleItem.itemOne',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'SampleItem.itemTw',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Contact Info',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          title: const Text('9660435911'),
                          onTap: () {
                            try {
                              launchUrl(
                                Uri.parse('tel://+919660435911'),
                              );
                            } catch (e) {
                              //To handle error and display error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          leading: const Icon(Icons.call),
                          trailing: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.whatsapp),
                            onPressed: () async {
                              var whatsappUrl =
                                  "whatsapp://send?phone=+919660435911&text=Hi";
                              try {
                                launchUrl(
                                  Uri.parse(whatsappUrl),
                                );
                              } catch (e) {
                                //To handle error and display error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: const SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Last Payment Date',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        ListTile(
                          title: Text('July 10 2023'),
                          leading: Icon(Icons.calendar_today),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {},
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const Text('Mark as Paid'),
            )
          ],
        ),
      ),
    );
  }
}
