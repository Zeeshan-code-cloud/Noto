
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notyee/screns/controllers.dart';

class Notesdetailsscreen extends GetView<NotesController> {
   const Notesdetailsscreen({super.key});

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: const Color(0xffF8F8FC),

       appBar: AppBar(
         backgroundColor: Colors.transparent,
         elevation: 0,
         leading: IconButton(
           onPressed: () => Navigator.pop(context),
           icon: const Icon(
             Icons.arrow_back_ios_new,
             color: Color(0xff0F172A),
           ),
         ),
         actions: [

           /// Undo
           ValueListenableBuilder<UndoHistoryValue>(
             valueListenable: controller.undoController,
             builder: (context, value, child) {
               return IconButton(
                 onPressed: value.canUndo ? () => controller.undoController.undo() : null,
                 icon: Icon(
                   Icons.undo,
                   color: value.canUndo ? const Color(0xff0F172A) : Colors.grey,
                 ),
               );
             },
           ),

           /// Redo
           ValueListenableBuilder<UndoHistoryValue>(
             valueListenable: controller.undoController,
             builder: (context, value, child) {
               return IconButton(
                 onPressed: value.canRedo ? () => controller.undoController.redo() : null,
                 icon: Icon(
                   Icons.redo,
                   color: value.canRedo ? const Color(0xff0F172A) : Colors.grey,
                 ),
               );
             },
           ),

           Obx(() {
             if (controller.editingNote.value != null) {
               return PopupMenuButton(
                 onSelected: (value) {
                   if (value == 'delete') {
                     controller.deleteCurrentNote();
                   }
                 },
                 itemBuilder: (context) => [
                   const PopupMenuItem(
                     value: 'delete',
                     child: Text('Delete Note'),
                   ),
                 ],
               );
             }
             return const SizedBox();
           }),
         ],
       ),

       body: Padding(
         padding: const EdgeInsets.symmetric(
           horizontal: 20,
         ),
         child: Column(
           crossAxisAlignment:
           CrossAxisAlignment.start,
           children: [

             /// Title
             TextField(
               controller: controller.titleController,
               style: const TextStyle(
                 fontSize: 28,
                 fontWeight: FontWeight.w700,
               ),
               decoration: const InputDecoration(
                 hintText: "Title",
                 border: InputBorder.none,
               ),
             ),

             const SizedBox(height: 4),

             /// Timestamp
             Obx(() {
               final date = controller.editingNote.value?.createdAt ?? DateTime.now();
               final formattedTime = DateFormat('hh:mm a').format(date);
               final label = controller.getTimeLabel(date);
               return Text(
                 "$label, $formattedTime",
                 style: TextStyle(
                   color: Colors.grey.shade600,
                   fontSize: 14,
                 ),
               );
             }),

             const SizedBox(height: 20),

             /// Content
             Expanded(
               child: TextField(
                 controller: controller.noteController,
                 undoController: controller.undoController,
                 expands: true,
                 maxLines: null,
                 minLines: null,
                 keyboardType:
                 TextInputType.multiline,
                 style: const TextStyle(
                   fontSize: 17,
                   height: 1.6,
                 ),
                 decoration: const InputDecoration(
                   hintText:
                   "Start writing your thoughts...",
                   border: InputBorder.none,
                 ),
               ),
             ),

             /// Selected Image
             Obx(() {
               if (controller.selectedImage.value != null) {
                 return Stack(
                   children: [
                     ClipRRect(
                       borderRadius:
                       BorderRadius.circular(16),
                       child: Image.file(
                         controller.selectedImage.value!,
                         height: 180,
                         width: double.infinity,
                         fit: BoxFit.cover,
                       ),
                     ),

                     Positioned(
                       top: 8,
                       right: 8,
                       child: InkWell(
                         onTap: controller.removeImage,
                         child: Container(
                           padding:
                           const EdgeInsets.all(6),
                           decoration:
                           const BoxDecoration(
                             color: Colors.black54,
                             shape: BoxShape.circle,
                           ),
                           child: const Icon(
                             Icons.close,
                             color: Colors.white,
                             size: 18,
                           ),
                         ),
                       ),
                     ),
                   ],
                 );
               }
               return const SizedBox();
             }),

             const SizedBox(height: 12),
           ],
         ),
       ),

       bottomNavigationBar: Container(
         height: 75,
         padding: const EdgeInsets.symmetric(
           horizontal: 20,
         ),
         decoration: const BoxDecoration(
           color: Colors.white,
           border: Border(
             top: BorderSide(
               color: Color(0xffECECEC),
             ),
           ),
         ),

         child: Row(
           children: [

             /// Pick Image
             IconButton(
               onPressed: controller.pickImage,
               icon: const Icon(
                 Icons.image_outlined,
                 size: 28,
               ),
             ),

             const Spacer(),

             /// Save Button
             ElevatedButton.icon(
               onPressed: controller.addOrUpdateNotes,
               icon: const Icon(Icons.save),
               label: const Text("Save"),
               style: ElevatedButton.styleFrom(
                 backgroundColor:
                 const Color(0xFF7C5CFF),
                 foregroundColor: Colors.white,
                 padding:
                 const EdgeInsets.symmetric(
                   horizontal: 20,
                   vertical: 12,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

 }

