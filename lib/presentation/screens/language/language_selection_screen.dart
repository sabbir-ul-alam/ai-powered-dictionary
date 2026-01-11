import 'package:apd/data/local/db/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_shell.dart';
import '../../state/providers.dart';
import '../home/home_screen.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  final Language? activeLanguage;
  const LanguageSelectionScreen({super.key, this.activeLanguage});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
   Language? _selectedLanguage;

   bool isFirstTime = false;

   @override
   void initState() {
     super.initState();
     _selectedLanguage = widget.activeLanguage;
     print('############$_selectedLanguage');
     if (widget.activeLanguage == null){
       isFirstTime = true;
     }

     print('after if $isFirstTime');
   }



   @override
   Widget build(BuildContext context) {
     final languagesAsync =
     ref.watch(languageRepositoryProvider).listLanguages();

     return Scaffold(
       backgroundColor: const Color(0xFFF7F7F7),

       appBar: AppBar(
         backgroundColor: Colors.transparent,
         elevation: 0,
         leading: isFirstTime
             ? null : IconButton(
           onPressed: () => Navigator.pop(context),
           icon: const Icon(
             Icons.arrow_back_ios,
             color: Colors.black,
           ),
         ),
       ),
       body: SafeArea(
         child: FutureBuilder(
           future: languagesAsync,
           builder: (context, snapshot) {
             if (!snapshot.hasData) {
               return const Center(child: CircularProgressIndicator());
             }

             final languages = snapshot.data!;

             return Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   const SizedBox(height: 48),

                   ClipRRect(
                     borderRadius: BorderRadius.circular(50),
                     child: Container(
                       height: 180,
                       width: double.infinity,

                       margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadiusGeometry.circular(20),

                       ),
                       child: Center(
                         child: Image.asset(
                           'images/language_bubbles.png',
                           fit: BoxFit.cover,
                         ),
                       ),
                     ),
                   ),


                   const SizedBox(height: 32),

                   /// Title
                   const Text(
                     'Choose your language',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 28,
                       fontWeight: FontWeight.w700,
                       height: 1.2,
                       color: Colors.black,
                     ),
                   ),

                   const SizedBox(height: 12),

                   /// Subtitle
                   const Text(
                     'You can change language later.',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       fontSize: 16,
                       color: Color(0xFF6B7280),
                     ),
                   ),

                   const SizedBox(height: 36),

                   /// Language selector
                   GestureDetector(
                     onTap: () => _openLanguageBottomSheet(context, languages),
                     child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(14),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.05),
                             blurRadius: 8,
                             offset: const Offset(0, 4),
                           ),
                         ],
                       ),
                       child: Row(
                         children: [
                           Expanded(
                             child: Text(
                               _selectedLanguage?.code == null
                                   ? 'Select a language'
                                   : languages
                                   .firstWhere((l) => l.code == _selectedLanguage?.code)
                                   .displayName,
                               style: const TextStyle(
                                 fontSize: 16,
                                 fontWeight: FontWeight.w500,
                               ),
                             ),
                           ),
                           const Icon(Icons.keyboard_arrow_down),
                         ],
                       ),
                     ),
                   ),


                   const Spacer(),

                   /// Continue button
                   SizedBox(
                     width: double.infinity,
                     height: 52,
                     child: ElevatedButton(
                       onPressed: _selectedLanguage?.code == null
                           ? null
                           : () async {
                         await _onContinuePressed(context,ref);
                       },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Color(0xFF3B2EFF),
                         disabledBackgroundColor:
                         const Color(0xFFD1D1D5),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(14),
                         ),
                         elevation: 0,
                       ),
                       child: const Text(
                         'Continue',
                         style: TextStyle(
                           fontSize: 16,
                           fontWeight: FontWeight.w600,
                           color: Colors.white,
                         ),
                       ),
                     ),
                   ),

                   const SizedBox(height: 24),
                 ],
               ),
             );
           },
         ),
       ),
     );
   }


   Future<void> _onContinuePressed(
      BuildContext context,
      WidgetRef ref,
      ) async {
    // final lang = _selectedLanguage;
    if (_selectedLanguage == null) return;

    // Persist active language
    await ref
        .read(languageRepositoryProvider)
        .setActiveLanguage(_selectedLanguage!);

    // Trigger reactive refresh
    ref.read(activeLanguageTriggerProvider.notifier).state++;

    // Navigate to Home
    if (context.mounted && isFirstTime) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AppShell(),
        ),
      );
    }
    else {
      Navigator.of(context).pop();
    }
  }
   void _openLanguageBottomSheet(
       BuildContext context,
       List<Language> languages,
       ) {
     showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.transparent,
       builder: (_) {
         return Container(
           height: MediaQuery.of(context).size.height * 0.75,
           decoration: const BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.vertical(
               top: Radius.circular(24),
             ),
           ),
           child: Column(
             children: [
               const SizedBox(height: 8),

               /// Drag handle
               Container(
                 height: 5,
                 width: 40,
                 decoration: BoxDecoration(
                   color: Colors.grey.shade300,
                   borderRadius: BorderRadius.circular(100),
                 ),
               ),

               const SizedBox(height: 16),

               /// Header
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Row(
                   children: [
                     const Expanded(
                       child: Text(
                         'Select Language',
                         style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.w700,
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: () => Navigator.pop(context),
                       child: const Icon(Icons.close),
                     ),
                   ],
                 ),
               ),

               const SizedBox(height: 16),

               /// Search (visual only)
               // Padding(
               //   padding: const EdgeInsets.symmetric(horizontal: 20),
               //   child: Container(
               //     padding: const EdgeInsets.symmetric(horizontal: 16),
               //     height: 48,
               //     decoration: BoxDecoration(
               //       color: const Color(0xFFF3F4F6),
               //       borderRadius: BorderRadius.circular(14),
               //     ),
               //     child: const Row(
               //       children: [
               //         Icon(Icons.search, color: Colors.grey),
               //         SizedBox(width: 12),
               //         Text(
               //           'Search language',
               //           style: TextStyle(
               //             color: Colors.grey,
               //             fontSize: 16,
               //           ),
               //         ),
               //       ],
               //     ),
               //   ),
               // ),

               // const SizedBox(height: 12),

               /// Language list
               Expanded(
                 child: ListView.separated(
                   padding: const EdgeInsets.symmetric(vertical: 8),
                   itemCount: languages.length,
                   separatorBuilder: (_, __) =>
                   const Divider(height: 1),
                   itemBuilder: (context, index) {
                     final language = languages[index];

                     return ListTile(
                       onTap: () {
                         setState(() {
                           _selectedLanguage = language;
                         });
                         Navigator.pop(context);
                       },
                       leading: Icon(
                         _selectedLanguage?.code == language.code
                             ? Icons.check_circle
                             : Icons.circle_outlined,
                       ),

                       title: Text(
                         language.displayName,
                         style: const TextStyle(
                           fontSize: 16,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     );
                   },
                 ),
               ),
             ],
           ),
         );
       },
     );
   }




}


